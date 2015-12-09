lazy val common = Seq(
  name := "Naive Bayes Classifier",
  version := "1.0",
  scalaVersion := "2.10.4",
  libraryDependencies ++= Seq(
    "org.apache.spark" %% "spark-core" % "1.5.0" % "provided",
    "org.apache.spark" %% "spark-mllib" % "1.5.0",
    "org.apache.lucene" % "lucene-core" % "5.1.0",
    "org.apache.lucene" % "lucene-analyzers-common" % "5.1.0"
  ),
  resolvers += "Akka Repository" at "http://repo.akka.io/releases/",
  resolvers += "Maven central" at "http://repo1.maven.org/maven2/",
  resolvers += "Java.net Maven2 Repository" at "http://download.java.net/maven/2/"   ,
  mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
    {
      case PathList("META-INF", xs @ _*) => MergeStrategy.discard
      case x => MergeStrategy.first
    }
  }
) 


lazy val NB = (project in file(".")).
  settings(common: _*).
    settings(
        name := "NB",
            mainClass in (Compile, run) := Some("NB.NB"))
