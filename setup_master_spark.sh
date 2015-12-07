#! /bin/bash

cat <<EOT >$SPARK_HOME/conf/slaves
host2
host3
host4
host5
host6
host7
host8
host9
EOT

for i in host2 host3 host4 host5 host6 host7 host8 host9 localhost; do ssh-copy-id $i; done
