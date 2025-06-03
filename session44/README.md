# Kubernetes Node Labeling and Node Selector

This lab will guide you through the process of labeling a Kubernetes node, deploying an application that targets the labeled node using a nodeSelector, verifying the deployment, and cleaning up afterward.

## Steps

1. **Verify the Current Labels on node02**

   Run the following command to view all labels on **node02**:
   ```bash
   kubectl get node node02 --show-labels
   ```

2. **Label node02**

   Apply a label to **node02** with key `serv` and value `customer`:
   ```bash
   kubectl label node node02 serv=customer
   ```
   This label will later be used by the deployment's `nodeSelector`.

3. **Deploy the Application**

   Apply the deployment configuration:
   ```bash
   kubectl apply -f deployment.yaml
   ```
   The **deployment.yaml** file should include a `nodeSelector` that matches the label `serv=customer`.

4. **Verify the Deployment and Pod Scheduling**

   Check that the pods have been scheduled on the correct node:
   ```bash
   kubectl get pods -o wide
   ```
   The output will show which node each pod is running on.

5. **Clean Up the Deployment**

   Delete the deployment and all its resources:
   ```bash
   kubectl delete -f deployment.yaml
   ```

6. **Remove the Label from node02**

   Finally, remove the label from **node02**:
   ```bash
   kubectl label node node02 serv-
   ```