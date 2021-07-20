#!/bin/bash

### Uninstall old docker versions
apt-get remove -y docker docker-engine docker.io containerd runc

### update apt package index
apt-get update -y

### install packages to allow apt to use a repository over HTTPS
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

### set up the stable repository
 echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

### Install Docker Engine

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io
### Configure the Docker daemon, in particular to use systemd for the management of the container’s cgroups.
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
### Restart Docker and enable on boot
systemctl enable docker
systemctl daemon-reload
systemctl restart docker

## Installing kubeadm, kubelet and kubectl 

### Download the Google Cloud public signing key:
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
### Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
### Install kubelet, kubeadm and kubectl, and pin their version
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

## creating configuration file for Kubelet cgroup driver
cat <<EOF >kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta2
kubernetesVersion: v1.21.0
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF 

kubeadm init --config kubeadm-config.yaml

