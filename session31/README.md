# Redis StatefulSet Rollout Demo

This demo shows how to perform rolling updates and rollbacks in a Redis StatefulSet. Follow these commands in order:

---

## **1. Deploy the Initial Redis StatefulSet**
```bash
kubectl apply -f redis/
```
Applies the Redis StatefulSet and associated resources (Service, ConfigMap, PVCs) defined in the `redis/` directory.

---

## **2. Verify Initial Deployment**
```bash
kubectl get statefulset redis -o wide
```
Check the StatefulSet status:
- `DESIRED`: Number of replicas (should show `3`)
- `CURRENT`: Running pods
- `IMAGE`: Verify it shows `redis:7.4` (or your initial image)

---

## **3. Modify the Configuration**
Edit `redis-statefulset.yaml` to make two changes:

### A. Change Container Image
Update:
```yaml
containers:
  - name: redis-container
    image: redis:7.4-alpine  # ← Change from redis:7.4-image
```

### B. Update Readiness Probe
Change from `bash` to `sh`:
```yaml
readinessProbe:
  exec:
    command:
      - sh  # ← Changed from bash
```

**Why?** Alpine-based images don’t include `bash`, so we use `sh` instead.

---

## **4. Apply the Changes**
```bash
kubectl apply -f redis/
```
Triggers a rolling update. Kubernetes will update Pods sequentially in reverse ordinal order (Pod 2 → 1 → 0).

---

## **5. Verify the Update**
```bash
kubectl get statefulset redis -o wide
```
Confirm the `IMAGE` column now shows `redis:7.4-alpine`.

---

## **6. Monitor the Rollout**
```bash
kubectl rollout status statefulset/redis
```
Watch the live progress. You’ll see:
```
Waiting for partitioned roll out to finish: 2 out of 3 new pods have been updated...
partitioned roll out complete: 3 new pods have been updated...
```

---

## **7. Roll Back to Previous Version**
```bash
kubectl rollout undo statefulset/redis
```
Reverts to the previous working version (undoes the image and probe changes).

---

## **8. Confirm Rollback**
```bash
kubectl get statefulset redis -o wide
```
Verify the `IMAGE` column shows the original version (e.g., `redis:7.4`).

---

## **9. Clean Up Resources**
```bash
kubectl delete -f redis/
```
```bash
kubectl delete pvc --all
```