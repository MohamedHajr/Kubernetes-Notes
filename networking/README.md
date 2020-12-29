# Networking

### What command is used to list and modify networking interfaces on the host?
`ip link`

### What command is used to see and set the ip addresses to network interfaces?
`ip addr` & `ip addr add 192.168.1.10/24 dev eth0` -> on valid until a restart to set them permenantly must modify `/etc/networkinterfaces`

### What command is used to view and add route in routing tables?
`ip route` or `route`  & `ip route add 192.168.1.0/24 via 192.168.2.1` 

### How to check if Ip forwarding is enabled on a host?
checking the value of `/proc/sys/net/ipv4/ip_forward`

### How to add a name for a specific ip and what is it called?
Name Resloution
by adding an entry in the `/etc/hots` file -> `192.168.1.11     db`

### How to add a DNS server on your host?
by adding an entry to the `/etc/resolv.conf` 
`nameserver     192.168.1.100`

### What tool can we use to query a hostname from a dns server?
`nslookup google.com` `dig google.com`

### what is the analogy between a host and a namespace?
A host is like a house and namespace is like an isolated room inside that house

### What command can we use to list and create namespaces?
`ip netns` &  `ip netns add vr-space`

### How can we execute a command inside a namespace?
Running command `ip link` inside the name space -> `ip netns exec vr-space ip link`

### How to connect two namespaces?
`ip link add veth-red type veth peer name veth-blue` to create two ends for a virtual cable
to attach each end of the cable to the namespaces 
`ip link set veth-red netns red`
`ip link set veth-blue netns blue`
then assign Ips to each end of the cable
`ip -n red addr add 192.168.15.1 dev veth-red`
`ip -n blue addr add 192.168.15.2 dev veth-blue`
then we bring up the interfaces
`ip -n red link set veth-red up`
`ip -n blue link set veth-blue up`
~[linking-namespaces](./images/linking-ns.png)

### How to connect multiple namespaces together?
By creating a virtual switch and a virtual cable for each namespace with one end of the cable for the namespace and the other for the switch(Linux Bridge)
- We create a cable `ip link add veth-red type veth peer name veth-red-br`
- We connect both ends of the cable one to the namespace and another to the switch for each namespace
`ip link set veth-red netns red`
`ip link set veth-red-br master v-net-0`
`ip link set veth-blue netns blue`
`ip link set veth-blue-br master v-net-0`
- Set ip addresses for each cable end and bring them up
`ip -n red addr add 192.168.15.1 dev veth-red`
`ip -n blue addr add 192.168.15.2 dev veth-blue`
`ip -n red link set veth-red up`
`ip -n blue link set veth-blue up`
![virtual-switch](v-net.png)

### How to connect the namespaces network to the host machine?
By assiging an IP address to the namespaces network switch as for the host machine its just another network interface 
`ip addr add 192.168.15.5/24 dev v-net-0`

### What docker does once installed on a host?
It creates a internal private netowrk called `bridge` in docker and `docker0` on the host

### What is the networking steps to create a bridge network?
- Create a network Namespace
- Create Bridge Network/interface
- Create vEth Pairs(Pipe, Virtual Cable) 
- Attach vEth to namespace
- Attach other vEth to the Bridge
- Assign IP Addresses
- Bring the interfaces up
- Enable NAT - IP Masquerade

### What is a Container network interface?
A set of standards that define how programs should be developed to solve networking challenges in a container runtime environment.

### What are the CNI rules that every container runtime must have?
- Container runtime must create network namespace
- Identify network the container must attach to
- Container runtime must invoke Network Plugin(Bridge) when container is ADDed
- Container runtime must invoke Network Plugin(Bridge) when container is Deleted
- Json Format of the network configuration

### What are the CNI rules that every plugin must have?
- Must support command line arguments ADD/DEL/CHECK
- Must support parameters container id, network ns etc..
- Must manage IP Address assignment to PODs
- Must return results in a specific format

### How does Kubernetes handles Docker Incompatiabilty with CNI?
It creates container with no networking at all, then invoke the CNI plugin with the right parameters

### What are the ports that should be open for each component in the cluster?
![cluster-networking](./images/cluster-networking.png)

### What is the Kubernetes networking model for Pods?
- Every POD should have an IP address.
- Every POD should be able to communicate with every other POD in the same node.
- Every POD should be able to communicate with every other POD on other nodes without NAT.

### 
