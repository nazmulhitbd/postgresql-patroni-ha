#!/bin/bash

set -e

export ETCDCTL_API=3

ENDPOINTS="[http://192.168.56.102:2379,http://192.168.56.103:2379,http://192.168.56.104:2379](http://192.168.56.102:2379,http://192.168.56.103:2379,http://192.168.56.104:2379)"

echo "================================"
echo "        etcd Cluster Check"
echo "================================"

echo
echo "Endpoint health:"
etcdctl --endpoints="$ENDPOINTS" endpoint health

echo
echo "Endpoint status:"
etcdctl --endpoints="$ENDPOINTS" endpoint status

echo
echo "Member list:"
etcdctl --endpoints="$ENDPOINTS" member list

echo
echo "etcd verification completed."
