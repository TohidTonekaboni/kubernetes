# Guide to Persistent Volumes in Kubernetes

This guide will help you deploy PostgreSQL with a `PersistentVolume` and `PersistentVolumeClaim` in Kubernetes. The primary goal is to demonstrate that data persists even if the pod is deleted and recreated.

## 1. Set Up the PostgreSQL Secret

1. **Apply the PostgreSQL Secret**:
   Before deploying PostgreSQL, apply the provided `postgres-secret.yaml` to create the necessary secret:
   ```bash
   kubectl apply -f postgres-secret.yaml
   ```

## 2. Deploy PostgreSQL in Kubernetes

1. **Apply the PersistentVolume and PersistentVolumeClaim**:
   Set up the storage resources by applying `pvc.yaml`:
   ```bash
   kubectl apply -f pvc.yaml
   ```

2. **Apply the Deployment**:
   Deploy PostgreSQL using the provided `postgres-deployment.yaml`:
   ```bash
   kubectl apply -f postgres-deployment.yaml
   ```

3. **Verify the Deployment**:
   Check if the PostgreSQL pod is running:
   ```bash
   kubectl get pods
   ```

## 3. Access the PostgreSQL Pod

1. **Get the Pod Name**:
   Find the name of the PostgreSQL pod:
   ```bash
   kubectl get pods
   ```

2. **Access the Pod**:
   Connect to the pod using `kubectl exec`:
   ```bash
   kubectl exec -it <postgres-pod-name> -- psql -U postgres
   ```

   Replace `<postgres-pod-name>` with the actual pod name.

## 4. Working with Databases in PostgreSQL

### 4.1. Create a Test Database (`testdb`)

To create a test database, run the following command inside the `psql` shell:

```sql
CREATE DATABASE testdb;
```

### 4.2. Insert Data into `testdb`

Once `testdb` is created, you can insert some sample data. For example:

```sql
\c testdb
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

INSERT INTO users (name, age) VALUES ('Alice', 30), ('Bob', 25), ('Charlie', 35);
```

### 4.3. Verify the Data

Check the data you just inserted:

```sql
SELECT * FROM users;
```

## 5. Test Data Persistence with Persistent Volume

### 5.1. Verify the Persistent Volume Data

The PostgreSQL pod is configured to use a `PersistentVolume` for persistent data. Data written inside the pod will be stored in `/data/postgres` on the host machine (or according to the `PersistentVolume` configuration). This can be tested by inserting data into PostgreSQL (as shown in the previous steps).

### 5.2. Delete the PostgreSQL Pod

To test the persistence of data, delete the PostgreSQL pod:
```bash
kubectl delete pod <postgres-pod-name>
```

### 5.3. Verify New Pod Creation

Kubernetes will automatically create a new pod to replace the deleted one. You can verify that the new pod is running by checking the pod status:

```bash
kubectl get pods
```

### 5.4. Access the New Pod

Once the new pod is running, access the PostgreSQL shell again:

```bash
kubectl exec -it <new-postgres-pod-name> -- psql -U postgres
```

### 5.5. Check Data Persistence

Inside the new pod, verify that the data you inserted into the `testdb` database is still there:

```sql
\c testdb
SELECT * FROM users;
```

You should see the same data that was inserted before the pod was deleted, confirming that the data persisted through the pod restart.

## 6. Cleaning Up Resources

1. **Drop the Test Database (`testdb`)**:
   Once you're done with testing, drop the test database:
   ```sql
   DROP DATABASE testdb;
   ```

2. **Delete the PostgreSQL Deployment**:
   After finishing the tests, delete the PostgreSQL deployment to clean up:
   ```bash
   kubectl delete -f postgres-deployment.yaml
   ```

3. **Delete the PersistentVolume and PersistentVolumeClaim**:
   To clean up the storage resources, delete the PersistentVolume and PersistentVolumeClaim:
   ```bash
   kubectl delete -f pvc.yaml
   ```

4. **Delete the PostgreSQL Secret**:
   To fully clean up, delete the PostgreSQL secret:
   ```bash
   kubectl delete -f postgres-secret.yaml
   ```

5. **Verify Deletion**:
   Confirm that all resources have been deleted:
   ```bash
   kubectl get all
   ```
   
