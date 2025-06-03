# Kubernetes Restricted User Setup (RBAC)

This guide explains how to restrict a user (Sarah) to the **customer** namespace with common developer permissions. It covers creating the namespace, applying the Role and RoleBinding, configuring the user’s kubeconfig, deploying a sample application, testing namespace restrictions, and finally cleaning up all the resources.

## Prerequisites

- TLS certificates for user authentication already embedded in `sarah-kubeconfig.yaml`.

## Setup Steps

1. **Create the Customer Namespace**

   Create the namespace that Sarah will be restricted to:

   ```sh
   kubectl create namespace customer
   ```

2. **Apply Developer Role and RoleBinding**

   Apply the Role (`developer-role.yaml`) and RoleBinding (`sarah-rolebinding.yaml`) that grant Sarah limited permissions in the **customer** namespace:

   ```sh
   kubectl apply -f developer-role.yaml
   kubectl apply -f sarah-rolebinding.yaml
   ```

3. **Configure Sarah's Kubeconfig**

   Set the `KUBECONFIG` environment variable to use Sarah’s kubeconfig file and switch to her context:

   ```sh
   export KUBECONFIG=$HOME/users/sarah/sarah-kubeconfig.yaml
   kubectl config use-context sarah-context --kubeconfig=$HOME/users/sarah/sarah-kubeconfig.yaml
   ```

4. **Deploy Busybox in the Customer Namespace**

   Deploy the Busybox application using the provided deployment file:

   ```sh
   kubectl apply -f busybox-deployment.yaml
   ```

## Testing Namespace Restrictions

To verify that Sarah’s permissions are limited to the **customer** namespace, try to deploy the Busybox application in the **default** namespace:

1. **Switch to the Default Namespace**

   Change the context’s namespace to **default**:

   ```sh
   kubectl config set-context sarah-context --namespace=default
   ```

2. **Attempt to Deploy in the Default Namespace**

   Run the deployment command again:

   ```sh
   kubectl apply -f busybox-deployment.yaml
   ```

   **Expected Output:**

   ```
   Error from server (Forbidden): error when retrieving current configuration of:
   Resource: "apps/v1, Resource=deployments", GroupVersionKind: "apps/v1, Kind=Deployment"
   Name: "busybox-deployment", Namespace: "default"
   from server for: "busybox-deployment.yaml": deployments.apps "busybox-deployment" is forbidden: User "sarah" cannot get resource "deployments" in API group "apps" in the namespace "default"
   ```

   This error confirms that Sarah’s permissions are restricted and she cannot deploy resources in the **default** namespace.

## Cleaning Up Resources

To remove all created resources and return to the initial state, execute the following commands:

1. **Delete the Busybox Deployment**

   ```sh
   kubectl delete -f busybox-deployment.yaml
   ```

2. **Delete the Developer Role and RoleBinding**

   ```sh
   kubectl delete -f developer-role.yaml
   kubectl delete -f sarah-rolebinding.yaml
   ```

3. **Delete the Customer Namespace**

   ```sh
   kubectl delete namespace customer
   ```

After these steps, all the changes made during the setup will be cleaned up.
