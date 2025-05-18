This document provides a step-by-step guide on how to use Helm to deploy, upgrade, and uninstall an Nginx application from the Bitnami chart repository. We will also use `kubectl` to inspect the resources created during the process.

## 1. Inspecting the Default Values

Before installing the chart, it is useful to review the configurable values. You can display the default values by running:

```bash
helm show values bitnami/nginx
```

### Excerpt from the Output

```yaml
service:
  ## @param service.type Service type
  ##
  type: LoadBalancer
  ## @param service.ports.http Service HTTP port
  ## @param service.ports.https Service HTTPS port
  ##
  ports:
    http: 80
    https: 443
```

In this excerpt:
- `service.type` is set to `LoadBalancer`.
- The default HTTP port is `80` and HTTPS port is `443`.

## 2. Installing the Nginx Application

Install the Nginx application with a custom HTTP port by overriding the default value:

```bash
helm install nginxapp bitnami/nginx --set service.ports.http=8080
```

This command creates a new Helm release named `nginxapp` with the HTTP service port set to `8080`.

## 3. Verifying the Deployment

After installation, use `kubectl` to verify that the deployment and service were created correctly:

```bash
kubectl get deploy
kubectl get svc
```

You should see output listing your deployments and services. For example, the service should show port `8080` mapped.

### Accessing the Application

Assuming that your Kubernetes cluster is configured to expose the service on your localhost (for example, using a port-forward or a local load balancer), you can access the application via your web browser:

```
http://localhost:8080/
```

## 4. Listing Helm Releases

You can list the installed Helm releases with:

```bash
helm ls
```

This will show all current Helm releases including the `nginxapp` release.

## 5. Upgrading the Nginx Application

To update the application (for example, changing the HTTP port to `8089`), use the `helm upgrade` command:

```bash
helm upgrade nginxapp bitnami/nginx --set service.ports.http=8089
```

After the upgrade, verify the changes:

```bash
kubectl get svc
helm ls
```

### Accessing the Upgraded Application

Now, access the application using the new port:

```
http://localhost:8089/
```

## 6. Uninstalling the Nginx Application

When you are finished with the demo, clean up the resources by uninstalling the release:

```bash
helm uninstall nginxapp
```

This command removes the Helm release along with all associated Kubernetes resources.
