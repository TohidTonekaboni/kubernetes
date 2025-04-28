# SpaceX Data Fetcher Application

1. **SpaceX API Service**: A Kubernetes headless Service that resolves to the public SpaceX API via manually defined EndpointSlices.
   - Service Type: Headless (ClusterIP: None)
   - Resolves the SpaceX API's IP addresses using EndpointSlice.

2. **SpaceX App**: A Flask-based web application that fetches and displays the latest SpaceX launch data.
   - Service Type: LoadBalancer
   - Exposed externally for users to interact with.

---

## Deployment in Kubernetes

### Deploy SpaceX API Service

1. Apply the headless Service YAML file:
   ```bash
   kubectl apply -f spacex-api-svc.yaml
   ```

2. Apply the EndpointSlice YAML file:
   ```bash
   kubectl apply -f spacex-api-endpointslice.yaml
   ```

3. Verify the service:
   ```bash
   kubectl get svc spacex-api-service
   ```

4. Verify the EndpointSlice:
   ```bash
   kubectl get endpointslice spacex-api-service-slice
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

1. The `spacex-app` web application sends requests to the `spacex-api-service` (headless Service), which resolves to the IP addresses of the SpaceX public API provided in the EndpointSlice.
2. The SpaceX API responds with the latest launch data, which the `spacex-app` displays in its web interface.

---

## Clean Up Resources

To delete all resources, run:

```bash
kubectl delete -f spacex-api-svc.yaml
kubectl delete -f spacex-api-endpointslice.yaml
kubectl delete -f spacex-app-deployment.yaml
kubectl delete -f spacex-app-svc.yaml
```