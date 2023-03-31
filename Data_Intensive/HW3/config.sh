#!/bin/bash

NODE1=10.10.1.2;
NODE2=10.10.1.3;
NODE3=10.10.1.4;

ip_address=$(ip addr show | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1 | sed -n 2p)

HADOOP_INSTALL_DIR=/usr/local/hadoop;
SPARK_INSTALL_DIR=/usr/local/spark;

cd ${HADOOP_INSTALL_DIR}/etc/hadoop
# Delete the old core-site.xml file if it exists
if [ -f core-site.xml ]; then
 sudo rm core-site.xml
fi
if [ -f hdfs-site.xml ]; then
 sudo rm hdfs-site.xml
fi
if [ -f mapred-site.xml ]; then
 sudo rm mapred-site.xml
fi
if [ -f yarn-site.xml ]; then
 sudo rm yarn-site.xml
fi

# Create a new core-site.xml file
cat > core-site.xml << EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://$ip_address:9000</value>
    </property>
</configuration>

EOF

# Create a new hdfs-site.xml file
cat > hdfs-site.xml << EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/usr/local/hadoop/hadoop_data/hdfs/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/usr/local/hadoop/hadoop_data/hdfs/datanode</value>
    </property>
    <property>
        <name>dfs.permissions.enabled</name>
        <value>false</value>
    </property>
    <property>
        <name>dfs.datanode.hostname</name>
        <value>10.10.1.2,10.10.1.3,10.10.1.4</value>
    </property>
</configuration>

EOF

# Create a new mapred-site.xml file
cat > mapred-site.xml << EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>

EOF

# Create a new yarn-site.xml file
cat > yarn-site.xml << EOF
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>$ip_address</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
</configuration>

EOF

for node in $NODE1 $NODE2 $NODE3; do
    scp core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml mapred-env.sh hadoop-env.sh yarn-env.sh ${node}:${HADOOP_INSTALL_DIR}/etc/hadoop
done

# Create the Hadoop data directories on all nodes
for node in $NODE1 $NODE2 $NODE3; do
    ssh ${node} "sudo mkdir -p ${HADOOP_INSTALL_DIR}/data/hdfs/namenode && sudo chown -R Stran ${HADOOP_INSTALL_DIR}/data/hdfs/namenode"
    ssh ${node} "sudo mkdir -p ${HADOOP_INSTALL_DIR}/data/hdfs/datanode && sudo chown -R Stran ${HADOOP_INSTALL_DIR}/data/hdfs/datanode"
done

cd ${SPARK_INSTALL_DIR}/conf
# Delete the old files if it exists and create new file.
if [ -f spark-env.sh ]; then
    sudo rm spark-env.sh
fi
cp /usr/local/spark/conf/spark-env.sh.template /usr/local/spark/conf/spark-env.sh
echo "export SPARK_MASTER_HOST=$ip_address" >> /usr/local/spark/conf/spark-env.sh
echo "export SPARK_MASTER_PORT=7077" >> /usr/local/spark/conf/spark-env.sh
echo "export SPARK_WORKER_CORES=4" >> /usr/local/spark/conf/spark-env.sh
echo "export SPARK_WORKER_MEMORY=8g" >> /usr/local/spark/conf/spark-env.sh

for node in $NODE1 $NODE2 $NODE3; do
    scp spark-env.sh ${node}:${SPARK_INSTALL_DIR}/conf
done

# Update the workers file
echo "10.10.1.2" > /usr/local/hadoop/etc/hadoop/slaves
echo "10.10.1.3" >> /usr/local/hadoop/etc/hadoop/slaves
echo "10.10.1.4" >> /usr/local/hadoop/etc/hadoop/slaves

# Start the Hadoop daemons on the master node (node1)
cd ${HADOOP_INSTALL_DIR}/sbin
./stop-dfs.sh
./stop-yarn.sh
./mr-jobhistory-daemon.sh stop historyserver

# Format the namenode
echo "Hadoop multi-node cluster setup complete!"
./start-dfs.sh
./start-yarn.sh
./mr-jobhistory-daemon.sh start historyserver

$SPARK_HOME/sbin/stop-all.sh
$SPARK_HOME/sbin/start-all.sh