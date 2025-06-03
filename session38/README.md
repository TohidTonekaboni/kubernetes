# Deployment Instructions

## Apply Kubernetes Manifests
Run the following commands to deploy the applications:

```sh
kubectl apply -f random/
kubectl apply -f spacex/

kubectl apply -f ingress.yaml
```

## Local Development Setup
If you are using Kubernetes locally (e.g., with Minikube or kind), ensure that the following hostnames are added to your `/etc/hosts` file:

```sh
127.0.0.1 random.app.local
127.0.0.1 spacex.app.local
```

## Access the Applications
Once deployed, you can access the applications via the following URLs in your browser:

- **Random Service**: [http://random.app.local](http://random.app.local)
- **SpaceX Service**: [http://spacex.app.local](http://spacex.app.local)

Ensure that your Ingress controller is running and properly configured.

