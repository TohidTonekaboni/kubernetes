This guide walks you through the process of deploying PostgreSQL in Kubernetes and using an init container to set up the database and tables before the main PostgreSQL container starts.

## Purpose of the Init Container

The **init container** in this deployment is used to execute SQL commands for initializing the PostgreSQL database. Specifically, it creates the `customers` database, sets up the `profiles` table, and inserts an initial record before the main PostgreSQL container starts. This ensures that the required database and table are available as soon as the database pod is ready.

## 1. Apply the PostgreSQL Deployment

To create the PostgreSQL deployment along with the init container and associated resources, run the following command:

```bash
kubectl apply -f postgres/
```

This will set up the PostgreSQL deployment, volumes, secrets, and init container.

## 2. Access the PostgreSQL Database

Once the deployment is complete and the pod is running, access the PostgreSQL instance with the following command:

```bash
kubectl exec -it deploy/postgres-deployment -c postgres -- psql -U postgres
```

This will open an interactive terminal to the PostgreSQL container.

## 3. Connect to the `customers` Database

Inside the `psql` shell, switch to the `customers` database:

```sql
\c customers
```

This connects to the `customers` database created by the init container.

## 4. Verify the Tables

To list all tables in the `customers` database, use the following command:

```sql
\dt
```

This will display the tables that were created by the init container, such as the `profiles` table.

## 5. Query the `profiles` Table

To see the data inserted into the `profiles` table by the init container, run this SQL query:

```sql
SELECT * FROM profiles;
```

This will return the data in the `profiles` table, which includes the record inserted by the init container (`Alireza`).

## 6. Delete the PostgreSQL Deployment

To remove the PostgreSQL deployment and all related resources, run the following command:

```bash
kubectl delete -f postgres/
```

This will delete the deployment, the secret, and the persistent volume claim associated with the PostgreSQL instance.
