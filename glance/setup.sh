#!/bin/bash
# Temporary cloud image download 
mkdir -p cache/files/ami/
echo "Downloading cloud image for Glance..."
wget -q http://uec-images.ubuntu.com/releases/12.04.2/release-20131024/ubuntu-12.04-server-cloudimg-amd64.tar.gz -P cache/files/ami 
echo "Cloud image downloaded" 
