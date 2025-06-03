# Kubernetes Node Affinity

This lab demonstrates how to use node affinity in Kubernetes to control pod scheduling based on node labels. In this lab, you'll label a node to simulate a GPU-equipped machine, deploy an application with node affinity rules that exclude GPU nodes, and verify the scheduling behavior.


## Steps

1. **View Current Nodes and Their Labels**

   Start by checking the nodes in your cluster and their labels:

   ```bash
   kubectl get nodes --show-labels
   ```

2. **Label a Node**

   For this lab, label `node02` with `gpu=true` to simulate a node with GPU capabilities:

   ```bash
   kubectl label node node02 gpu=true
   ```

3. **Deploy the Application**

   Apply the deployment configuration that includes node affinity rules:

   ```bash
   kubectl apply -f deployment.yaml
   ```

   The deployment is configured to schedule pods only on nodes with an `amd64` architecture and to avoid nodes with the label `gpu=true`.

4. **Verify Pod Scheduling**

   Check the pods' details to see which node they are running on:

   ```bash
   kubectl get pods -o wide
   ```

   This output will help you verify that the pod is not scheduled on the node labeled with `gpu=true`.

5. **Clean Up the Deployment**

   Once you've finished exploring the lab, delete the deployment:

   ```bash
   kubectl delete -f deployment.yaml
   ```

6. **Remove the Node Label**

   Finally, remove the `gpu` label from `node02`:

   ```bash
   kubectl label node node02 gpu-
   ```