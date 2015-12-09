#! /bin/bash

cat <<EOT >$SPARK_HOME/conf/slaves
h1
h2
host3
host4
EOT

ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa
for i in host2 host3 host4 host5 host6 host7 host8 host9 localhost; do ssh-copy-id $i; done
