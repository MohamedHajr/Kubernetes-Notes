#  ⏱ ⏱ Scheduling ⏱ ⏱

### How does Scheduling works?
The scheduler search for pods that doesn't have `nodeName` field and once it finds one, it runs the scheduling algorithm and then assign that POD to the appropriate Node, by creating a `Binding object` and setting the nodeName.


### How can we assign a POD to a node if there is no scheduler?
We can assign them to the appropriate node in creation time by setting the `nodeName` || we can create a binding object and send a post request to the POD binding API.o

### What is a taint effect and what types of effects are there?
A taint effect defines what happends to PODs that Don't Tolerate this taint 
- NoSchedule (The PODs will not be scheduled on the node)
- PreferNoSchedule (the system will try to avoid placing the POD on the node but its not gaurenteed)
- NoExecute (new PODS will be not be scheduled on the nodes and existing PODs will be evicted if they don't tolerate the taint)

### How does the scheduler doesn't place any PODs on the master node?
When the cluster get created it set a taint on the master node to prevent any PODS from being set on it.o

### How can you createi and remove  a taint on a node using kubectl?
`kubectl taint nodes node-name key=value:taint-effect` to remove just add `-` to the end of the previous command.

### How to look up all the options available for a specifc component e.g. `POD`?
`kubectl explain pod --recursive | less `

### How can we limit a POD to only run on a specific Node?
- By using nodeSelector on our POD and label our Nodes.
- Node Affinity for more complex matchingo

### What are the Node Affinity types?
- Avaialbe
    - requiredDuringSchedulingIgnoredDuringExecutioni -> if the given affinity rules can't be found, the POD will not be scheduled
    - preferredDuringSchedulingIgnoredDuringExecution -> if the given affinity rules can't be found, the scheduler will ignore the rules and place on avaialbe nodes
    For Both available rules during execution, any changes that affect node affinity will be ignored 
- Planned
    - requiredDuringSchedulingRequiredDuringExecution -> POD will be evicted if the matching affinity rules changes.

### How to completely dedicate Nodes for only specific PODs?
By using a combination of taint&tolerations and node affinity

### What are the minimum required resources for a container or a POD?
0.5 cpu, 265 Mi memory.
 
### What are the resources defualt limits that kuberentes sets by default for containers?
1 cpu and 512 Mi memory

### What happens if a POD trying to consume more than its memory limit constantly?
It will be terminated.

### What is a deamon set?
Just like ReplicaSet DemonSets helps replicating you pod on multiple nodes, however it ensure that oen copy of the pod that is always present in all nodes in the cluste.
e.g. kube-proxy, logging or monitoring pods.

### How can you create a static PODs?
By placing the definition files under the `pod-manifest-path` or if using the a kubeconfig file then it is specified under `staticPodPath`, it can be used to deploy the controlplane components as PODs like in the case of Kubeadm  
