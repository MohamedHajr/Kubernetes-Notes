#Security

### What are the Authentication mechanisms for admins and developers accessing the kube-apiserver?
- Username and Password in a Static Password File
- Username and Token in a Static Token File
- Certificates
- 3rd party authentication protocols `Identity Services` such as LDAP

### How can we configure username and password or token authentication?
by creating a `.csv` file that has the format `password/token,username,userid,optionalGroupName` and configure the kube-apiserver with it using `--base-auth-file`
![username&password](./images/password.png)


### What are the naming conventions for private and public keys?
![keys](./images/keys.png)

### What are the type of certificates that the cluster needs?
![certs](./images/certs.png)
![certs-flow](./images/certs-flow.png)

### How to generate  the certificate for the Kubernetes Certificate Authority?
- Generate a private key -> `openssl genrsa -out ca.key 2048`
- Generate a Certificate Signing Request -> `openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr`
- Sign the Certificate -> `openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt` 

### How to generate the certificates for the admin user?
- Generate a private key `openssl genrsa --out admin.key  2048`
- Generate a  CSR and adding it to the admin group`SYSTEM:MASTERS`  -> `openssl req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr`
- Sign the Certificate -> `openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -out admin.crt`

### What should we take in consideration when we are creating certificates for system components?
the name inside the certificate must be prefixed with `system` e.g. `SYSTEM.KUBE-SCHEDULER`

### Where should we specifiy the other kube-apiserver alternate names?
by creating an OpenSSL config file and passing it as an option when creating the certificate signing request
![apiserver-crt](./images/apiserver-crt.png)

### What certificates should be considered that that the apiserver will need when communicating as a client?
we pass these certificates to the kube-apiserver service configuration file
- etcd certificates 
- kubelet certificates
![apiserver-clients](./images/apiserver-clients.png)


### What is the naming convention for each kublet nodes as clients and as servers?
As server -> named after there node name.
As clients -> system:node:node-name and added to a group called `SYSTEM:NODES`
