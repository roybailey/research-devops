# K8 WordPress

## Getting Started

### Install Docker desktop and enable kubernetes

* Make sure you've got Docker Desktop installed
* Check under Preferences the Kubernetes tab has Kubernetes enabled
* Check Kubernetes has started successfully

### Start Wordpress

```
kubectl apply -k ./
```

#### Find local volume mapping

* `kubectl get pvc`
* `kubectl describe pv/<volume>`
  * e.g. `kubectl describe pv/pvc-46d3ea22-0c82-11ea-a488-025000000001`

#### Connecting to Kubernetes MySQL Database from outside the cluster

* `kubectl port-forward pod/<mysql-pod-identifier> 3306:3306`
  * e.g. `kubectl port-forward pod/wordpress-mysql-689869c87d-jtmgl 3306:3306`

#### Connecting to Kubernetes MySQL Database from inside the cluster

* Use the K8 name from the `mysql-deployment` e.g. `wordpress-mysql`
 
### Shutdown Wordpress

```
kubectl delete -k ./
```

## Reference Material

* See `https://ervikrant06.github.io/kubernetes/Kubernetes-Storage-Persistent-Volume/` for help finding volumes

