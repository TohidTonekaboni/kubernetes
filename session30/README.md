# Kubernetes Multi-Container Pod with CronJob Log Archiving

This demo demonstrates CronJob for hourly log archiving


## Quick Start

### 1. Apply all resources
```bash
kubectl apply -f multiple-container/
```

### 2. Verify deployment
```bash
kubectl get deployments
kubectl get pods
kubectl get cronjobs
```

### 3. Check logs directory (wait 2-3 minutes for initial logs)
```bash
kubectl exec -it deploy/multi-container-pod -c random-number-api -- ls -l /logs
```

### 4. Clean up
```bash
kubectl delete -f multiple-container/
```