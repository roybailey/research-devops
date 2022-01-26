# K8

* [kubernetes.io](https://kubernetes.io)
* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [Kubernetes Documentation Concepts](https://kubernetes.io/docs/concepts/)
* [Kubernetes Documentation Setup](https://kubernetes.io/docs/setup/pick-right-solution/)
* [Kubernetes Documentation - Minikube Setup](https://kubernetes.io/docs/getting-started-guides/minikube/)
* [Oracle VirtualBox](https://www.virtualbox.org/)
* [OSBoxes VM images](http://osboxes.org/)
* [kubeadm installation instructions](https://kubernetes.io/docs/setup/independent/install-kubeadm/)
* [play-with-k8s.com](play-with-k8s.com)
* [yamllint.com](yamllint.com)

## Overview

* **NODES** = MACHINE, kubelet agent, network proxy, container runtime
* **CLUSTER** = GROUP OF NODES
* **MASTER** = NODE CONTROLLING CLUSTER, api server, cluster store, controller & scheduler, etcd (key/value store)
* **PODS** = RUN 1..N CONTAINERS, has own IP, tightly coupled services usually run together, often only one
* **REPLICASETS** = HOW TO REPLICATE A POD
* **SERVICES** = IP addressed load balancer, pods accessed via labelling
* **DEPLOYMENTS** = DEPLOYMENT OF REPLICASETS, versioning, rollback plan, deactivation

> Master **api-server** talks to worker/minion nodes with **kubelet** agent

### PODS

* [Pod Overview](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)
* Run a container, or sometimes multiple tightly coupled containers e.g. main container and helper containers
* Each pod gets its own IP address internal to the Node (server) its running on

#### sample pod definition file

```
apiVersion: v1  
kind: Pod  
metadata:  
  name: myapp-pod  
  labels:  
    app: myapp  
spec:  
  containers:  
    - name: nginx-container  
      image: nginx
      env:
        - name: MYPASSWORD
          value: mysecretpassword
```

### CONTROLLERS & REPLICASETS

* Creates a template for a Pod and defines the replicas (number of instances)
* K8 will maintain desire number of instances

#### sample replicaset definition file

```
apiVersion: apps/v1  
kind: ReplicaSet
metadata:  
  name: myapp-replicaset  
  labels:  
    app: myapp-rs
spec:  
  replicas: 3
  template:
    metadata:  
      name: myapp-pod
      labels:  
        app: myapp
    containers:  
      - name: nginx-container  
        image: nginx
        env:
          - name: MYPASSWORD
            value: mysecretpassword
  selector:
    matchLabels:
      app: myapp
```

### DEPLOYMENT

* Versioned (revisions) and rollback capability

#### sample deployment definition file

```
apiVersion: apps/v1  
kind: Deployment
metadata:  
  name: myapp-replicaset  
  labels:  
    app: myapp-rs
spec:  
  replicas: 3
  template:
    metadata:  
      name: myapp-pod
      labels:  
        app: myapp
    containers:  
      - name: nginx-container  
        image: nginx
        env:
          - name: MYPASSWORD
            value: mysecretpassword
  selector:
    matchLabels:
      app: myapp
```

### Networking

* All containers/Pods can communicate to one another without NAT
* All nodes can communicate with all containers/Pods and vice versa without NAT

### Services

* Communication within and outside the application
* Connects services with other applications or users

Services receives requests on the front-end and forwards it to the backend pods. e.g. a redis service receives requests on the front-end on port 6379 and forwards it to the actual redis systems running in the backend in the form of PODs.

The service is exposed through the cluster with the name of the service - "redis" in this case. An application code running in connects to the redis service using this hostname. **All services within a Kubernetes cluster can be accessed by any PODs or other services using the service names.** The `kube-dns` component in the kubernetes architecture makes this possible. 

#### Types

* NodePort - service listens to port on Pod and forwards to port on Node
* ClusterIP (default) - virtual IP inside the cluster to enable communcation between services (e.g. front-end to backend services)
* LoadBalancer - load balance requests across your services (provisioned from cloud provider), needed for external access

#### Ports

* TargetPort = Pod port
* Port = port on service itself listening to TargetPort
* NodePort = port on Node (server) itself, in range 30000-32767

#### sample service definition file

```
apiVersion: v1  
kind: Service  
metadata:  
  name: myapp-service  
spec:  
  type: NodePort  
  ports:  
    - targetPort: 80  
      port: 80  
      nodePort: 30008  
  selector:  
    app: myapp
```

#### ClusterIP

Assigns virtual IP within the cluster.

## Commands

| Kubernetes Command | Description |
|--|--|
| `kubectl config use-context docker-desktop` | Switch to docker-desktop K8 context |
| `kubectl get node` | Get all nodes |
| `kubectl get svc --namespace default -w my-apache` | Watch the status of a service |
| `kubectl run <name> --image=<namespace>/<image-name> --image-pull-policy=Never --port=<port-number>` | Runs a container image in a pod configured with port mapping |
| `kubectl get pods -o wide` | Gets running pods with extra details |
| `kubectl describe pods` | Gets running pods with verbose details |
| `kubectl logs <POD_NAME>` | View logs of pod
| `kubectl get all` | Shows all deployments, replicasets and pods running |
| `kubectl expose deployment <pod-name> --type=NodePort` | Exposes node port for named pod |
| `minikube service <pod-name> --url` | Exposes pod url when running in minukube |
| `kubectl delete deployment <pod-name>` | Deletes running pod |
| `kubectl port-forward <pos-instance> 8080:5000` | Port forward to localhost |
| `kubectl create -f <k8 defintion file.yml> --record` | Create and run the k8 definition file, recording a revision |
| `kubectl replace -f <k8 defintion file.yml>` | Replace the running k8 definition file |
| `kubectl apply -f <k8 defintion file.yml>` | Apply the k8 definition file (updates) |
| `kubectl rollout status <k8 defintion file.yml>` | Show deployment rollout status |
| `kubectl rollout history <k8 defintion file.yml>` | Show deployment rollout history |
| `kubectl rollout undo <k8 defintion file.yml>` | Rollback deployment to previous revision |
| `kubectl create -f .` | Create all from folder |
| `kubeadm init ...` | Initialise master node for a cluster |
| `kubectl get pods --all-namespaces` | Gets all pods including system pods for checking cluster state  |
| `clear; kubectl get all --all-namespaces -o wide` | Gets everything in cluster, inc. system  |
| `kubectl get secrets` | Gets all secrets |

| Helm Command | Description |
|--|--|
| `https://artifacthub.io/` | Public helm chart hub |
| `helm repo add bitnami https://charts.bitnami.com/bitnami` | Adding a Helm repository for helm to search |
| `helm install my-apache bitnami/apache --version 8.0.2` | Install container |
| `helm upgrade my-apache bitnami/apache --version 8.0.3` | Upgrade a container |
| `helm list` | Lists deployed helm charts |
| `helm rollback my-apache 1` | Rollback to earlier revision |
| `helm delete my-apache` | Remove a deployment |
| `helm install my-release bitnami/wordpress` | Install Wordpress |
| `export SERVICE_IP=$(kubectl get svc --namespace default my-release-wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")` | Get service IP address |
| `$(kubectl get secret --namespace default my-wordpress-3 -o jsonpath="{.data.wordpress-password}" | base64 --decode)` | Output wordpress password |
| `helm create <name>` | creates `<name>` subfolder with helm chart basics |
| `helm get manifest <name>` | Gets the helmchart resources that are installed for this chart name |
| `helm install --debug --dry-run <name> <chart-folder>` | Shows rendered template but does not install |
| `helm ... --set livenessProbe.httpGet=null` | remove a default values.yaml property and all its nested properties |
| `helm install my-wordpress-prod bitnami/wordpress --version 10.1.4 -f values-production.yaml` | install multi-instance wordpress |

| Helm Template | Description |
|--|--|
| `{{.Release.name}}}}` | Simple property value from standard object |
| `{{.Values.name}}}}` | Simple property value from `values.yaml` |
| `{{lower .Values.custom.prefix}}` | function call passing value |
| `{{.Values.custom.suffix | upper}}` | function call piped value |
| `{{ .Values.drink | default "tea" | quote | upper }}` | assigning default value |

`
## Application Tips

* `jib-maven-plugin` builds docker images, maintains same image if code not changed
* Memory needs to be set with `-XX:Percentage` of container setting
** 80% max to allow for ssh onto box
* `kubectl create secret` will create namespace key/value encrypted in container, mappable to env variables for applications
* Log to console in app, so k8 container can be tailed and controls file capture itself
* `Ingress` type to create canary rollout, sits above `Service` load balancer and forwards % (or other criteria) to different service/pods for cautious rollout

## Udemy Course Notes

### Preparing VM for k8 Cluster

* `sudo su` to change to root login
* `apt-get update` to update all packages
* `apt-get install openssh-server` to install ssh capability
* `service ssh status` to check ssh service is running
* `nano /etc/hostname` to edit the hostname for each machine to make sure it's unique
* `nano /etc/hosts` to edit the hostname for each machine to make sure it matches new hostname
* Add second network adaptor to VM private network (without DHCP)
* `nano /etc/network/interfaces` to add the VM private network and assign static IP address

```
# Configure enp0s8 interfaces
auto enp0s8
iface enp0s8 inet static
      address 192.168.99.110
      netmask 255.255.255.0
```

* `swapoff -a` Disable swap (must be root)
* `nano /etc/fstab` comment out last line (swap line)

#### Installing Docker on VM

* `https://docs.docker.com/install/linux/docker-ce/ubuntu/` for latest instructions on ubuntu
  * install https tools
  * Add docker package repository
  * Add GPG key
* `https://kubernetes.io/docs/tasks/tools/install-kubectl/` for kubectl kubeadm kubelet installation

#### Bridged Adapter on VirtualBox doesn't connect to Mac WiFi

In VirtualBox, VM's Network panel, click on advanced, click on Port Forwarding button. In there set up a rule:
```
Host IP: 127.0.0.1
Host Port: 2222
Guest IP: 10.0.2.15
Guest Port: 22
```

Then enable ssh in the guest, and I'm able to connect from the host using:

`ssh -p 2222 osboxes@127.0.0.1`

### minikube for single local K8

* `brew cask install minikube`
* `minikube start`

### Initialising Master node with kubeadm

See documentation `https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/`.  In our multi-network adaptor config we need to use the `--apiserver-advertise-address=<master-node-ip-address>` for assigning correct IP address to use for master api.

* `kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.99.110`
  * `kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/32a765fd19ba45b387fdc5e3812c41fff47cfd55/Documentation/kube-flannel.yml`
* `kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=192.168.99.110`
  * `kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml` calico pod network
 
```
 To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.99.110:6443 --token 4j8q22.nuq4rmah9kptai7x \
    --discovery-token-ca-cert-hash sha256:e1c04873b0338b831afbc7070b586174c6727278094d9b90a457f215a194d457
```

