#!/bin/bash

# Check if Hadoop is already installed
if test -d "/usr/local/hadoop";
    then echo " **** hadoop extracted and moved **** ";
else
    # Download Hadoop and extract it
    wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz;
    tar xvfz hadoop-2.7.3.tar.gz;
    sudo mv hadoop-2.7.3 /usr/local/hadoop;
    sudo chown -R Stran /usr/local/hadoop
fi

# Configure Hadoop
HADOOP_INSTALL_DIR=/usr/local/hadoop;
echo 'export HADOOP_HOME=/usr/local/hadoop' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> ~/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export YARN_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> ~/.bashrc
echo 'export HADOOP_INSTALL=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> ~/.bashrc
source ~/.bashrc

# Append "export JAVA_HOME" line to mapred-env.sh, hadoop-env.sh and yarn-env.sh
export_line="export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre"

# Check if the line is already present in the files
if ! grep -qF "$export_line" ${HADOOP_INSTALL_DIR}/etc/hadoop/mapred-env.sh; then
    echo "$export_line" >> ${HADOOP_INSTALL_DIR}/etc/hadoop/mapred-env.sh
fi

if ! grep -qF "$export_line" ${HADOOP_INSTALL_DIR}/etc/hadoop/hadoop-env.sh; then
    echo "$export_line" >> ${HADOOP_INSTALL_DIR}/etc/hadoop/hadoop-env.sh
fi

if ! grep -qF "$export_line" ${HADOOP_INSTALL_DIR}/etc/hadoop/yarn-env.sh; then
    echo "$export_line" >> ${HADOOP_INSTALL_DIR}/etc/hadoop/yarn-env.sh
fi