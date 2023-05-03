#!/bin/bash

# Update Ubuntu
sudo apt-get update -y;
sudo apt-get upgrade -y;
sudo apt-get install sqlite3 -y

# Verify installation
sqlite3 --version

sudo apt-get install netpbm -y
wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bash_profile
source ~/.bash_profile
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

sudo apt-get install nodejs -y
sudo apt-get install npm -y

sudo apt-get install -y python3-pip tar gzip bzip2 dictzip