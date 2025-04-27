 <!-- pod: کوچکترین شی که کوبر میتونه اون رومدیریت کنه و باهاش کار کنه.  -->
<!-- پاد مجموعه ای از کانتینرهاست --> -->
<!-- میتونیم داخل پاد یه کانتیر داشته باشیم یا گروهی از کانتینرها -->
<!-- کوبرنتیز به شکل مستقیم کانتینرها رو مدیریت نمیکنه بلکه پادها رو مدیریت میکنه  -->
<!-- هر پاد وقتی ایجاد شود گوبر یک ایپی مجازی بهش اختصاص میده
پاد هات چون آیپی دارن میتونن تحت شبکه کامیونیکیت کنن. -->

<!-- کنتینرهای درون یک پاد میتونن از طریق پورتی که اکسپوز شدن میتونن ارتباط داشته باشن. -->

# The following command runs a pod named hello-kube with a single container in it. The restart policy for the pod is determined by the --restart flag. Legal values are ["Always", "OnFailure", "Never"]. The default value is "Always".
kubectl run hello-kube --image=aaghamohammadi/hello_kube:1.0.0 --restart=Never

# You can list all the pods in the current cluster using:
kubectl get pods
# The describe command shows details of a specific resource like a pod. It provides detailed information about a single pod, including its IP address and the node it is running on.
kubectl describe pod hello-kube

# To get the full JSON output of a pod, you can use the following command. This is useful for debugging and understanding the pod's configuration and status in detail.
kubectl get pod hello-kube -o json

# Kubectl can forward traffic from a node to a Pod, which is a quick way to communicate with a Pod from outside the cluster.
kubectl port-forward pod/hello-kube 8080:80

# Now, browse to localhost:8080 in your browser.
# To remove the pod and return your Kubernetes environment to a clean state, you can use the following command:
kubectl delete pod hello-kube