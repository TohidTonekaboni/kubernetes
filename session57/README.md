# Fluent Bit on Kubernetes (EFK Stack Lecture)

In this lecture, we focus on deploying Fluent Bit as part of the EFK (Elasticsearch, Fluent Bit, Kibana) stack using Helm on a Kubernetes cluster.

## Steps

### 1. Add the Bitnami Helm Repository (if not already added)

Add the official Bitnami Helm repository and update it:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### 2. Obtain and Customize the Default Values File

Fetch the default values file for the Fluent Bit chart and save it as `fluentbit.yaml`:

```bash
helm show values bitnami/fluent-bit > fluentbit.yaml
```

Edit `fluentbit.yaml` to adjust the necessary settings for your deployment.

### 3. Create the Namespace for Logging

If you haven't already created a dedicated namespace for the EFK stack, create one:

```bash
kubectl create namespace logging
```

### 4. Enable DaemonSet in Fluent Bit Configuration

Modify `fluentbit.yaml` to enable DaemonSet:

```yaml
daemonset:
  enabled: true
```

### 5. Retrieve Elasticsearch Credentials

After deploying Elasticsearch, retrieve the necessary credentials.

#### Elasticsearch Master Password

```bash
kubectl get secrets --namespace=logging elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
```

Use the retrieved password in the Fluent Bit configuration.

### 6. Configure Fluent Bit Output

Modify the `outputs` section in `fluentbit.yaml`:

```yaml
  outputs: |
    [OUTPUT]
        Name                    es
        Match                   *
        Host                    elasticsearch-master.logging.svc.cluster.local
        Port                    9200
        HTTP_User               elastic
        HTTP_Passwd             lIknAQ8P9KAc1jEF  # Replace with your password
        Logstash_Format         On
        Logstash_Prefix         fluentbit
        Replace_Dots            On
        Suppress_Type_Name      On
        tls                     On
        tls.verify              Off
        Retry_Limit             False
```

### 7. Deploy Fluent Bit Using Helm

Install Fluent Bit in the `logging` namespace using your customized `fluentbit.yaml` file:

```bash
helm install fluent-bit -f fluentbit.yaml bitnami/fluent-bit -n logging
```

### 8. Verify the Deployment

#### Check Pods

```bash
kubectl get pods -n logging
```

#### Check Services

List services in the `logging` namespace:

```bash
kubectl get svc -n logging
```

### 9. Verify Elasticsearch Indices

Port-forward Elasticsearch:

```bash
kubectl -n logging port-forward elasticsearch-master-0 9200:9200
```

Then, verify the indices:

```bash
curl -u elastic:lIknAQ8P9KAc1jEF https://localhost:9200/_cat/indices?v --insecure
```

Replace `elastic` with the correct username and `lIknAQ8P9KAc1jEF` with the retrieved password.


