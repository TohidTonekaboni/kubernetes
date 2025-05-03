# Redis Deployment with ConfigMap in Kubernetes

This guide helps students learn to use ConfigMap with the help of Volumes in Kubernetes.

---

## Steps
kubectl create configmap redis-config --from-file=configmap/redis.conf
kubectl describe cm redis-config
### 1. Create a ConfigMap for Redis Configuration

Apply the ConfigMap to the cluster:

```bash
kubectl apply -f redis-config.yaml
```

### 2. Create the Redis Deployment

Apply the Deployment to the cluster:

```bash
kubectl apply -f redis-deployment.yaml
```

### 3. Verify the Configuration

Access the Redis Pod:

```bash
kubectl exec -it deploy/redis-deployment -c redis -- sh
```

Check the Redis configuration file:

```bash
cat /usr/local/etc/redis/redis.conf
```

Launch the Redis CLI:

```bash
redis-cli
```

Verify configuration values:

```bash
CONFIG GET appendonly
CONFIG GET dir
CONFIG GET bind
CONFIG GET port
```

### 4. Clean Up Resources

To delete the ConfigMap and Deployment, run:

```bash
kubectl delete -f redis-config.yaml
kubectl delete -f redis-deployment.yaml
```
