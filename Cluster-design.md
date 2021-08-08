
### What are the storage best practices for a kubernetes cluster?
- High Performance -> SSD Backed Storage
- Multiple concurrent connections -> Network based storage
- Persistent shared volumes for shared access across multiple PODs
- Label nodes with specific disk types
- Use Node Selectors to assign applications to node with specific disk types

### In a HA setup how can we configure the Conrol plane components?
- API-Server -> Load balancer with Active -- Active mode
- Control Manager & Scheduler -> multiple instances can't run at the same time to avoid duplication 
Active -- Standby mode using `--leader-elect`, `leader-elect-lease-duration`,`leader-elect-renew-deadline`, `leader-elect-retry-period` options


### What are the topolgies for hosting ETCD?
- Stacked Topology -> deploying etcd on the master nodes.
- External ETCD Topology -> sperate servers for ETCD.

### How Writes are handled in ETCD?
The nodes elects a leader between them, if the write request comes to followers they pass it to the leader node, after processing the leader updates the followers and a write consided complete if the leader gets consent.

It implments distributed consensus using Leader Election - RAFT protocol.

A write is consided complete if it can be written on the majority of the nodes in the cluseter aka Quorum = N/2 + 1
the minimum number of nodes that must be avaialble for the cluster to function properly or make a successful write. 

### Why it is recommended to have an odd number of nodes in ETCD?
With a even number there is a possibilty of a cluster failure duo to network segmentation
![quorum](https://user-images.githubusercontent.com/20392755/128596035-608a9d75-bd3d-4bfc-b302-4a76c74a6331.png)
