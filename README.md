# topic-tagger
topic tagger


# Instructions to configure a node

```
yum install -y git
cd /tmp
git clone https://github.com/a20012251/topic-tagger.git
cd topic-tagger
bash provision.sh
su - hduser
ssh localhost
exit
bash provision_hduser.sh
exit
start-yarn.sh
start-dfs.sh
stop-yarn.sh
stop-dfs.sh
```
