
This example demonstrates the use of an `emptyDir` volume in Kubernetes for caching data. You will observe how `emptyDir` behaves during pod replacements and deletions.

## Steps to Deploy and Test

### 1. Deploy the Example
Apply the `deployment.yaml` file:

```bash
kubectl apply -f deployment.yaml
```

Verify the pod is running:

```bash
kubectl get pods
```

### 2. Inspect the `emptyDir` Volume
Exec into the pod and check the cached data in `/cache/data.txt`:

```bash
kubectl exec -it deploy/cache-example -c cache-container -- sh
cat /cache/data.txt
```

You should see lines like:

```plaintext
Cached data 1 at Mon Jan 1 12:00:00 UTC 2025
Cached data 2 at Mon Jan 1 12:00:05 UTC 2025
Cached data 3 at Mon Jan 1 12:00:10 UTC 2025
```

### 3. Simulate a Pod Replacement
Use the `killall5` command to force the pod to restart:

```bash
kubectl exec deploy/cache-example -c cache-container -- killall5
```

Verify the pod has been replaced:

```bash
kubectl get pods
```

Exec into the new pod and check the cached data:

```bash
kubectl exec -it deploy/cache-example -c cache-container -- sh
cat /cache/data.txt
```

The data should be **preserved**, showing the previous entries.

### 4. Simulate Pod Deletion
Delete the pod manually to simulate data loss:

```bash
kubectl delete pod <pod-name>
```

Wait for Kubernetes to recreate the pod. Then, exec into the new pod and check the cached data:

```bash
kubectl exec -it deploy/cache-example -c cache-container -- sh
cat /cache/data.txt
```

The data will **not be preserved**, as the `emptyDir` volume is deleted along with the pod.

---

## Expected Observations
1. **Pod Replacement**: Data in the `emptyDir` volume persists when the pod is replaced (e.g., via `killall5`).
2. **Pod Deletion**: Data in the `emptyDir` volume is lost when the pod is deleted.

---

## Cleanup
To remove all resources:

```bash
kubectl delete -f deployment.yaml
```
