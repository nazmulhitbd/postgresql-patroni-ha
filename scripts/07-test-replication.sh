#!/bin/bash

set -e

echo "Testing PostgreSQL replication..."

echo
echo "Current Patroni cluster:"
patronictl -c /etc/patroni/patroni.yml list

echo
echo "Replication status must be checked from the current leader."

echo
echo "Run:"
echo
echo "psql -h <LEADER-IP> -U postgres -d postgres"
echo
echo "Then:"
echo
echo "SELECT application_name,"
echo "       client_addr,"
echo "       state,"
echo "       sync_state"
echo "FROM pg_stat_replication;"

echo
echo "Replication test instructions displayed."
