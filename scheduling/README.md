#  ⏱ ⏱ Scheduling ⏱ ⏱

### How does Scheduling works?
The scheduler search for pods that doesn't have `nodeName` field and once it finds one, it runs the scheduling algorithm and then assign that POD to the appropriate Node, by creating a `Binding object` and setting the nodeName.


### How can we assign a POD to a node if there is no scheduler?
We can assign them to the appropriate node in creation time by setting the `nodeName` || we can create a binding object and send a post request to the POD binding API.

### What is a taint effect and what types of effects are there?
A taint effect defines what happends to PODs that Don't Tolerate this taint 
- NoSchedule (The PODs will not be scheduled on the node)
- PreferNoSchedule (the system will try to avoid placing the POD on the node but its not gaurenteed)
- NoExecute (new PODS will be not be scheduled on the nodes and existing PODs will be evicted if they don't tolerate the taint)

### How does the scheduler doesn't place any PODs on the master node?
When the cluster get created it set a taint on the master node to prevent any PODS from being placed on it.

### How can you create and remove  a taint on a node using kubectl?
`kubectl taint nodes node-name key=value:taint-effect` to remove just add `-` to the end of the previous command.

### How to look up all the options available for a specifc component e.g. `POD`?
`kubectl explain pod --recursive | less `

### How can we limit a POD to only run on a specific Node?
- By using nodeSelector on our POD and label our Nodes.
- Node Affinity for more complex expressions.

### What are the Node Affinity types?
- Avaialbe
    - requiredDuringSchedulingIgnoredDuringExecutioni -> if the given affinity rules can't be found, the POD will not be scheduled
    - preferredDuringSchedulingIgnoredDuringExecution -> if the given affinity rules can't be found, the scheduler will ignore the rules and place on avaialbe nodes
    For Both available rules during execution, any changes that affect node affinity will be ignored 
- Planned
    - requiredDuringSchedulingRequiredDuringExecution -> POD will be evicted if the matching affinity rules changes.

### How to completely dedicate Nodes for only specific PODs?
By using a combination of taint, tolerations and node affinity

### What are the minimum required resources for a container or a POD?
0.5 cpu, 265 Mi memory.
 
### What are the resources defualt limits that kuberentes sets by default for containers?
1 cpu and 512 Mi memory

### What happens if a POD trying to consume more than its memory limit constantly?
It will be terminated.

### What is a deamon set?
Exactly like a ReplicaSet, however it ensure that one copy of the pod is always present on every node in the cluster.
e.g. kube-proxy, logging or monitoring pods.

### How can you create a static PODs?
By placing the definition files under the `pod-manifest-path` or if using the a kubeconfig file then it is specified under `staticPodPath`, it can be used to deploy the controlplane components as PODs like in the case of Kubeadm

### What is Annotations used for in Kubernetes?
An object in definition files to record details for informatory purposes 

### What are taints and tolerations in Kubernetes?
Taints place a restriction on nodes so no pods can be scheduled on it unless it has a toleration for that particular taint.

### How to add a tolerance to a specific pod?
By adding a `tolerations` list under the `spec` map where each item has the following format
`
- key:
  value:
  effect: NoSchedule | PreferNoSchedule | NoExecute  
  operator: Equal
`

### What are the specifications of an existing pod that you can edit imperativly?
With Deployments you can easily edit any field/property of the POD template
- spec.containers[*].image
- spec.initContainers[*].image
- spec.activeDeadlineSeconds
- spec.tolerations


### What is the difference between `limitsRequest` and `limits`?
limitsRequests is the requirment for the pod to run 
Limits is the maximum CPU or RAM it can grow to

### What is OOM Killed?
A pod status that happens When gets killed as a result of a memory 'limit' (maximum) defined and its usage crosses the specified limit.Note that, this happens despite the node having enough free memory.


### How does DaemonSet works?
It uses the default Scheduler and NodeAffinity rules to schedule a pod on each node.

### How to find the location of static pods?
By checking the running service config file  or manfiest location by running  `ps -ef | grep kubelet`

### What are the requirments to get multiple Schedulers running?
- Whether set the `leader-elect` to `false` in case if you don't have multiple masters
- In case you have multiple masters, pass a new paramter `lock-object-name` to differentiate the new custom scheduler from the default

### How do you know which scheduler picked and perform the action?
`kubectl get events`
