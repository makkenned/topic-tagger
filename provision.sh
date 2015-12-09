#! /bin/bash

# add each host to the hosts files
cat <<EOT >> /etc/hosts
158.85.193.229 host3 host3.mids.com
158.85.193.252 host4 host4.mids.com
169.54.140.186 h2 h2.mids.com
169.54.140.185 h1 h1.mids.com
169.54.140.164 h3 h3.mids.com
169.54.140.165 h4 h4.mids.com
EOT

# format the secondary disk that will be used by hdfs
mkdir /data
mkfs.ext4 /dev/xvdc

# add the new disk to the filesystem table
cat <<EOT >> /etc/fstab
	/dev/xvdc /data                   ext4    defaults,noatime        0 0
EOT

# mount the new folder
mount /data
chmod 1777 /data

# install Java
yum install -y rsync net-tools java-1.8.0-openjdk-devel http://pkgs.repoforge.org/nmon/nmon-14g-1.el7.rf.x86_64.rpm

# create a hadoop user with sudo permissions for ease
adduser hduser

sudo sh -c "echo \"group ALL=(hduser) NOPASSWD: ALL\" >> /etc/sudoers"

echo "12341234" | passwd hduser --stdin

# install hadoop
curl http://apache.claz.org/hadoop/core/hadoop-2.7.1/hadoop-2.7.1.tar.gz | tar -zx -C /usr/local --show-transformed --transform='s,/*[^/]*,hadoop,'
chown -R hduser.hduser /data
chown -R hduser.hduser /usr/local/hadoop

# spark install
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
yum install -y sbt
curl http://d3kbcqa49mib13.cloudfront.net/spark-1.5.0-bin-hadoop2.6.tgz | tar -zx -C /usr/local --show-transformed --transform='s,/*[^/]*,spark,'
echo export SPARK_HOME=\"/usr/local/spark\" >> /root/.bash_profile
source /root/.bash_profile
