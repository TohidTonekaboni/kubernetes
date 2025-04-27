This README provides step-by-step instructions to interact with a Kubernetes deployment, execute commands inside containers, view application logs, and clean up resources.


Before proceeding, make sure the deployment defined in `deployment.yaml` is applied to your Kubernetes cluster. This file contains the configuration for deploying your application.

Run the following command to create the deployment:

```sh
kubectl apply -f deployment.yaml
```

Use the `kubectl exec` command to run an interactive shell inside the `web` container of the `hello-kube` deployment.

```sh
kubectl exec deploy/hello-kube -c web -it -- sh
```

This command:
- Targets the `hello-kube` deployment.
- Specifies the `web` container using `-c web`.
- Starts an interactive terminal session with `-it`.

While inside the container, you can check the container's IP address using the following command:

```sh
hostname -i
```

Still inside the container, you can test the application hosted on the container using `wget`. The command below retrieves the first 10 lines of the application's homepage:

```sh
wget -O - http://localhost | head -n 10
```

Exit the container shell

```sh
exit
```

View the logs for the `web` container of the `hello-kube` deployment using this command:

```sh
kubectl logs deploy/hello-kube -c web --tail=5
```

This command:
- Retrieves logs from the `web` container of the `hello-kube` deployment.
- Displays the last 5 log entries using `--tail=5`.

To remove the deployment and free up resources, run:

```sh
kubectl delete -f deployment.yaml
```
