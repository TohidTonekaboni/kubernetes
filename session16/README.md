# PostgreSQL Deployment with Secret in Kubernetes

This guide helps students learn to use Secrets with the help of Volumes in Kubernetes for a secure Postgres deployment.

---

## Steps

### 1. Create a Secret for Postgres Password

Create a Secret to store the Postgres password. You can apply the Secret by running:

```bash
kubectl apply -f postgres-secret.yaml
```

### 2. Create the PostgreSQL Deployment

Apply the Deployment to the cluster:

```bash
kubectl apply -f postgres-deployment.yaml
```


### 3. Verify the Secret Permissions

To ensure the secret file (`postgres-password`) has the correct `0400` permissions, use the following command inside the Postgres container. First, access the container:

```bash
kubectl exec -it deploy/postgres-deployment -c postgres -- sh
```

```bash
echo $POSTGRES_PASSWORD_FILE
```

Then, check the permissions of the mounted secret file:

```bash
ls -l $(readlink -f /etc/secrets/postgres-password)
```

This will show you the full path and permissions of the `postgres-password` file. Ensure the permissions are set to `-r--------` (read-only for root).



### 5. Access PostgreSQL from Inside the Pod

You can also access the Postgres database using `psql`. Inside the Pod, run the following command:

```bash
psql -U postgres -d postgres
```

You should now be able to interact with the Postgres database.

### 6. Clean Up Resources

To delete the Secret and Deployment, run:

```bash
kubectl delete -f postgres-secret.yaml
kubectl delete -f postgres-deployment.yaml
```