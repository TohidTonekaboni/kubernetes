# StatefulSet Redis Example

This README provides step-by-step instructions for deploying a Redis StatefulSet, interacting with it, and cleaning up resources.
This example is inspired by the book Kubernetes for Developers. For more information, check it out.


## Steps

### 1. Apply the Redis StatefulSet and Service
Deploy the StatefulSet and Service configuration files located in the `redis/` directory:
```bash
kubectl apply -f redis/
```

### 2. Verify Pods are Running
List the Redis pods created by the StatefulSet:
```bash
kubectl get pods
```

### 3. Verify Persistent Volume Claims (PVCs)
Ensure that the Persistent Volume Claims (PVCs) are created for each pod:
```bash
kubectl get pvc
```

### 4. Connect to the Primary Redis Pod
Execute the Redis CLI on the primary pod (e.g., `redis-0`):
```bash
kubectl exec -it redis-0 -- redis-cli
```
Set a key-value pair in the Redis primary:
```bash
SET capital:IRAN "Tehran"
```
Exit the CLI:
```bash
exit
```

### 5. Connect to a Replica Redis Pod
Access the Redis CLI on a replica pod (e.g., `redis-1`):
```bash
kubectl exec -it redis-1 -- redis-cli
```
Retrieve the key-value pair from the replica:
```bash
GET capital:IRAN
```
Attempt to set a key-value pair on the replica:
```bash
SET capital:UK "london"
```
You should see the following error:
```bash
(error) READONLY You can't write against a read only replica.
```
Exit the CLI:
```bash
exit
```

### 6. Clean Up Resources
Remove the Redis StatefulSet and Service:
```bash
kubectl delete -f redis/
```

Manually delete the Persistent Volume Claims (PVCs) created for each pod:
```bash
kubectl delete pvc redis-pvc-redis-0
kubectl delete pvc redis-pvc-redis-1
kubectl delete pvc redis-pvc-redis-2
```