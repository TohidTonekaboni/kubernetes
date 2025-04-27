This project consists of two applications deployed in Kubernetes:

1. **random-number-api**: A Flask-based API that generates random numbers.
   - Service Type: ClusterIP
   - Accessed internally within the cluster.

2. **random-number-client**: A Flask-based client web application that fetches random numbers from `random-number-api` and displays them in a web interface.
   - Service Type: NodePort
   - Exposed externally via `localhost:<NodePort>`.

---

## Deployment in Kubernetes

### Deploy `random-number-api`

1. Apply the deployment and service:
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

1. Apply the deployment and service:
   ```bash
   kubectl apply -f random-number-client-deployment.yaml
   kubectl apply -f random-number-client-svc.yaml
   ```

2. Verify the deployment and service:
   ```bash
   kubectl get pods -l app=random-number-client
   kubectl get svc random-number-client-svc
   ```

3. Find the `NodePort`:
   ```bash
   kubectl get svc random-number-client-svc
   ```

   Look for the `NodePort` in the output (e.g., `30080`).

4. Access the application:
   Open a browser or use `curl` to access the application at:
   ```
   http://localhost:<NodePort>
   ```
   Replace `<NodePort>` with the actual port (e.g., `http://localhost:30080`).

   
   - A NodePort service exposes the application on a specific port (within the range 30000–32767) on every node in the Kubernetes cluster.
   You can access it externally using <NodeIP>:<NodePort>.
   In Your Case (Docker Desktop):

   
   
   - If you're using Kubernetes via Docker Desktop, the cluster is typically bound to localhost. Therefore, the NodePort service will be accessible at http://localhost:<NodePort> on your local machine.

---

## Clean Up Resources

To delete all resources:

```bash
kubectl delete -f random-number-api-deployment.yaml
kubectl delete -f random-number-api-svc.yaml
kubectl delete -f random-number-client-deployment.yaml
kubectl delete -f random-number-client-svc.yaml
```

