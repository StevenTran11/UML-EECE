#!/bin/bash

PROM_VERSION="2.30.0"

# Download and extract Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar xzf prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Copy Prometheus binaries to /usr/local/bin
sudo cp prometheus-${PROM_VERSION}.linux-amd64/{prometheus,promtool} /usr/local/bin/

# Copy Prometheus configuration file to /etc/prometheus
sudo mkdir /etc/prometheus
sudo cp prometheus-${PROM_VERSION}.linux-amd64/{prometheus.yml,console_libraries/*.js,consoles/*.html} /etc/prometheus

# Create Prometheus user and directories
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /var/lib/prometheus

# Set ownership and permissions
sudo chown prometheus:prometheus /var/lib/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chmod -R 775 /etc/prometheus

# Configure systemd service
sudo tee /etc/systemd/system/prometheus.service << EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
