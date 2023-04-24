#!/bin/bash

# Update Ubuntu
sudo apt-get update -y;
sudo apt-get upgrade -y;

sudo apt install golang
go version
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
source ~/.bashrc

# Pull repository and Export
go get github.com/timescale/tsbs
cd $GOPATH/src/github.com/timescale/tsbs
make
echo 'export PATH=$PATH:'$(pwd)'/bin' >> ~/.bashrc
source ~/.bashrc

# Start PostgreSQL server
sudo service postgresql start

# Wait for the server to start up
sleep 5

# Connect to PostgreSQL and create database and user
sudo -u postgres psql -c "CREATE DATABASE timescaledb;"
sudo -u postgres psql -c "CREATE USER postgres WITH PASSWORD 'timescale';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE benchmarkdb TO postgres;"

# Set PostgreSQL configurations to match YAML file
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/g" /etc/postgresql/12/main/postgresql.conf
sudo sed -i "s/#port = 5432/port = 5432/g" /etc/postgresql/12/main/postgresql.conf
sudo sed -i "s/#ssl = off/ssl = on/g" /etc/postgresql/12/main/postgresql.conf

sudo add-apt-repository -y ppa:timescale/timescaledb-ppa
sudo apt update -y
sudo apt install timescaledb-postgresql-12 -y
sudo timescaledb-tune --quiet --yes
# Restart PostgreSQL for changes to take effect
sudo systemctl restart postgresql.service
