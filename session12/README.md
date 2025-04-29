This README shows how namespaces and services work in Kubernetes, with a focus on inter-namespace communication.

---

## Key Concepts

### Default Namespace
- The default namespace is the namespace used when none is specified in Kubernetes commands. Pods, services, and other resources created without a namespace specification are placed here by default.

### kube-system Namespace
- The `kube-system` namespace contains critical system components and services for the Kubernetes cluster, such as the DNS service, kube-proxy, and more. These resources ensure the cluster operates smoothly.

### FQDN: Fully Qualified Domain Name
- Kubernetes services can be accessed using their Fully Qualified Domain Name (FQDN). This structure ensures that services are uniquely identifiable within the cluster:
  ```
  <service-name>.<namespace>.svc.cluster.local
  ```
  For example, a service named `random-number-api-svc` in the `prod` namespace has the FQDN:
  ```
  random-number-api-svc.prod.svc.cluster.local
  ```

---

## Commands and Configuration

### Listing Namespaces
- To view all namespaces in the cluster:
```bash
kubectl get namespaces
```

### Inspecting the kube-system Namespace
- View the pods and services running in the `kube-system` namespace:
```bash
kubectl get pods -n kube-system
kubectl get svc --namespace kube-system
```

---

## Creating and Managing a Namespace

### Apply and Delete Namespace from YAML
- Define the namespace in a YAML file (`ns.yaml`) and manage it using the following commands:
```bash
kubectl apply -f ns.yaml
kubectl delete -f ns.yaml
```

### Alternative Commands to Create/Delete a Namespace
- Directly create or delete namespaces using Kubernetes commands:
  - Create:
    ```bash
    kubectl create namespace prod
    ```
  - Delete:
    ```bash
    kubectl delete namespace prod
    ```

---

## Deploying the Random Number API and Client

### Apply Deployment and Service YAMLs
- Deploy the API and client resources into the `prod` namespace:
```bash
kubectl apply -f random-number-api-deployment.yaml -f random-number-api-svc.yaml -f random-number-client-deployment.yaml -f random-number-client-svc.yaml -n prod
```

### Verify Services in the `prod` Namespace
- Check the services deployed in the `prod` namespace:
```bash
kubectl get svc -n prod
```

---

## Inter-Namespace Communication

### Accessing Services in the `prod` Namespace from the Default Namespace

1. **Get Pod IP Address**:
   - Retrieve the IP address of the `random-number-api-deployment` pod:
     ```bash
     kubectl get pods -n prod -o wide
     ```

2. **Deploy a Pod in the Default Namespace**:
   - Use `nginx-pod.yaml` to create an NGINX pod in the default namespace:
     ```bash
     kubectl apply -f nginx-pod.yaml
     ```

3. **Go Inside the NGINX Pod**:
   - Access the shell of the NGINX pod:
     ```bash
     kubectl exec -it nginx-pod -c nginx -- sh
     ```

4. **Test API Access**:
   - Test communication using the Pod IP:
     ```bash
     curl <IP>:5000/generate
     ```
   - Test communication using the Service FQDN:
     ```bash
     curl random-number-api-svc.prod.svc.cluster.local/generate
     ```

---

## Clean Up Resources

- Remove all resources created during the lecture:
  ```bash
  kubectl delete -f random-number-api-deployment.yaml -f random-number-api-svc.yaml -f random-number-client-deployment.yaml -f random-number-client-svc.yaml -n prod
  ```

- Remove the NGINX pod:
  ```bash
  kubectl delete -f nginx-pod.yaml
  ```
