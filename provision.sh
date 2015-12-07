#! /bin/bash

# add each host to the hosts files
cat <<EOT >> /etc/hosts
158.85.193.242 host1 host1.mids.com
158.85.193.253 host2 host2.mids.com
158.85.193.229 host3 host3.mids.com
158.85.193.252 host4 host4.mids.com
158.85.193.254 host5 host5.mids.com
158.85.193.231 host6 host6.mids.com
158.85.193.232 host7 host7.mids.com
158.85.193.240 host8 host8.mids.com
158.85.193.239 host9 host9.mids.com
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

