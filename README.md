#Topic tagger#


##Configuration of the VS


This assumes a cluster of 8 nodes. The hostnames are defined in the `provision` files. If more clusters want to be added, the only change you need is to update the hostnames in both files.

###1. Configuration for any node

Whenever a password it's required, use 13241234.

```
yum install -y git
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
bash setup_master.sh
hdfs namenode -format
start-yarn.sh
start-dfs.sh
```

Using root

```
bash  setup_master_spark.sh
```

###3. Some useful scripts

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
