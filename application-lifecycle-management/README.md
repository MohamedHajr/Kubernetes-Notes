# 🛰 🛰 Application Lifecycle Management 🛰 🛰

### What is the Metrics Server and how does it works?
It retreives metrics from each Node and Pod, aggregates them and store them in memory. since each node has a kubelet, each kubelet contains a sub component called cAdvisor(container advisor) which is responsible for retreiving perfromance metrics from pods and exposing them through the kubelet api to be avaialble to Metrics Server.

### What are the types of deployment stratgies?
- Replace (Scale down to 0 then scale up to n replicas)
- rolling updates (default one)(taking a replica down and bring one up, one by one) 

### How does rolling updates works?
it creates a new replica set under the hood and start scaling it, in case of a rollback it start scaling down the newly created replicaset while scaling down the original replicaset.

### What are the ways to define environment varaibles?
![env](./images/env.png)

### Why do we need ConfigMaps?
when we have a lot of pod definition files it become dificult to manage all the enviroment data stored in them, thus come ConfigMaps to manage all the enviroment variables centrally.

### What are the ways to inject ConfigMaps in Pods?
![configMaps](./images/configMaps.png)

### What happens when you inject secrets as volumes?
each attribute in the secret is created as file with the value of the secret as its content

### What is init containers?
When we want a process or task to compeletion in a container, or somekind of pre-setup for our application container. 
![pod-boot-lifecycle](./images/pod-boot.png)

### What are the common patterns for designing multi-container PODs?
- side car pattern
- adapter pattern
- ambassador pattern

### How does Kubernets support self healing applications?
- Through ReplicaSets and Replication Controllers. The replication controller helps in ensuring that a POD is re-created automatically when the application within the POD crashes and enough replicas of the application are running at all times.
- Kubernetes provides additional support to check the health of applications running within PODs and take necessary actions through Liveness and Readiness Probes

### How to specify an executable and argurments in Dockerfiles and pod definition files?
- Executables
  - use `ENTRYPOINT` instruction in Dockerfiles
  - a `command` field in pod defintion files
- Arguments or Parameters
  - use `CMD` instruction in Dockerfiles
  - `args` field in pod definition files

### Why we use a combination of `ENTRYPOINT` and `CMD` in Dockerfiles?
in order to set a default value to avoid the image erroring out if parameter weren't specificed

### How can we create a secret imperativly?
`kubectl create secret generic secret-config-name --from-literal=DB_PASS=wohoo`

### What are the requirments when creating secrets in a declartive way?
You must specify secerts in a hashed format, for example using,
- `echo -n "secret-to-encode" | base64`
- `echo -n "secret-to-decode" | base64 --decode `

### What are some crucial practices that should be applied when using secrets?
- Not checking-in secret object definition files to source code repositories.
- Enabling Encryption at Rest for Secrets so they are stored encrypted in ETCD. 

### What are better alternative for kubernetes secrets?
Helm Secrets and HashiCorp Vault.

### How to rollback a deployment?
`kubectl rollout undo deployment/${name-of-deployment}`
