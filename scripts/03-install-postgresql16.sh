#!/bin/bash

set -e

echo "Installing PostgreSQL 16..."

if [ "$EUID" -ne 0 ]; then
echo "Run as root."
exit 1
fi

dnf install -y 
https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm

dnf -qy module disable postgresql

dnf install -y 
postgresql16-server 
postgresql16-contrib

echo
echo "PostgreSQL binaries:"
/usr/pgsql-16/bin/postgres --version

echo
echo "IMPORTANT:"
echo "Do NOT run postgresql-16-setup initdb."
echo "Patroni will initialize the database."
echo

ls -ld /var/lib/pgsql/16/data || true

echo
echo "PostgreSQL 16 installation completed."
