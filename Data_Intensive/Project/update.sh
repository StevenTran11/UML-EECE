#!/bin/bash

# Update Ubuntu
sudo apt-get update -y;
sudo apt-get upgrade -y;
sudo apt-get install sqlite3 -y

# Verify installation
sqlite3 --version

sudo apt-get install netpbm -y
sudo apt-get install golang -y
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

sudo apt-get install nodejs -y
sudo apt-get install npm -y

sudo apt-get install -y python3-pip tar gzip bzip2 dictzip