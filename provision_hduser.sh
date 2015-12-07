#! /bin/bash

# update the hadoop user environment
echo "export JAVA_HOME=\"$(readlink -f $(which javac) | grep -oP '.*(?=/bin)')\"" >> ~/.bash_profile

cat <<EOT >> ~/.bash_profile
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_MAPRED_HOME=\$HADOOP_HOME
export HADOOP_HDFS_HOME=\$HADOOP_HOME
export YARN_HOME=\$HADOOP_HOME
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin
EOT

source ~/.bash_profile
$JAVA_HOME/bin/java -version

# Update the config files for a single-node cluster
cd $HADOOP_HOME/etc/hadoop
echo "export JAVA_HOME=\"$JAVA_HOME\"" > ./hadoop-env.sh

cat <<EOT >core-site.xml
<?xml version="1.0"?>
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://master/</value>
  </property>
</configuration>
EOT

cat <<EOT >yarn-site.xml
<?xml version="1.0"?>
<configuration>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>master</value>
  </property>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>
EOT

cat <<EOT >mapred-site.xml
<?xml version="1.0"?>
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
EOT

cat <<EOT >hdfs-site.xml
<?xml version="1.0"?>
<configuration>
  <property>
      <name>dfs.datanode.data.dir</name>
      <value>file:///data/datanode</value>
  </property>

  <property>
      <name>dfs.namenode.name.dir</name>
      <value>file:///data/namenode</value>
  </property>

  <property>
      <name>dfs.namenode.checkpoint.dir</name>
      <value>file:///data/namesecondary</value>
  </property>
</configuration>
EOT

# Format the namenode
hdfs namenode -format
