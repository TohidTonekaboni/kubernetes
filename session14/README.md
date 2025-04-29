This tutorial demonstrates how to use a ConfigMap in a Kubernetes deployment. The steps include creating a ConfigMap from a file, updating a Deployment to use it, and verifying the ConfigMap values in a container.

## Step 1: Create a ConfigMap File

Create a directory named `configmap` and a file `config.env` with the following content:

```env
STATUS=beta
HOSTNAME=random-number-generator
```

---

## Step 2: Create the ConfigMap

Run the following command to create a ConfigMap named `random-api-config` from the `config.env` file. Note that the `--from-env-file` option processes the file as environment variables, where each line in the file corresponds to a key-value pair:

```bash
kubectl create configmap random-api-config --from-env-file=configmap/config.env
kubectl describe cm/random-api-config
```

---

## Step 3: Update the Deployment

Edit your deployment YAML file (e.g., `random-number-api-deployment.yaml`) to include the ConfigMap values as environment variables for the container. Update the `spec` section of the container as follows:

```yaml
        envFrom:
        - configMapRef:
            name: random-api-config
```

Apply the updated deployment:

```bash
kubectl apply -f random-number-api-deployment.yaml
```

---

## Step 4: Verify the ConfigMap in the Container

Once the deployment is running, you can verify that the environment variables have been correctly set inside the container:

1. Get a shell into one of the pods in the deployment:

   ```bash
   kubectl exec -it deploy/random-number-api-deployment -- sh
   ```

2. Print the `STATUS` and `HOSTNAME` environment variables:

   ```bash
   printenv STATUS
   printenv HOSTNAME
   ```

You should see the following output:

```plaintext
beta
random-number-generator
```

---

## Step 5: Use Specific ConfigMap Keys in Another Deployment

To use a specific key (e.g., `STATUS`) from the `random-api-config` ConfigMap in another deployment, update the `env` section of the deployment YAML file (e.g., `random-number-client-deployment.yaml`) as follows:

```yaml
        env:
        - name: STATUS
          valueFrom:
            configMapKeyRef:
              name: random-api-config
              key: STATUS
```

Apply the updated deployment:

```bash
kubectl apply -f random-number-client-deployment.yaml
```

Verify the `STATUS` environment variable in the new pod:

1. Get a shell into one of the pods in the client deployment:

   ```bash
   kubectl exec -it deploy/random-number-client-deployment -- sh
   ```

2. Print the `STATUS` environment variable:

   ```bash
   printenv STATUS
   ```

You should see the following output:

```plaintext
beta
```

---

## Step 6: Clean Up

To delete the ConfigMap and the Deployments, run the following commands:

```bash
kubectl delete configmap random-api-config
kubectl delete -f random-number-api-deployment.yaml
kubectl delete -f random-number-client-deployment.yaml
```