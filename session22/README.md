# Random Number Project in Kubernetes

This project demonstrates resource management in Kubernetes with a simple Flask-based application consisting of two components:

1. **random-number-api**: An internal API that generates random numbers.
   - **Service Type**: ClusterIP
   - Accessible only within the cluster.

2. **random-number-client**: A web client that fetches and displays random numbers from `random-number-api`.
   - **Service Type**: LoadBalancer
   - Accessible externally for user interaction.

## Resource Requests and Limits

Kubernetes allows you to specify resource requests and limits for containers to manage CPU and memory allocation efficiently:

- **Requests**: Ensure the kube-scheduler places the Pod on a node with sufficient resources.
- **Limits**: Prevent containers from exceeding the specified resource usage.

## Deployment

Deploy the application using the following command:

```bash
kubectl apply -f random-number/
```

This will create the following resources:

- **Deployments**:
  - `random-number-api-deployment`
  - `random-number-client-deployment`
- **Services**:
  - `random-number-api-svc`
  - `random-number-client-svc`

### Verifying Deployments

To ensure the Pods are running, use:
```bash
kubectl get pods
```

Monitor resource usage with:
```bash
kubectl top pod
```

## Cleaning Up

To remove all resources created by this project, run:
```bash
kubectl delete -f random-number/
```