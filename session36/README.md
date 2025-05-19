# Redis Helm Chart Deployment

This repository contains a Helm chart for deploying a Redis cluster on Kubernetes. The chart sets up a StatefulSet with one primary and multiple replica pods, each with its own persistent volume claim (PVC) for data storage.


## Chart Overview

The chart deploys:
- **StatefulSet:** Redis instances (with a primary and replicas).
- **ConfigMap:** Redis configuration files for primary and replica roles.
- **Headless Service:** Provides stable network identities for the StatefulSet pods.
- **Persistent Volume Claims (PVCs):** To ensure data persistence.

## Installation

To deploy the Redis cluster with 4 replicas (one primary and three replicas), run:

```bash
helm install redisapp ./redis --set replicaCount=4
```

This command uses the Helm chart in the `./redis` directory and sets the number of replicas to 4. The pods will be named `redis-0`, `redis-1`, `redis-2`, and `redis-3` respectively, with `redis-0` acting as the primary.

## Testing the Deployment

1. **Set a Key on the Primary**

   Open a shell to the primary pod and set a key:

   ```bash
   kubectl exec -it redis-0 -- redis-cli
   ```

   Inside the Redis CLI, type:

   ```redis
   SET capital:IRAN "Tehran"
   ```

   Exit the CLI (you can type `exit`).

2. **Get the Key from a Replica**

   Open a shell to one of the replica pods and retrieve the key:

   ```bash
   kubectl exec -it redis-1 -- redis-cli
   ```

   Inside the Redis CLI, type:

   ```redis
   GET capital:IRAN
   ```

   You should see the output `"Tehran"`, confirming that the replication is working correctly.

## Uninstallation

To remove the Redis deployment, run:

```bash
helm uninstall redisapp
```

After uninstalling the release, you might want to clean up the persistent volumes manually to remove any stored data. Delete the PVCs with the following commands:

```bash
kubectl delete pvc redis-pvc-redis-0
kubectl delete pvc redis-pvc-redis-1
kubectl delete pvc redis-pvc-redis-2
kubectl delete pvc redis-pvc-redis-3
```

> **Note:** If you deployed more than three replicas (e.g., if you had a `redis-3` PVC), be sure to delete those PVCs as well.

## Cleanup Verification

To ensure all resources have been removed, you can list the remaining resources:

```bash
kubectl get all
kubectl get pvc
```
