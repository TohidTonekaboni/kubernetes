A **controller** in Kubernetes is a resource responsible for managing other resources. Kubernetes has various controllers, and the primary one for managing Pods is the **Deployment**. For example, if a node goes offline and a Pod is lost, the Deployment controller automatically creates a replacement Pod on another node.


Use the following command to create a Deployment named `hello-kube` with the specified container image:

```sh
kubectl create deployment hello-kube --image=aaghamohammadi/hello_kube:1.0.0
```

List all deployments to ensure it was created successfully:

```sh
kubectl get deployments
```

Retrieve details about the specific Deployment:

```sh
kubectl get deploy hello-kube
```


When you create a Deployment, it manages the creation and lifecycle of the Pods. The Deployment also adds labels to the Pods it manages. You can view these labels using:

```sh
kubectl get deploy hello-kube -o jsonpath="{.spec.template.metadata.labels}"
```

For example, the Deployment might add a label `app=hello-kube` to its Pods. You can list Pods with this label:

```sh
kubectl get pods -l app=hello-kube
```


Using labels to establish relationships between resources is a core Kubernetes pattern. Controllers like Deployments use **label selectors** to identify and manage resources under their control.


You can forward a port from the Deployment to access one of its Pods:

```sh
kubectl port-forward deploy/hello-kube 8080:80
```

This command forwards traffic from `localhost:8080` to port `80` on the selected Pod.


To delete the Deployment and all its managed resources, use:

```sh
kubectl delete deploy hello-kube
```


While Pods run your application containers, they are designed to be **ephemeral**. This means they can be short-lived and may restart or get replaced over time. Using a higher-level resource like a Deployment ensures:

- Automated Pod management and scaling.
- Seamless updates and rollbacks.
- Resilience to node failures.

By leveraging Deployments, you can focus on managing your application at a higher abstraction level while Kubernetes takes care of the details.

