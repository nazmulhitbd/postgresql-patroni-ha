#!/bin/bash

set -e

CONFIG="/etc/patroni/patroni.yml"

echo "================================"
echo "       Patroni Cluster Check"
echo "================================"

if [ ! -f "$CONFIG" ]; then
echo "ERROR: $CONFIG does not exist."
exit 1
fi

echo
echo "Patroni service:"
systemctl --no-pager status patroni

echo
echo "Cluster members:"
patronictl -c "$CONFIG" list

echo
echo "Cluster topology:"
patronictl -c "$CONFIG" topology

echo
echo "Patroni verification completed."
