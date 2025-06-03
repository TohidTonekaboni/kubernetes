# Random Number Application with Network Policies

This project deploys a simple Random Number API and a Random Number Client on Kubernetes, demonstrating how network policies can be used to restrict pod communication.

## Deployment

1. **Deploy the Application**

   Apply all manifests in the `random-number/` directory:

   ```bash
   kubectl apply -f random-number/
   ```

2. **Test Connectivity (Before Applying Network Policies)**

   - **Launch a Temporary Busybox Pod**

     Run an interactive busybox pod that will be automatically removed when you exit:

     ```bash
     kubectl run test-pod --rm -it --image=busybox --restart=Never -- bash
     ```

   - **Fetch a Random Number**

     Inside the busybox pod, run:

     ```bash
     wget http://random-number-api-svc/generate -O -
     ```

     You should see a random number returned, confirming that the API is reachable.

3. **Browse the Client Application**

   Open your web browser and navigate to the client application on port `8080`. You should see the client working and displaying random numbers.

## Applying Network Policies

To secure communication, we will create a network policy that allows only pods labeled `random-number-client` to interact with the Random Number API.

1. **Create the Network Policy**

   Create a file named `random-number-api-netpol.yaml` with the following content:

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: allow-random-number-client-communication
   spec:
     podSelector:
       matchLabels:
         app: random-number-api
     policyTypes:
     - Ingress
     - Egress
     ingress:
     - from:
       - podSelector:
           matchLabels:
             app: random-number-client
     egress:
     - to:
       - podSelector:
           matchLabels:
             app: random-number-client
   ```

2. **Apply the Network Policy**

   Apply the network policy using:

   ```bash
   kubectl apply -f random-number/random-number-api-netpol.yaml
   ```

3. **Test Connectivity (After Applying Network Policies)**

   - **Launch a Temporary Busybox Pod Again**

     ```bash
     kubectl run test-pod --rm -it --image=busybox --restart=Never -- sh
     ```

   - **Attempt to Fetch a Random Number**

     Inside the busybox pod, run:

     ```bash
     wget http://random-number-api-svc/generate -O -
     ```

     This time, you should not receive any response since the network policy blocks access from pods without the `random-number-client` label.

4. **Verify the Client Application**

   Even after applying the network policy, browse to the client application on port `8080`. It should still work correctly, as the client pods are allowed to communicate with the API.

## Cleanup

To remove all the deployed resources, run:

```bash
kubectl delete -f random-number/
```
