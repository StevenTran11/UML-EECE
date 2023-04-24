#!/bin/bash

# Update Ubuntu
sudo apt-get update -y;
sudo apt-get upgrade -y;

#wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz
#sudo tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz
#echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
# Install Go
sudo apt-get -y install golang

# Set up environment variables
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
go version

# Pull repository and Export
go get github.com/timescale/tsbs
cd $GOPATH/src/github.com/timescale/tsbs
make
echo 'export PATH=$PATH:'$(pwd)'/bin' >> ~/.bashrc
source ~/.bashrc

sudo add-apt-repository -y ppa:timescale/timescaledb-ppa
sudo apt-get update -y
sudo apt install timescaledb-postgresql-12 -y
sudo timescaledb-tune --quiet --yes
# Restart PostgreSQL for changes to take effect
sudo systemctl enable postgresql.service
sudo systemctl restart postgresql.service

# Start PostgreSQL server
sudo service postgresql start

# Wait for the server to start up
sleep 5

# Connect to PostgreSQL and create database and user
sudo -u postgres psql -c "CREATE DATABASE timescaledb;"
#sudo -u postgres psql -c "CREATE USER postgres WITH PASSWORD 'timescale';"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'timescale';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE timescaledb TO postgres;"

# Set PostgreSQL configurations to match YAML file
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/g" /etc/postgresql/12/main/postgresql.conf
sudo sed -i "s/#port = 5432/port = 5432/g" /etc/postgresql/12/main/postgresql.conf
sudo sed -i "s/#ssl = off/ssl = on/g" /etc/postgresql/12/main/postgresql.conf