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

# Configure Spark Cluster

# Check if spark-env.sh file exists
if test -f "/usr/local/spark/conf/spark-env.sh"; then
    echo "spark-env.sh file exists"
else 
    cp /usr/local/spark/conf/spark-env.sh.template /usr/local/spark/conf/spark-env.sh
fi

export_line="export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre"
# Append "export JAVA_HOME" line to spark-env.sh.template
# Check if the line is already present in the files
if ! grep -qF "$export_line" ${SPARK_INSTALL_DIR}/conf/spark-env.sh; then
    echo "$export_line" >> ${SPARK_INSTALL_DIR}/conf/spark-env.sh
fi

echo "Finished appending the export line to the necessary files."