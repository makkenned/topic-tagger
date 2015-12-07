#! /bin/bash

su - hduser
ssh-keygen -t rsa -P "" -f /home/hduser/.ssh/id_rsa
for i in host1 host2 host3 localhost; do ssh-copy-id $i; done
# password is 12341234
