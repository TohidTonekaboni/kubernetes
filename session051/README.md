# Kubernetes Service Account

This repository provides a simple demonstration on how to create a Service Account, set up RBAC (Role-Based Access Control), and run a Pod that uses that Service Account to interact with the Kubernetes API.

### 1. Deploy the Resources

Apply the manifests in the following order:

```bash
kubectl apply -f service-account.yaml
kubectl apply -f role.yaml
kubectl apply -f role-binding.yaml
kubectl apply -f pod.yaml
```

### 2. Test the Pod

After deploying the Pod, open a shell into it to verify that it can list the pods:

```bash
kubectl exec -it list-pod -- sh
```

Inside the pod's shell, run:

```bash
kubectl get pods
```

You should see a list of pods from the `default` namespace. Once done, type `exit` to leave the shell.

### 3. Clean Up the Resources

After testing, you can remove all the created resources by running:

```bash
kubectl delete -f service-account.yaml
kubectl delete -f role.yaml
kubectl delete -f role-binding.yaml
kubectl delete -f pod.yaml
```
