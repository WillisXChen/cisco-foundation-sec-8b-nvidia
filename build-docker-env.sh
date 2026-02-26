#!/bin/bash
# Maintainer: Willis Chen <misweyu2007@gmail.com>
# Step 1: Save a list of your current images (for reference)
sudo docker images
# Step 2: Remove snap Docker
sudo snap remove --purge docker
sleep 3
# Step 3: Install official Docker Engine via apt
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Step 4: Configure NVIDIA runtime (now systemd manages Docker properly)
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
# Step 5: Validate
sudo docker info | grep -A3 "Runtimes"
sudo docker run --rm --gpus all nvidia/cuda:12.6.3-base-ubuntu24.04 nvidia-smi