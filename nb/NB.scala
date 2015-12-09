import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import scala.xml._

import org.apache.lucene.analysis.en.EnglishAnalyzer  
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute  
import scala.collection.mutable.ArrayBuffer

import org.apache.spark.mllib.classification.NaiveBayes  
import org.apache.spark.mllib.classification.LogisticRegressionWithSGD 
import org.apache.spark.mllib.regression.LabeledPoint 
import org.apache.spark.mllib.feature.{IDF, HashingTF}
import org.apache.spark.mllib.clustering.{LDA, DistributedLDAModel, EMLDAOptimizer, OnlineLDAOptimizer, LocalLDAModel}
import org.apache.spark.mllib.linalg.Vectors

object Stemmer {

  // Adopted from
  // https://chimpler.wordpress.com/2014/06/11/classifiying-documents-using-naive-bayes-on-apache-spark-mllib/

  def tokenize(content:String):Seq[String]={
    val analyzer=new EnglishAnalyzer()
    val tokenStream=analyzer.tokenStream("contents", content)
    // CharTermAttribute is what we're extracting
    val term=tokenStream.addAttribute(classOf[CharTermAttribute])

    tokenStream.reset() // must be called by the consumer before consumption to clean the stream

    var result = ArrayBuffer.empty[String]

    while(tokenStream.incrementToken()) {
        val termValue = term.toString
        if (!(termValue matches ".*[\\d\\.].*") && termValue.length > 3) {
          result += term.toString
        }
    }
    tokenStream.end()
    tokenStream.close()
    result
  }
}

object NB {

  def main(args: Array[String]) {
    val file = "hdfs://h1:8020/root/wiki/pages/???.xml"
    val nTopics = 5
      val conf = new SparkConf().setAppName("LDA")
      conf.set("spark.driver.maxResultSize", "0")
      val sc = new SparkContext(conf)

      val hashingTF = new HashingTF()

      val titled_pages = sc.textFile(file)
        .map(XML.loadString(_))
        .filter(_.label == "page")
        .filter(xml => (xml \ "redirect").isEmpty) 
        .map(xml => ((xml \ "title").text, (xml \ "revision" \ "text").text))
        .cache()

      println("number of partitions " + titled_pages.partitions.length)
      println("default min partitions " + sc.defaultMinPartitions)

      println("loaded xml pages")

      var documents = titled_pages.map {
	case (title, content) =>  Stemmer.tokenize(content)
      }
      var content_frequency_vector = documents.map { 
        content => hashingTF.transform(content)
      }

      println("loaded frequency vector")

      val corpus = content_frequency_vector.zipWithIndex.map(_.swap).cache()

      println("loaded corpus")

      val ldamodel = new LDA()
	      .setK(nTopics)
	      .setMaxIterations(10)
	      //.setOptimizer(new OnlineLDAOptimizer().setMiniBatchFraction(0.3))
	      .run(corpus)		
      val model = ldamodel//.asInstanceOf[LocalLDAModel]
      println("loaded model")

      val w2i = documents.flatMap(
        content => content.distinct
      ).distinct.map(word => (word, hashingTF.indexOf(word)))
      val i2w = w2i.map(_.swap).collectAsMap()
      println("" + i2w.size + " actual different words")

      println("Learned topics (as distributions over vocab of " + model.vocabSize + " words):")
      val topics = model.describeTopics().foreach { case (terms, weights) => 
	println("Topic:")
      	terms.zip(weights).take(20).foreach{ case (term, weigth) => 
		val option = i2w.get(term)
		if (!option.isEmpty)
			println(option.get + "\t\t" + weigth)
	}
      	println("-----------------")
	println()
      }
      val local = model

      // test
      /* 
      val testFile = sc.textFile("hdfs://h1:8020/root/wiki/test.txt")
      val testVector = testFile.map{ x => 
          val stemmed = Stemmer.tokenize(x)
          println(stemmed)
          hashingTF.transform(stemmed)
      }.zipWithIndex.map(_.swap).cache()

      val result = local.topicDistributions(testVector).collect.foreach { case (id, vec) =>
       println ("Res Topic " + id + ":" + vec)
      }
      */
  }
}
