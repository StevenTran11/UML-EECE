#!/bin/bash

# Install required dependencies
sudo apt-get update
sudo apt-get install -y curl tar

# Download Prometheus
PROMETHEUS_VERSION="2.43.0"
curl -LO https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

# Extract Prometheus
tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
cd prometheus-${PROMETHEUS_VERSION}.linux-amd64/

# Start Prometheus
./prometheus --config.file=prometheus.yml