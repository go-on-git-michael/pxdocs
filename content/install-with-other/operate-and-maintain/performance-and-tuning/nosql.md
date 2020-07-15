---
title: NoSQL Performance
keywords: NoSQL performance, Cassandra, cos, class of service, production, performance, overhead, latency, Portworx Enterprise
description: Find out how Portworx outperforms Cassandra's three way replication when running on a 3-node cluster. See the demonstration for yourself!
weight: 4
---

## Containerized NoSQL Workloads: Cassandra performance gains with running {{< pxEnterprise >}}

In this example, we show how {{< pxEnterprise >}}'s network-optimized 3-way replication out-performs Cassandra's 3-way replication when running on a 3-node cluster. We compared the performance between the following two configuration and ran these tests on the same servers as the tests above.

 - {{< pxEnterprise >}} replication factor set to 1 and Cassandra replication factor set to 3. (Legend: P1C3 in the diagram below)
 - {{< pxEnterprise >}} replication factor set to 3 and Cassandra replication factor set to 1. (Legend: P3C1 in the diagram below)

The results demonstrate that running with {{< pxEnterprise >}} for Cassandra workloads provide significant gains. {{< pxEnterprise >}}'s breakthrough performance for containerized workloads along with the cloud-scale data protection and data services make it a compelling container data services infrastructure for Cassandra and other no-sql workloads

The Read OPS/sec and Write OPS/sec improvements graphs show how running with {{< pxEnterprise >}}'s three-node replication deliver a significantly better OPS/sec than running with Cassandra's three-node replication. This {{< pxEnterprise >}} performance is also made possible because Portworx container software stack intelligently leverages NVMe SSDs to deliver high OPS/sec and low latencies.

### Cassandra with {{< pxEnterprise >}} - Read OPS/sec improvements

![Cassandra Reads Ops](/img/Cassandra-PX Read OPS.png)

### Cassandra with {{< pxEnterprise >}} - Write OPS/sec improvements

![Cassandra Writes Ops](/img/Cassandra-PX Write Ops.png)

The latency graphs below demonstrate the network-optimized replication performance of {{< pxEnterprise >}} as it accelerates cassandra performance by delivering IO at very low latencies to the Cassandra Container

### Cassandra with {{< pxEnterprise >}} - Read Latency improvements

![Cassandra Read Lats](/img/Cassandra-PX Read Latencies.png)

### Cassandra with {{< pxEnterprise >}} - Write Latency improvements

![Cassandra Write Lats](/img/Cassandra-PX Write latencies.png)
