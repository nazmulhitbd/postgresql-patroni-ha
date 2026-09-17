# PostgreSQL 16 Patroni High Availability Cluster

Step-by-Step PostgreSQL High Availability Training Lab using:

* Rocky Linux 9.8
* PostgreSQL 16
* Patroni
* etcd 3-node cluster
* HAProxy
* Keepalived
* Streaming Replication

## Lab Architecture

```text
                         CLIENT APPLICATIONS
                                |
                                |
                         VIP: 192.168.56.110
                                |
                         HAProxy : 5000
                                |
                    +-----------+-----------+
                    |                       |
                Keepalived              Keepalived
                    |                       |
        +-----------+-----------+-----------+
        |                       |           |
        v                       v           v
   pg-node1                pg-node2     pg-node3
 192.168.56.102          192.168.56.103 192.168.56.104
        |                       |           |
        | PostgreSQL 16         | PostgreSQL 16
        | Patroni               | Patroni
        | etcd                  | etcd
        |                       |           |
        +-----------+-----------+-----------+
                    |
              etcd DCS Cluster
```

## Node Information

| Node   | Hostname       | IP Address     |
| ------ | -------------- | -------------- |
| Node 1 | pg-node1       | 192.168.56.102 |
| Node 2 | pg-node2       | 192.168.56.103 |
| Node 3 | pg-node3       | 192.168.56.104 |
| HA VIP | PostgreSQL VIP | 192.168.56.110 |

## Services

Each database node runs:

* PostgreSQL 16
* Patroni
* etcd
* HAProxy
* Keepalived

## Ports

| Port | Service    | Purpose                       |
| ---: | ---------- | ----------------------------- |
| 2379 | etcd       | Client communication          |
| 2380 | etcd       | Peer communication            |
| 5432 | PostgreSQL | Database                      |
| 5000 | HAProxy    | Application database endpoint |
| 8008 | Patroni    | REST API                      |

## PostgreSQL HA Flow

```text
Application
    |
    v
192.168.56.110:5000
    |
    v
HAProxy
    |
    +----> Current Patroni Leader :5432
    |
    +----> Replica - not selected for writes
    |
    +----> Replica - not selected for writes
```

Patroni uses etcd as the Distributed Configuration Store (DCS).

```text
             +----------------+
             |      etcd      |
             |   3-node DCS   |
             +----------------+
                /     |     \
               /      |      \
              v       v       v
          Patroni  Patroni  Patroni
             |       |       |
             v       v       v
            PG      PG      PG
```

## Failover

If the current PostgreSQL leader fails:

1. Patroni detects the failure.
2. Patroni uses etcd to coordinate leader election.
3. A healthy replica is promoted.
4. HAProxy detects the new leader through Patroni's REST API.
5. Keepalived keeps the client VIP available.
6. Applications reconnect to the same endpoint.

```text
Before failure:

VIP
 |
HAProxy
 |
 +----> pg-node1 PRIMARY
 +----> pg-node2 REPLICA
 +----> pg-node3 REPLICA


After pg-node1 failure:

VIP
 |
HAProxy
 |
 +----> pg-node1 DOWN
 +----> pg-node2 PRIMARY
 +----> pg-node3 REPLICA
```

## Repository Contents

### Documentation

`docs/PATRONI-HA-TRAINING-GUIDE.md`

Complete step-by-step installation and configuration guide.

### Configuration

`configs/`

Contains example etcd, Patroni, HAProxy, Keepalived and systemd configuration files.

### Scripts

`scripts/`

Contains installation, verification and testing scripts.

## Important Security Note

The configuration files in this repository are intended for a training lab.

Do not commit real:

* PostgreSQL passwords
* Replication passwords
* API credentials
* TLS private keys
* SSH private keys
* Production configuration secrets

Use environment variables, secret-management systems or protected configuration files for production.

## Training Sequence

Follow the lab in this order:

1. Prepare Rocky Linux
2. Configure hostname and `/etc/hosts`
3. Configure firewall
4. Configure time synchronization
5. Install etcd
6. Configure the 3-node etcd cluster
7. Verify etcd
8. Install PostgreSQL 16
9. Do not manually initialize PostgreSQL
10. Install Patroni
11. Configure Patroni
12. Create the Patroni systemd service
13. Bootstrap Node 1
14. Join Node 2
15. Join Node 3
16. Verify replication
17. Configure HAProxy
18. Configure Keepalived
19. Test application connectivity
20. Test automatic failover
21. Restore the failed node
22. Verify cluster recovery

## Basic Verification

### Check Patroni

```bash
sudo patronictl -c /etc/patroni/patroni.yml list
```

### Check etcd

```bash
sudo ETCDCTL_API=3 etcdctl \
  --endpoints=http://192.168.56.102:2379,http://192.168.56.103:2379,http://192.168.56.104:2379 \
  endpoint health
```

### Check PostgreSQL

```bash
psql -h 192.168.56.102 -U postgres -d postgres
```

### Check replication

```sql
SELECT application_name,
       client_addr,
       state,
       sync_state
FROM pg_stat_replication;
```

## License

This project is intended for educational and training purposes.
