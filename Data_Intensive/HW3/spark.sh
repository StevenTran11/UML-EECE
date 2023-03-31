#!/bin/bash

# Check if Spark is already installed
if test -d "/usr/local/spark";
    then echo " **** spark extracted and moved **** ";
else
    # Download Spark and extract it
    wget https://archive.apache.org/dist/spark/spark-2.4.8/spark-2.4.8-bin-hadoop2.7.tgz
    tar xzf spark-2.4.8-bin-hadoop2.7.tgz
    sudo mv spark-2.4.8-bin-hadoop2.7 /usr/local/spark;
    sudo chown -R Stran /usr/local/spark;
fi

# Configure Spark
SPARK_INSTALL_DIR=/usr/local/spark;
echo 'export SPARK_HOME=/usr/local/spark' >> ~/.bashrc
echo 'export PATH=$PATH:$SPARK_HOME/bin' >> ~/.bashrc
source ~/.bashrc