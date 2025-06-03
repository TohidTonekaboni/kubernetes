This project demonstrates how to deploy a pod onto a specific worker node (in this case, `node02`) using the `nodeName` field in Kubernetes.

## Cluster Setup

Assume you have a Kubernetes cluster with one control plane and two worker nodes. You can verify your cluster nodes with the following command:

```bash
kubectl get nodes
```

Expected output:

```
NAME           STATUS   ROLES           AGE     VERSION
controlplane   Ready    control-plane   3d17h   v1.31.0
node01         Ready    worker          3d17h   v1.31.0
node02         Ready    worker          3d17h   v1.31.0
```

## Deployment Configuration

In the `deployment.yaml` file, the pod is configured to run on `node02` by using the `nodeName` field in the pod spec.

## Deploying the Application

To deploy the pod to the `node02` worker node, apply the deployment configuration:

```bash
kubectl apply -f deployment.yaml
```

## Verifying the Deployment

After applying the configuration, you can verify that the pod is running on the correct node by checking the pod details:

```bash
kubectl get pods -o wide
```

This command will display additional information such as the node where each pod is running.

## Cleaning Up

To remove the deployment, use the following command:

```bash
kubectl delete -f deployment.yaml
```