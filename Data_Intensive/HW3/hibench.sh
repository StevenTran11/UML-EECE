#!/bin/bash

ip_address=$(ip addr show | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 | sed -n 2p)

git clone https://github.com/Intel-bigdata/HiBench.git

cd /users/Stran/HiBench
mvn -Psparkbench -Dhadoop=2.7 -Dspark=2.4 -Dscala=2.11 clean package

cd /users/Stran/HiBench/conf

# Replace placeholders in hadoop.conf.template with actual values
HADOOP_HOME="/usr/local/hadoop"
sed -i "s|/PATH/TO/YOUR/HADOOP/ROOT|$HADOOP_HOME|g" hadoop.conf.template
sed -i "s/localhost:8020/$ip_address:9000/g" hadoop.conf.template

# Replace placeholders in spark.conf.template with actual values
SPARK_HOME="/usr/local/spark"
sed -i "s|/PATH/TO/YOUR/SPARK/HOME|$SPARK_HOME|g" spark.conf.template

if [ -f hadoop.conf ]; then
    sudo rm hadoop.conf
fi

if [ -f spark.conf ]; then
    sudo rm spark.conf
fi

cp hadoop.conf.template hadoop.conf
cp spark.conf.template spark.conf