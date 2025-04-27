# Accessing `hello-kube-1` from `hello-kube-2`

Kubernetes creates a virtual network that spans the entire cluster, enabling pods to communicate with each other via their IP addresses, even if they are running on different nodes. However, using pod IPs directly for communication is not ideal because pod IPs are ephemeral; they change whenever a pod is replaced.

To address this, Kubernetes provides a mechanism called **Services**, which abstracts pod networking and ensures stable communication. Services act as virtual IPs for a set of pods, and Kubernetes automatically updates the Service to point to replacement pods as needed. Additionally, Kubernetes includes an internal DNS server that maps Service names to their IP addresses, allowing pods to communicate using human-readable domain names instead of dynamic IP addresses.

Services are highly flexible:
- They enable routing traffic between pods.
- They expose pods to the external world.
- They allow pods to connect to external systems.

When you create a Service, it is registered with the internal DNS server, providing a static IP for its lifetime. Any network request to the Service's IP is routed to the corresponding pods automatically.

---

## Steps to Test Communication Between `hello-kube-1` and `hello-kube-2`

### 1. Deploy `hello-kube-1` and `hello-kube-2`
Apply the deployment manifests:

```sh
kubectl apply -f hello-kube-1.yaml -f hello-kube-2.yaml
```

### 2. Access `hello-kube-1` Using Its Pod IP
1. Get the IP address of the pod running `hello-kube-1`:

   ```sh
   kubectl get pod -l app=hello-kube-1 -o wide
   ```

2. Open a shell inside the `hello-kube-2` pod:

   ```sh
   kubectl exec -it deploy/hello-kube-2 -c web -- sh
   ```

3. Inside the shell, use the `curl` command to access `hello-kube-1` via its pod IP address:

   ```sh
   curl <IP address of hello-kube-1>:80
   ```

4. Exit the shell after verifying connectivity:

   ```sh
   exit
   ```

### 3. Create a Service for `hello-kube-1`
To enable stable communication, create a Service for `hello-kube-1`:

```sh
kubectl apply -f service.yaml
```

Verify the Service creation and note its name:

```sh
kubectl get svc hello-kube-1-svc
```

### 4. Access `hello-kube-1` Using the Service Name
1. Open a shell inside the `hello-kube-2` pod again:

   ```sh
   kubectl exec -it deploy/hello-kube-2 -c web -- sh
   ```

2. This time, use the DNS name of the Service to access `hello-kube-1`:

   ```sh
   curl hello-kube-1-svc:80
   ```

By using the Service name, you avoid issues with dynamic pod IPs and ensure reliable communication between `hello-kube-2` and `hello-kube-1`.

## Cleanup
To clean up the resources created in this guide, delete the deployments and the service:

```sh
kubectl delete -f hello-kube-1.yaml -f hello-kube-2.yaml -f service.yaml
```