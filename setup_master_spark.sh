#! /bin/bash

cat <<EOT >$SPARK_HOME/conf/slaves
h1
h2
host3
host4
EOT

ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa
for i in host2 host3 host4 host5 host6 host7 host8 host9 localhost; do ssh-copy-id $i; done

cat <<EOT >> ~/.bash_profile
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin
EOT
