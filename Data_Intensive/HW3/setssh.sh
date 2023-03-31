#!/bin/bash

#generate key
sudo chown -R Stran /users/Stran/.ssh
/usr/bin/geni-get key > ~/.ssh/id_rsa;
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa;
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub;
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys;