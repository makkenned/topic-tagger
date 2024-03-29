#Wikipedia pages clustering#

This project aims to cluster millions of wikipedia pages using LDA on Spark.

This repo includes the instructions to set up the cluster for spark. This is node very easily. Adding more nodes is also very easy.

The folder `nb` contains the spark algorithm.

For the configuration of the machines, read the bottom of this file. In short, a cluster of several nodes was created, all of them HDFS datanodes. The master is called h1.

Process:

- Download compressed XML Wikipedia dump
- Uncompress the dump data
- Split the huge xml file into 12 million of different pages, each page in a different file.
- Convert each xml file into a single-line file. Sparks requires this format. `parse_file` does this.
- Move these files to hdfs:///root/wiki/pages
- Execute the spark application

The output contains a list of inffered topics along with the most relevant words for each of them. Like this

```
TOPIC:
player	0.004859839691254771
english	0.004601964695540358
author	0.0033215327384382358
actor	0.0032786054156276395
into	0.0030445904741979724
university	0.002864692588770148
actress	0.0027492395599874554
```

##About the data

I used the latest avaiable XML Wikipedia dump available under the directory [https://dumps.wikimedia.org/backup-index.html](https://dumps.wikimedia.org/backup-index.html).

I used [https://dumps.wikimedia.org/enwiki/20151102/enwiki-20151102-pages-articles.xml.bz2](https://dumps.wikimedia.org/enwiki/20151102/enwiki-20151102-pages-articles.xml.bz2).

This file contains the dump of all the pages along with their contents. It is 11.6 GB compressed and 52GB uncompressed. It took around 2 hours to download the big file.

## Pre-process

A huge file is not easy to work with, thus we use xml_split to create an xml file for each page. This is needed because Spark will process each line of each file independently, thus each page must be described in a single line.

### Installation of xml_split
```
wget ftp://ftp.muug.mb.ca/mirror/centos/7.1.1503/os/x86_64/Packages/perl-XML-Twig-3.44-2.el7.noarch.rpm
yum install perl-XML-Twig-3.44-2.el7.noarch.rpm

```

### Split

In a large disk, I executed

```
yum install -y bzip2
bunzip2 enwiki-20151102-pages-articles.xml.bz2
xml_split enwiki-20140203-pages-articles.xml
```

##Configuration of the VSs


This assumes a cluster of 8 nodes. The hostnames are defined in the `provision` files. If more clusters want to be added, the only change you need is to update the hostnames in both files.

###1. Configuration for any node

Whenever a password it's required, use 13241234.

```
yum install -y git vim
cd /tmp
git clone https://github.com/a20012251/topic-tagger.git
cd topic-tagger
bash provision.sh
su - hduser
cd /tmp/topic-tagger
bash provision_hduser.sh
```

###2. Master configuration###

Using hduser

```
bash setup_master_hduser.sh
start-yarn.sh
start-dfs.sh
```

Using root

```
source /root/.bash_profile
bash  setup_master_spark.sh
```

At this point hdfs has a folder /root that can be accessed by root, who can use Spark. hduser can use Spark as well.

###3. Some useful commands/scripts

HDFS report
```
hdfs dfsadmin -report
```

To manually starting a datanode
```
hadoop-daemon.sh start datanode
```

To inspect running HDFS services
```
jps
```

To start spark on master
```
/usr/local/spark/sbin/start-all.sh
```

To execute spark-submit usind hduser
```
SPARK_HOME=/usr/local/spark
$SPARK_HOME/bin/spark-submit --class "SimpleApp" --master spark://host2:7077 $(find target -iname "*.jar")
```

Add Scala support for Vim
```
mkdir -p ~/.vim/{ftdetect,indent,syntax} && for d in ftdetect indent syntax ; do wget -O ~/.vim/$d/scala.vim https://raw.githubusercontent.com/derekwyatt/vim-scala/master/$d/scala.vim; done
```
