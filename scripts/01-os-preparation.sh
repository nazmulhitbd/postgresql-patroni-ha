#!/bin/bash

set -e

echo "======================================"
echo " PostgreSQL Patroni HA - OS Preparation"
echo "======================================"

if [ "$EUID" -ne 0 ]; then
echo "Please run this script as root."
exit 1
fi

echo "[1/6] Updating Rocky Linux..."
dnf update -y

echo "[2/6] Installing common packages..."
dnf install -y 
wget 
curl 
vim 
tar 
chrony 
firewalld 
python3 
python3-pip 
policycoreutils-python-utils

echo "[3/6] Enabling time synchronization..."
systemctl enable --now chronyd

echo "[4/6] Enabling firewall..."
systemctl enable --now firewalld

echo "[5/6] Opening PostgreSQL/Patroni/etcd ports..."

firewall-cmd --permanent --add-port=5432/tcp
firewall-cmd --permanent --add-port=8008/tcp
firewall-cmd --permanent --add-port=2379/tcp
firewall-cmd --permanent --add-port=2380/tcp
firewall-cmd --permanent --add-port=5000/tcp

firewall-cmd --reload

echo "[6/6] Current firewall configuration:"
firewall-cmd --list-ports

echo
echo "Time synchronization:"
chronyc tracking

echo
echo "OS preparation completed."
echo "Configure hostname and /etc/hosts before continuing."

#chmod +x scripts/01-os-preparation.sh