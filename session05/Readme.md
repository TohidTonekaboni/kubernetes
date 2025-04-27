This guide explains how to declaratively describe a Deployment resource in a YAML file and manage it using `kubectl`.


A Deployment in Kubernetes is defined in a YAML file. One of the essential parts of this file is the specification of the Pod that the Deployment will manage.



To create the Deployment described in your YAML file, use the following command:

```sh
kubectl apply -f deployment.yaml
```


If you need to delete the Deployment, use this command:

```sh
kubectl delete -f deployment.yaml
```