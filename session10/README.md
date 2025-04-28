# SpaceX Data Fetcher Application

1. **SpaceX API Service**: A Kubernetes ExternalName Service that resolves to the public SpaceX API.
   - Service Type: ExternalName
   - Resolves the DNS of the SpaceX API (`api.spacexdata.com`).

2. **SpaceX App**: A Flask-based web application that fetches and displays the latest SpaceX launch data.
   - Service Type: LoadBalancer
   - Exposed externally for users to interact with.

---

## Build and Push Docker Image

### Build Image Locally

Navigate to the `spacex-app` directory and build the image:

```bash
cd spacex-app
docker build -t spacex-app:1.0.0 .
```

### Push Image to a Container Registry

Ensure you are logged in to your container registry (e.g., Docker Hub):

```bash
# Tag and push spacex-app image
docker tag spacex-app:1.0.0 <your-registry>/spacex-app:1.0.0

docker push <your-registry>/spacex-app:1.0.0
```

Replace `<your-registry>` with your actual container registry (e.g., `docker.io/username`).

---

## Deployment in Kubernetes

### Deploy SpaceX API Service

1. Apply the ExternalName Service YAML file:
   ```bash
   kubectl apply -f spacex-api-svc.yaml
   ```

2. Verify the service:
   ```bash
   kubectl get svc spacex-api-service
   ```

### Deploy SpaceX App

1. Apply the deployment and service YAML files:
   ```bash
   kubectl apply -f spacex-app-deployment.yaml
   kubectl apply -f spacex-app-svc.yaml
   ```

2. Verify the deployment and service:
   ```bash
   kubectl get pods -l app=spacex-app
   kubectl get svc spacex-app
   ```

3. Get the external IP of the `spacex-app` service:
   ```bash
   kubectl get svc spacex-app
   ```

   Access the web application using the external IP and port (e.g., `http://<external-ip>:8080`).

---

## Application Workflow

1. The `spacex-app` web application sends requests to the `spacex-api-service` (ExternalName Service), which resolves to the SpaceX public API.
2. The SpaceX API responds with the latest launch data, which the `spacex-app` displays in its web interface.

---

## Clean Up Resources

To delete all resources, run:

```bash
kubectl delete -f spacex-api-svc.yaml
kubectl delete -f spacex-app-deployment.yaml
kubectl delete -f spacex-app-svc.yaml
```

