# Installing JupyterHub on Kubernetes using Helm

This guide provides the necessary commands to install JupyterHub on Kubernetes using Helm.

## Installation Steps

### 1. Create a Namespace
Create a dedicated namespace for JupyterHub:
```sh
kubectl create ns ml
```

### 2. Retrieve Default Helm Values
Download the default configuration file for JupyterHub:
```sh
helm show values bitnami/jupyterhub > jupyterhub.yaml
```

### 3. Modify LoadBalancer to ClusterIP
Edit `jupyterhub.yaml` to change the service type to `ClusterIP`:
```yaml
public:
  ## @param proxy.service.public.type Public service type
  ##
  type: ClusterIP
  # HTTP Port
  ## @param proxy.service.public.ports.http Public service HTTP port
  ##
  ports:
    http: 8080
```

### 4. Install JupyterHub
Deploy JupyterHub using the modified configuration file:
```sh
helm install jupyter bitnami/jupyterhub -f jupyterhub.yaml -n ml
```

## Accessing JupyterHub

### 1. Get the JupyterHub URL
Run the following command to access JupyterHub:
```sh
echo "JupyterHub URL: http://127.0.0.1:8080/"
kubectl port-forward --namespace ml svc/jupyter-jupyterhub-proxy-public 8080:8080
```

### 2. Login with Admin User
Retrieve the admin credentials to log in and create a notebook:
```sh
echo "Admin user: user"
echo "Password: $(kubectl get secret --namespace ml jupyter-jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 -d | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}')"
```

You can now log in to JupyterHub and start using it.

