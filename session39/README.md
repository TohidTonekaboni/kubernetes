# Kubernetes Ingress TLS with Self-Signed Certificate

This guide demonstrates how to secure your Ingress with a self‑signed TLS certificate that covers two domains: `random.app.local` and `spacex.app.local`. It includes instructions for generating the certificate, creating a Kubernetes TLS secret, and configuring an Ingress resource to use that secret.

## 1. Generate the Self‑Signed Certificate

Run the following OpenSSL command to generate a self‑signed certificate valid for 365 days. The certificate uses `random.app.local` as the common name (CN) and includes both domains in the Subject Alternative Name (SAN) extension:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key \
  -out tls.crt \
  -subj "/CN=random.app.local" \
  -addext "subjectAltName = DNS:random.app.local,DNS:spacex.app.local"
```

This command creates two files:
- **tls.key:** The private key.
- **tls.crt:** The certificate.

## 2. Create the Kubernetes TLS Secret

Use the generated certificate and key to create a TLS secret in your cluster. Make sure to create the secret in the same namespace where your Ingress resource will reside:

```bash
kubectl create secret tls tls-secret --key=tls.key --cert=tls.crt
```

Verify the secret was created:

```bash
kubectl get secret tls-secret
```

## 3. Configure the Ingress

Below is an example Ingress manifest that uses the TLS secret for both domains:

```yaml
spec:
  tls:
  - hosts:
    - random.app.local
    - spacex.app.local
    secretName: tls-secret
```


- **TLS Section:**  
  The `tls` block specifies that traffic for both `random.app.local` and `spacex.app.local` should use the secret `tls-secret`.

