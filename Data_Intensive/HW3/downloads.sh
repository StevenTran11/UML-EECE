#!/bin/bash

# Update Ubuntu
sudo apt update -y;
sudo apt upgrade -y;
sudo apt-get install -y ssh;

# Download and install Python2
sudo apt-get install python -y
sudo apt-get install python2 -y
echo 'export PATH=$PATH:/usr/bin/python2' >> ~/.bashrc
source ~/.bashrc

# Download and install Maven
sudo apt install maven -y

# Download and install Scala
sudo apt-get install scala -y
echo 'export SCALA_HOME=/usr/share/scala/' >> ~/.bashrc
source ~/.bashrc

# Download and install Java
sudo apt-get install openjdk-8-jdk -y
sudo update-alternatives --config java <<< '2'

# Export Java to PATH
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc

# Export Javac to PATH
echo 'export PATH=$PATH:/usr/lib/jvm/java-8-openjdk-amd64\jre/bin' >> ~/.bashrc
source ~/.bashrc