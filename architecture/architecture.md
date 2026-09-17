# PostgreSQL Patroni HA Architecture

## Logical Architecture

```text
                     +-----------------------+
                     |   Client Applications  |
                     +-----------+-----------+
                                 |
                                 |
                         VIP 192.168.56.110
                                 |
                         +-------+-------+
                         |   Keepalived  |
                         +-------+-------+
                                 |
                         +-------+-------+
                         |    HAProxy    |
                         |     :5000     |
                         +-------+-------+
                                 |
               +-----------------+-----------------+
               |                 |                 |
               v                 v                 v
        +-------------+   +-------------+   +-------------+
        |  pg-node1   |   |  pg-node2   |   |  pg-node3   |
        | .102        |   | .103        |   | .104        |
        +-------------+   +-------------+   +-------------+
        | PostgreSQL  |   | PostgreSQL  |   | PostgreSQL  |
        | Patroni     |   | Patroni     |   | Patroni     |
        | etcd        |   | etcd        |   | etcd        |
        +-------------+   +-------------+   +-------------+
               \                |                /
                \               |               /
                 +--------------+---------------+
                                |
                         +------+------+
                         | etcd Cluster |
                         |   3 Nodes    |
                         +-------------+
```

## Component Responsibilities

### PostgreSQL

Provides the database engine and streaming replication.

### Patroni

Provides:

* Leader management
* Automatic failover
* PostgreSQL lifecycle management
* Replica management
* Cluster state coordination

### etcd

Provides the distributed configuration store used by Patroni.

### HAProxy

Provides database connection routing.

HAProxy checks the Patroni REST API and routes write traffic to the current leader.

### Keepalived

Provides the floating Virtual IP.

VIP:

```text
192.168.56.110
```

Application endpoint:

```text
192.168.56.110:5000
```

## Failure Scenario

Normal:

```text
VIP
 |
HAProxy
 |
 +--> pg-node1 PRIMARY
 +--> pg-node2 REPLICA
 +--> pg-node3 REPLICA
```

After pg-node1 failure:

```text
VIP
 |
HAProxy
 |
 +--> pg-node1 FAILED
 +--> pg-node2 PRIMARY
 +--> pg-node3 REPLICA
```

Applications continue using:

```text
192.168.56.110:5000
```

The application does not need to know which PostgreSQL server currently holds the primary role.
