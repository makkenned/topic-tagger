#! /bin/bash

#sbt package && $SPARK_HOME/bin/spark-submit --class "NB" --master spark://host2:7077 $(find target -iname "*.jar")
$SPARK_HOME/bin/spark-submit --driver-memory 2G --executor-memory 2G --master spark://host2:7077 $(find target -iname "*assembly*.jar")
