
Install a helmchart folder

`helm install <name> folder` e.g. `helm install my-nginx-release .`

Uninstall a running helmchart

`helm uninstall <name>` e.g. `helm uninstall my-nginx-release`

Get the application URL by running these commands:

```
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=maven-nginx-helmchart,app.kubernetes.io/instance=maven-nginx" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```
