# Elasticsearch on Kubernetes (EFK Stack Lecture)

In this lecture, we focus on deploying Elasticsearch as part of the EFK (Elasticsearch, Fluent Bit, Kibana) stack using Helm on a Kubernetes cluster.

## Steps

### 1. Add the Elasticsearch Helm Repository

First, add the official Elasticsearch Helm repository:

```bash
helm repo add elastic https://helm.elastic.co
helm repo update
```

### 2. Obtain and Customize the Default Values File

Fetch the default values file for the Elasticsearch chart and save it as `elastic.yaml`:

```bash
helm show values elastic/elasticsearch > elastic.yaml
```

In your `elastic.yaml` file, you can adjust various settings. For this lecture, we will set the following parameters:

- **Replicas**: Set the number of replicas to `1` for a simple deployment.
- **Storage Settings**: Use a local dynamic provisioner.

#### Example Changes in `elastic.yaml`

```yaml
# Set the number of Elasticsearch pods to 1
replicas: 1

# Configure the volumeClaimTemplate to use the local-path storage provisioner
volumeClaimTemplate:
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: 1Gi
  storageClassName: local-path

# Enable persistence with default labels for the StatefulSet
persistence:
  enabled: true
  labels:
    enabled: true
  annotations: {}

# Specify the Elasticsearch image
image: "elasticsearch"
```

### 3. Verify the StorageClass

Ensure that your local storage provisioner is installed and, for example, that the StorageClass `local-path` is available:

```bash
kubectl get sc
```

You should see an output similar to:

```
NAME         PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path   rancher.io/local-path   Delete          WaitForFirstConsumer   false                <age>
```

### 4. Create the Namespace for Logging

Create a dedicated namespace (e.g., `logging`) for deploying Elasticsearch and other EFK stack components:

```bash
kubectl create namespace logging
```

### 5. Deploy Elasticsearch Using Helm

Install Elasticsearch in the `logging` namespace using your customized `elastic.yaml` file:

```bash
helm install elasticsearch -f elastic.yaml elastic/elasticsearch -n logging
```

### 6. Verify the Deployment

After installation, you can verify that the Elasticsearch pods are running by executing:

```bash
kubectl get pods -n logging
```
