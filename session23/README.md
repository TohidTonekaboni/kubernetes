# Multi-Container Kubernetes Application

This project demonstrates a multi-container Kubernetes application with a Fluentd sidecar for logging and a Random Number API.

## Steps to Run the Application

### 1. Deploy the Application

Run the following command to deploy the application:

```bash
kubectl apply -f multiple-container/
```

### 2. Access the Application

Once deployed, access the Random Number API in your browser or through a tool like curl:

```bash
http://localhost/generate
```

### 3. Check Fluentd Logs

To view logs from the Fluentd sidecar container, run:

```bash
kubectl logs deploy/multi-container-pod -c fluentd-sidecar
```

### 4. Clean Up Resources

To delete the deployment and all associated resources:

```bash
kubectl delete -f multiple-container/
```
