#!/bin/bash

# Define the Prometheus data directory
PROMETHEUS_DATA_DIR="/usr/local/prometheus/data"

# Download and install Prometheus
VERSION="2.43.0"
wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-arm64.tar.gz
tar -xzvf prometheus-${VERSION}.linux-arm64.tar.gz
sudo mv prometheus-${VERSION}.linux-arm64 /usr/local/prometheus

# Create a Prometheus user and group
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

# Create a Prometheus data directory
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Set up the Prometheus systemd service
cat << EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/prometheus/prometheus \
  --config.file=/usr/local/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd configuration
sudo systemctl daemon-reload

# Start the Prometheus service
sudo systemctl start prometheus

# Enable the Prometheus service to start on boot
sudo systemctl enable prometheus