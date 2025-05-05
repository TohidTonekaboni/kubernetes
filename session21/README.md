# Random Number Project in Kubernetes

This project demonstrates the use of the `replicas` field in Kubernetes Deployments by deploying two applications with different replica settings:

1. **random-number-api**: A Flask-based API that generates random numbers.
   - Service Type: ClusterIP
   - Accessed internally within the cluster.
   - Replicas: 2

2. **random-number-client**: A Flask-based client web application that fetches random numbers from `random-number-api` and displays them in a web interface.
   - Service Type: LoadBalancer
   - Exposed externally for users to interact with.
   - Replicas: 3

## Deployment in Kubernetes

Deploy the applications by running the following command:

```bash
kubectl apply -f random-number/
```

This will create the necessary Deployment and Service objects:

- Deployment: `random-number-api-deployment`
- Service: `random-number-api-svc`
- Deployment: `random-number-client-deployment`
- Service: `random-number-client-svc`

### Verify Deployments

Check the running Pods:
```bash
kubectl get pods
```

Check the ReplicaSets created for the Deployments:
```bash
kubectl get rs
```

## Clean Up Resources

To delete all resources created for this project, run:
```bash
kubectl delete -f random-number/
