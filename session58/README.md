# Installing Prometheus on Kubernetes

This guide walks through the process of installing Prometheus on a Kubernetes cluster using the Bitnami Helm chart.


## Installation Steps

1. Create a dedicated namespace for monitoring:
```bash
kubectl create ns monitoring
```

2. Get the default values file from the Bitnami Prometheus chart:
```bash
helm show values bitnami/prometheus > prometheus.yaml
```

3. Modify the prometheus.yaml file. The key changes needed are:

For Alertmanager service:
```yaml
alertmanager:
  service:
    type: ClusterIP  # Change from LoadBalancer to ClusterIP
```

For Prometheus server service:
```yaml
server:
  service:
    type: ClusterIP  # Change from LoadBalancer to ClusterIP
    ports:
      http: 9090
```

4. Install Prometheus using Helm:
```bash
helm install prometheus bitnami/prometheus -f prometheus.yaml -n monitoring
```

5. Verify the installation:
```bash
kubectl get pods -n monitoring
```
You should see pods for Prometheus server and Alertmanager running.

## Accessing Prometheus

### Prometheus Server UI
To access the Prometheus server interface:
```bash
kubectl port-forward --namespace monitoring svc/prometheus-server 9090:9090 --address=10.0.0.10
```
Access the Prometheus UI at: http://10.0.0.10:9090

### Alertmanager UI
To access the Alertmanager interface:
```bash
kubectl port-forward --namespace monitoring svc/prometheus-alertmanager 9093:80 --address=10.0.0.10
```
Access the Alertmanager UI at: http://10.0.0.10:9093

Note: Replace `10.0.0.10` with your specific IP address of the machine.

## Troubleshooting

If you encounter issues:

1. Check pod status:
```bash
kubectl get pods -n monitoring
```

2. Check pod logs:
```bash
kubectl logs -n monitoring <pod-name>
```

3. Verify services are running:
```bash
kubectl get svc -n monitoring
```

## Cleanup

To remove Prometheus from your cluster:
```bash
helm uninstall prometheus -n monitoring
kubectl delete ns monitoring
```

