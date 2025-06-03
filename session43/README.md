# Kubernetes Taints and Tolerations

This lab demonstrates how Kubernetes uses taints and tolerations to control pod scheduling. We will work through several scenarios that illustrate the effects of taints on worker nodes and how to allow pods to be scheduled using appropriate tolerations.


The initial state of the cluster is:

```bash
kubectl get nodes

NAME           STATUS   ROLES           AGE    VERSION
controlplane   Ready    control-plane   5d3h   v1.31.0
node01         Ready    worker          5d3h   v1.31.0
node02         Ready    worker          5d3h   v1.31.0
```

---

## Scenario 1: Tainting Worker Nodes Without Tolerations

In this scenario, you taint the worker nodes with a GPU-related taint and then try to deploy a pod that does not have any tolerations.

1. **Taint the worker nodes:**

   ```bash
   kubectl taint nodes node01 gpu=true:NoSchedule
   kubectl taint nodes node02 gpu=true:NoSchedule
   ```

2. **Verify the taints:**

   ```bash
   kubectl describe node node01 | grep Taints
   ```

   Output should show:

   ```
   Taints:             gpu=true:NoSchedule
   ```

3. **Apply the deployment:**

   ```bash
   kubectl apply -f deployment.yaml
   ```

4. **Check the pod status:**

   ```bash
   kubectl get pods
   ```

   The output should show the pod in a **Pending** state because it does not tolerate the taint:

   ```
   NAME                          READY   STATUS    RESTARTS   AGE
   hello-kube-6bcb845c8b-99z6j   0/1     Pending   0          14s
   ```

5. **Clean up:**

   ```bash
   kubectl delete -f deployment.yaml
   ```

---

## Scenario 2: One Node Is Taint

In this scenario, we remove the taint from one of the nodes (node01) and then reapply the deployment. This shows that the pod can now be scheduled on the untainted node.

1. **Remove the taint from node01:**

   ```bash
   kubectl taint nodes node01 gpu=true:NoSchedule-
   ```

2. **Reapply the deployment:**

   ```bash
   kubectl apply -f deployment.yaml
   ```

3. **Verify the pod’s status and node assignment:**

   ```bash
   kubectl get pods -o wide
   ```

   Expected output:

   ```
   NAME                                   READY   STATUS    RESTARTS   AGE   IP               NODE     NOMINATED NODE   READINESS GATES
   hello-kube-critical-6c58bc97d4-l48qc   1/1     Running   0          6s    172.16.196.146   node01   <none>           <none>
   ```

4. **Clean up:**

   ```bash
   kubectl delete -f deployment.yaml
   ```

---

## Scenario 3: Adding Tolerations to Allow Scheduling on Tainted Nodes

Now we will modify the deployment to add a toleration, allowing the pod to be scheduled on the tainted node (node02).

1. **Update your `deployment.yaml` to include the following toleration:**

   ```yaml
       spec:
         tolerations:
         - key: "gpu"
           operator: "Equal"
           value: "true"
           effect: "NoSchedule"
   ```

2. **Apply the updated deployment:**

   ```bash
   kubectl apply -f deployment.yaml
   ```

3. **Verify that the pod is now running on the tainted node:**

   ```bash
   kubectl get pods -o wide
   ```

   Expected output:

   ```
   NAME                                   READY   STATUS    RESTARTS   AGE   IP              NODE     NOMINATED NODE   READINESS GATES
   hello-kube-critical-777f84cb6f-t7dx6   1/1     Running   0          30s   172.16.140.67   node02   <none>           <none>
   ```

4. **Clean up and remove the taint from node02:**

   ```bash
   kubectl delete -f deployment.yaml
   kubectl taint nodes node02 gpu=true:NoSchedule-
   ```

---

## Taint Effects and Toleration Operators

### Taint Effects

- **NoSchedule:**  
  Prevents pods that do not tolerate the taint from being scheduled on the node.

- **NoExecute:**  
  In addition to preventing new pods from being scheduled, this effect evicts already-running pods that do not tolerate the taint.

- **PreferNoSchedule:**  
  Acts as a soft constraint where the scheduler tries to avoid placing pods on the node, but if no other options are available, the pod may still be scheduled.

### Toleration Operators

- **Equal:**  
  The toleration matches only if the taint’s key and value are exactly the same as specified in the toleration.  
  Example:
  ```yaml
  tolerations:
  - key: "gpu"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
  ```

- **Exists:**  
  The toleration matches any taint with the specified key, regardless of the value.  
  Example:
  ```yaml
  tolerations:
  - key: "gpu"
    operator: "Exists"
    effect: "NoSchedule"
  ```