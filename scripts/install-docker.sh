#!/bin/bash
# ============================================
# Docker & Docker Compose Installation Script
# For: Ubuntu (20.04+)
# Author: IonLedger
# ============================================

set -e

echo "🚀 Starting Docker installation..."

# Step 1: Update package list
sudo apt update -y

# Step 2: Install required packages
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Step 3: Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Step 4: Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 5: Install Docker Engine, CLI, and Containerd
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Step 6: Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Step 7: Verify Docker installation
docker --version

# Step 8: Install Docker Compose plugin
sudo apt install -y docker-compose-plugin

# Step 9: Verify Docker Compose installation
docker compose version

echo "🎉 Docker & Docker Compose installation completed successfully!"
echo "💡 Run 'sudo usermod -aG docker $USER' and re-login to use Docker without sudo."
