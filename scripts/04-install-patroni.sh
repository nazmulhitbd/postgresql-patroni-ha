#!/bin/bash

set -e

echo "Installing Patroni..."

if [ "$EUID" -ne 0 ]; then
echo "Run as root."
exit 1
fi

python3 -m pip install --upgrade pip

python3 -m pip install 
"patroni[etcd3]" 
psycopg2-binary

mkdir -p /etc/patroni

chown postgres:postgres /etc/patroni

echo
echo "Patroni version:"
patroni --version

echo
echo "patronictl:"
patronictl --help | head -20

echo
echo "Patroni installation completed."
