# Redis StatefulSet with Data Loader Job

This demo deploys a Redis StatefulSet with 3 replicas and seeds initial data using a Kubernetes Job.

## Steps

### 1. Deploy the Redis Cluster
```bash
# Apply all Redis resources (ConfigMap, Service, StatefulSet, Job)
kubectl apply -f redis/

# Watch pods until all Redis instances and the Job are running
kubectl get pods -w
```

---

### 2. Verify the Data Loader Job
```bash
# Check the Job's logs to confirm data seeding
kubectl logs -c data-loader jobs/redis-data-loader
```
**Expected Output**:  
```
1) "OK"  # Response for SET capital:IRAN
1) "OK"  # Response for SET capital:UK
```

---

### 3. Test Redis Data
```bash
# Connect to the Redis primary (redis-0)
kubectl exec -it redis-0 -- redis-cli

# Query the seeded data
GET capital:IRAN
GET capital:UK
```
**Expected Output**:  
```
"Tehran"
"London"
```

---

### 4. Cleanup
```bash
# Delete all resources
kubectl delete -f redis/

# Delete persistent volumes (if they still exist)
kubectl delete pvc redis-pvc-redis-0
kubectl delete pvc redis-pvc-redis-1
kubectl delete pvc redis-pvc-redis-2
```
