# Random Number API

This repository contains the Kubernetes manifests to deploy the Random Number API along with a Horizontal Pod Autoscaler (HPA) that scales the application between 1 and 3 replicas based on average CPU utilization.


## Deployment

To deploy the Random Number API and its autoscaling configuration, run:

```bash
kubectl apply -f random-number/
```

This command applies all YAML files in the `random-number/` directory, including:
- **`hpa.yaml`**: Configures the Horizontal Pod Autoscaler to maintain an average CPU utilization of 50% across the pods.

## Verification

After deployment, you can verify that the resources are running correctly.

- **Check Pods:**

  ```bash
  kubectl get pods
  ```

- **Check Deployment:**

  ```bash
  kubectl get deployments
  ```

- **Check Horizontal Pod Autoscaler:**

  ```bash
  kubectl get hpa
  ```

## Scaling Behavior

The HPA monitors the average CPU utilization of your pods. When the CPU load increases and exceeds the target of 50%, the HPA will increase the number of pods (up to a maximum of 3). When the load decreases, it will scale down the pods (but not below 1).

## Cleanup

To remove all the resources created by this deployment, run:

```bash
kubectl delete -f random-number/
```
