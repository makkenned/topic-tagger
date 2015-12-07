Topic tagger


Instructions to configure a node. Whenever a password it's required, use 13241234.

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

Then on master
```
bash setup_master.sh
```

For manually starting a datanode
```
hadoop-daemon.sh start datanode
```
