#!/bin/bash

cd /usr/local/hadoop/sbin
./stop-dfs.sh
./stop-yarn.sh
./mr-jobhistory-daemon.sh stop historyserver
$SPARK_HOME/sbin/stop-all.sh