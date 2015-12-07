#! /bin/bash

ssh-keygen -t rsa -P "" -f /home/hduser/.ssh/id_rsa
for i in host1 host2; do ssh-copy $i; done
# password is 12341234
