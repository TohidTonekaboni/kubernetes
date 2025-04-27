This project consists of two applications deployed in Kubernetes:

1. **random-number-api**: A Flask-based API that generates random numbers.
   - Service Type: ClusterIP
   - Accessed internally within the cluster.

2. **random-number-client**: A Flask-based client web application that fetches random numbers from `random-number-api` and displays them in a web interface.
   - Service Type: LoadBalancer
   - Exposed externally for users to interact with.



## Build and Push Docker Images

### Build Images Locally

1. Navigate to the `random-number-api` directory and build the image:
   ```bash
   cd random-number-api
   docker build -t random-number-api:1.0.0 .
   ```

2. Navigate to the `random-number-client` directory and build the image:
   ```bash
   cd ../random-number-client
   docker build -t random-number-client:1.0.0 .
   ```

### Push Images to a Container Registry
Ensure you are logged in to your container registry (e.g., Docker Hub or another registry):

```bash
# Tag and push random-number-api
docker tag random-number-api:1.0.0 <your-registry>/random-number-api:1.0.0

docker push <your-registry>/random-number-api:1.0.0

# Tag and push random-number-client
docker tag random-number-client:1.0.0 <your-registry>/random-number-client:1.0.0

docker push <your-registry>/random-number-client:1.0.0
```

Replace `<your-registry>` with your actual container registry (e.g., `docker.io/username`).

---

## Deployment in Kubernetes

### Deploy `random-number-api`

1. Apply the deployment and service YAML files:
   ```bash
   kubectl apply -f random-number-api-deployment.yaml
   kubectl apply -f random-number-api-svc.yaml
   ```

2. Verify the deployment and service:
   ```bash
   kubectl get pods -l app=random-number-api
   kubectl get svc random-number-api-svc
   ```

### Deploy `random-number-client`

1. Apply the deployment and service YAML files:
   ```bash
   kubectl apply -f random-number-client-deployment.yaml
   kubectl apply -f random-number-client-svc.yaml
   ```

2. Verify the deployment and service:
   ```bash
   kubectl get pods -l app=random-number-client
   kubectl get svc random-number-client-svc
   ```

3. Get the external IP of the `random-number-client` service:
   ```bash
   kubectl get svc random-number-client-svc
   ```

   Access the web application using the external IP and default port (e.g., `http://<external-ip>`).

---

## Application Workflow

1. The `random-number-client` web app sends requests to `random-number-api` using the service name `random-number-api-svc` (ClusterIP).
2. The `random-number-api` generates a random number and returns it to the client app.
3. The result is displayed in the web interface of `random-number-client`.

---

## Clean Up Resources

To delete all resources, run:
```bash
kubectl delete -f random-number-api-deployment.yaml
kubectl delete -f random-number-api-svc.yaml
kubectl delete -f random-number-client-deployment.yaml
kubectl delete -f random-number-client-svc.yaml
```


## Troubleshooting

### Check Logs
If an application is not behaving as expected, check the logs:
```bash
kubectl logs <pod-name>
```
Replace `<pod-name>` with the name of the specific pod.

### Debugging Pods
If a pod is not running correctly, inspect its details:
```bash
kubectl describe pod <pod-name>
```

### Check Service Reachability
Ensure the services are reachable:
```bash
kubectl get svc
curl http://<service-ip>
```

