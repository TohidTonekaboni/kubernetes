# Installing Grafana on Kubernetes

This guide walks through the process of installing Grafana on a Kubernetes cluster using the Bitnami Helm chart and configuring it to use the `local-path` storage class and connect to an existing Prometheus instance.

## Installation Steps

1.  Get the default values file from the Bitnami Grafana chart:
    ```bash
    helm show values bitnami/grafana > grafana.yaml
    ```

2.  Modify the `grafana.yaml` file. Key changes:

    *   **Persistence:** Ensure Grafana uses the existing storage class (e.g., "local-path").
      ```yaml
      persistence:
        enabled: true
        storageClass: "local-path"
        accessMode: ReadWriteOnce
        size: 1Gi # Adjust size if needed
      ```

    *   **(Optional) Pre-configure Prometheus Datasource:** Add Prometheus running in the same namespace.
      ```yaml
      datasources:
        secretDefinition:
          apiVersion: 1
          datasources:
          - name: Prometheus
            type: prometheus
            url: http://prometheus-server:9090
            access: proxy
            isDefault: true
      ```
    *   **(Optional) Set Admin Password:** You can set a specific admin password. If left empty, Helm will generate one.
        ```yaml
        admin:
          user: "admin"
          password: "your-secure-password" # Replace with a strong password or leave empty to auto-generate
        ```

3.  Install Grafana using Helm into the `monitoring` namespace:
    ```bash
    helm install grafana bitnami/grafana -f grafana.yaml -n monitoring
    ```

4.  Verify the installation:
    ```bash
    kubectl get pods -n monitoring
    ```
    You should see the `grafana-xxxx` pod in a `Running` state after a short while. Check logs if it gets stuck (`kubectl logs -n monitoring <grafana-pod-name>`).

## Accessing Grafana

1.  **Get the Admin Password (if not set manually):**
    ```bash
    kubectl get secret grafana-admin --namespace monitoring -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 -d
    ```
    The default username is `admin`.

2.  **Access the Grafana UI:**
    Use port-forwarding to access the Grafana dashboard from your local machine. Replace `10.0.0.10` with the IP address of the machine you want to access it from.
    ```bash
    kubectl port-forward --namespace monitoring svc/grafana 3000:3000 --address=10.0.0.10
    ```
    Access the Grafana UI in your browser at: http://10.0.0.10:3000

