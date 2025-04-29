# Kubernetes Inline Environment Variables 



## 1. Apply a Deployment

First, deploy the application using the following command:

```bash
kubectl apply -f random-number-api-deployment.yaml
```



---

## 2. Verify the Deployment

To check the status of your deployment, use:

```bash
kubectl get deployments
```

---

## 3. Access the Pod's Shell

To interact with a container inside a pod, execute:

```bash
kubectl exec -it deploy/random-number-api-deployment -- sh
```

---

## 4. Print Environment Variables

While inside the container, check the environment variables:

```bash
printenv HOSTNAME
```

This command outputs the value of the `HOSTNAME` variable, which typically represents the name of the pod running the container. Each pod in Kubernetes gets a unique hostname.

---

## 5. Define Environment Variables in the Deployment

In the `random-number-api-deployment.yaml` file, you can define environment variables directly using the `env` field:

```yaml
spec:
  containers:
  - name: random-number-api
    image: aaghamohammadi/random-number-api:1.0.0
    ports:
    - containerPort: 5000
    env:
    - name: STATUS
      value: beta
```

- `env`: A field for specifying environment variables.
- `name`: The name of the environment variable.
- `value`: The value assigned to the environment variable.

In this example, the `STATUS` variable is set to `beta`.

---

## 6. Re-apply the Deployment

If you have modified the deployment file, re-apply it:

```bash
kubectl apply -f random-number-api-deployment.yaml
```

This updates the deployment with the new configuration, replacing the running pods if necessary.

---

## 7. Verify Updated Environment Variables

Access the shell of the new pod:

```bash
kubectl exec -it deploy/random-number-api-deployment -- sh
```

Inside the container, check the `STATUS` environment variable:

```bash
printenv STATUS
```

This should output `beta`, as defined in the deployment file.

Additionally, check the `HOSTNAME` variable again:

```bash
printenv HOSTNAME
```

Note: The `HOSTNAME` value may have changed because the pod was replaced during the re-application of the deployment.
