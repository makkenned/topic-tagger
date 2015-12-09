#! /bin/bash

# using hduser
ssh-keygen -t rsa -P "" -f /home/hduser/.ssh/id_rsa
for i in host2 host3 host4 host5 host6 host7 host8 host9 localhost; do ssh-copy-id $i; done

cat <<EOT >/usr/local/hadoop/etc/hadoop/slaves
host3
host4
h1
h2
h3 
h4
EOT

hdfs namenode -format

hdfs dfs -mkdir /root
hdfs dfs -chown -R root /root

