# Basic Helm Commands Tutorial

This guide walks you through a series of Helm commands to help you get acquainted with managing charts and deployments in Kubernetes.

## 1. Check Helm Version and Environment

- **View Helm version:**

  ```bash
  helm version
  ```

  This command displays the current version of Helm installed on your system.

- **View Helm environment variables:**

  ```bash
  helm env
  ```

  This command prints the environment variables that Helm uses. These variables can help you troubleshoot configuration issues.

## 2. Manage Helm Repositories

- **Add the Bitnami repository:**

  ```bash
  helm repo add bitnami https://charts.bitnami.com/bitnami
  ```

  This adds the Bitnami charts repository to your Helm configuration, allowing you to access a variety of pre-packaged applications.

- **List all repositories:**

  ```bash
  helm repo list
  ```

  This command shows all Helm repositories you have configured, including the newly added Bitnami repo.

## 3. Search for Charts in Repositories

- **Search for charts from Bitnami:**

  ```bash
  helm search repo bitnami
  ```

  Lists all charts available in the Bitnami repository.

- **Search for an NGINX chart:**

  ```bash
  helm search repo nginx
  ```

  Finds charts related to NGINX from all repositories you've configured.

- **Search for a Redis chart:**

  ```bash
  helm search repo redis
  ```

  Looks for Redis-related charts in your repositories.

- **Search for all available versions of the Redis chart:**

  ```bash
  helm search repo redis --versions
  ```

  Displays every available version of the Redis chart, which is useful if you need a specific version for compatibility or testing.

## 4. Install a Chart

- **Install the NGINX chart from Bitnami:**

  ```bash
  helm install nginxapp bitnami/nginx
  ```

  This command deploys the NGINX application on your Kubernetes cluster and names the release `nginxapp`.

## 5. Verify the Deployment

Once the installation is complete, you can check the status of your deployment using `kubectl` commands:

- **Check deployments:**

  ```bash
  kubectl get deploy
  ```

- **Check services:**

  ```bash
  kubectl get svc
  ```

  These commands verify that your NGINX deployment and its corresponding service are running properly in your cluster.

## 6. Access the Application

- **Open your browser and navigate to (in case of Docker Desktop):**

  ```
  http://localhost
  ```

## 7. Uninstall the Chart

- **Remove the NGINX application:**

  ```bash
  helm uninstall nginxapp
  ```

  This command uninstalls the `nginxapp` release and cleans up the deployed resources.
