# Kibana on Kubernetes (EFK Stack Lecture)

In this lecture, we focus on deploying Kibana as part of the EFK (Elasticsearch, Fluent Bit, Kibana) stack using Helm on a Kubernetes cluster.

## Steps

### 1. Add the Elasticsearch Helm Repository (if not already added)

Add the official Elasticsearch Helm repository and update it:

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
```

### 2. Obtain and Customize the Default Values File

Fetch the default values file for the Kibana chart and save it as `kibana.yaml`:

```bash
helm show values elastic/kibana > kibana.yaml
```

You can edit `kibana.yaml` to adjust any settings as needed for your deployment.

### 3. Create the Namespace for Logging

If you haven't already created a dedicated namespace for the EFK stack, create one:

```bash
kubectl create namespace logging
```

### 4. Deploy Kibana Using Helm

Install Kibana in the `logging` namespace using your customized `kibana.yaml` file:

```bash
helm install kibana -f kibana.yaml elastic/kibana -n logging
```

### 5. Retrieve Deployment Credentials

After deployment, retrieve the necessary credentials:

#### Elasticsearch Master Password

Decode the Elasticsearch master password:

```bash
kubectl get secrets --namespace=logging elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
```

#### Kibana Token

Decode the Kibana token:

```bash
kubectl get secrets --namespace=logging kibana-kibana-es-token -ojsonpath='{.data.token}' | base64 -d
```

### 6. Verify the Deployment

Verify that Kibana (and Elasticsearch) are deployed correctly:

#### Check Pods

```bash
kubectl get pods -n logging
```

#### Check Services

List services in the `logging` namespace:

```bash
kubectl get svc -n logging
```

Example output:

```
NAME                            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
elasticsearch-master            ClusterIP   172.17.32.194   <none>        9200/TCP,9300/TCP   39h
elasticsearch-master-headless   ClusterIP   None            <none>        9200/TCP,9300/TCP   39h
kibana-kibana                   ClusterIP   172.17.8.229    <none>        5601/TCP            60s
```

### 7. Access Kibana via Port Forwarding

Forward the Kibana service port to your machine (e.g., 10.0.0.10) to access the Kibana UI:

```bash
kubectl port-forward -n logging svc/kibana-kibana 8080:5601 --address=10.0.0.10
```

Now, open your browser and navigate to [http://10.0.0.10:8080](http://10.0.0.10:8080) to access Kibana.
