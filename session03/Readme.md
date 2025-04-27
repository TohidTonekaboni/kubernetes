Kubernetes manifests provide a comprehensive description of your application. These manifests are typically written in YAML format.

In the pod.yaml file, a single Pod is defined using the same container image from lecture 2.

To apply the configuration specified in the manifest to your cluster, use the apply command:

kubectl apply -f pod.yaml

Re-running this command will not alter the cluster because the resource is already created. This is the beauty of manifests: you define the desired state of your cluster, and Kubernetes works to achieve that state.

To delete a resource defined in a manifest, use the following command:

kubectl delete -f pod.yaml