# Certificate-Based Authentication in Kubernetes

This document explains how to generate a client certificate for a new user (Sarah) and create a kubeconfig. This setup uses certificate-based authentication.

## Prerequisites

- **Access to the Control Plane:**  
  You must be a Kubernetes administrator with access to the control plane and the `/etc/kubernetes/pki/` directory.

- **CA Files:**  
  The Kubernetes cluster’s Certificate Authority files (`ca.crt` and `ca.key`) are created during cluster initialization (e.g., via kubeadm) and are located in `/etc/kubernetes/pki/`.

- **API Server Endpoint:**  
  In this example, the API server is running at `https://10.0.0.10:6443`.

## Steps

### 1. Verify CA Files

List the files in the PKI directory to confirm that the CA files exist:

```bash
ls -l /etc/kubernetes/pki/
```

You should see files such as `ca.crt` and `ca.key`.

---

### 2. Generate Sarah’s Private Key

Generate a 2048-bit RSA private key for Sarah:

```bash
openssl genrsa -out sarah.key 2048
```

**Explanation:**  
This command creates a new RSA private key stored in `sarah.key`. This key will be used to sign and prove Sarah’s identity.

---

### 3. Create a Certificate Signing Request (CSR)

Generate a CSR using Sarah’s private key:

```bash
openssl req -new -key sarah.key -out sarah.csr -subj "/CN=sarah/O=customer-developers"
```

**Explanation:**  
- **`/CN=sarah`**: Sets the Common Name (CN) to "sarah", which Kubernetes uses as the username.  
- **`/O=customer-developers`**: Optionally groups Sarah with other developers.  
This CSR will be signed by the CA to generate a certificate.

---

### 4. Sign the CSR with the Cluster’s CA

Sign Sarah’s CSR with the CA to generate her certificate:

```bash
sudo openssl x509 -req -in sarah.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out sarah.crt -days 365
```

**Explanation:**  
- **`-in sarah.csr`**: Specifies the CSR file.
- **`-CA /etc/kubernetes/pki/ca.crt` and `-CAkey /etc/kubernetes/pki/ca.key`**: Use the cluster’s CA certificate and private key to sign the CSR.
- **`-CAcreateserial`**: Automatically creates a serial number file if it does not exist.
- **`-out sarah.crt`**: Outputs the signed certificate.
- **`-days 365`**: Sets the validity of the certificate to 365 days.

---

### 5. Create a Kubeconfig File for Sarah

Use the following commands to create a kubeconfig file (named `sarah-kubeconfig.yaml`) for Sarah.

#### a. Set the Cluster Entry

```bash
kubectl config set-cluster kubernetes \
  --server=https://10.0.0.10:6443 \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true \
  --kubeconfig=sarah-kubeconfig.yaml
```

**Explanation:**  
This command adds a new cluster entry to the kubeconfig with the API server URL and the CA certificate embedded for secure communications.

#### b. Set the User Credentials

```bash
kubectl config set-credentials sarah \
  --client-certificate=sarah.crt \
  --client-key=sarah.key \
  --embed-certs=true \
  --kubeconfig=sarah-kubeconfig.yaml
```

**Explanation:**  
This command adds Sarah’s credentials (certificate and private key) to the kubeconfig, allowing her to authenticate with the cluster.

#### c. Create a Context for Sarah

```bash
kubectl config set-context sarah-context \
  --cluster=kubernetes \
  --user=sarah \
  --namespace=customer \
  --kubeconfig=sarah-kubeconfig.yaml
```

**Explanation:**  
This binds the cluster and user together into a context called `sarah-context` and sets the default namespace to `customer`.

#### d. Use Sarah’s Kubeconfig

Set the `KUBECONFIG` environment variable to use Sarah’s kubeconfig:

```bash
kubectl config use-context sarah-context --kubeconfig=sarah-kubeconfig.yaml
export KUBECONFIG=sarah-kubeconfig.yaml
```

**Explanation:**  
This ensures that subsequent `kubectl` commands use Sarah’s configuration rather than the default kubeconfig.

---

### 6. Verify Access and RBAC Restrictions

Try listing all pods across all namespaces:

```bash
kubectl get pods -A
```

You should receive an error similar to:

```
Error from server (Forbidden): pods is forbidden: User "sarah" cannot list resource "pods" in API group "" at the cluster scope
```
