## Check linux ip forwards disbale or enabled if disabled it will show 0 , if it is enabled it will show 1  , Apply on master and worker nodes

```bash
    cat /proc/sys/net/ipv4/ip_forward
    If it returns 0, enable it:

    sudo sysctl -w net.ipv4.ip_forward=1
    cat /proc/sys/net/ipv4/ip_forward
    If it returns 1, it is enabled.
```

### To make it persistent across reboots on master and worker nodes:
```bash
   echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
   sudo sysctl --system 
```

# Now run the kubedm init
```bash
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16

    #After initated it will print output like this

    To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.4.37:6443 --token 35n00v.1l7yzey03ydgdh6w \
        --discovery-token-ca-cert-hash sha256:b56784cd5f807e8238d8ea4e6371311cb52323b95f75ccc6aa342aa76554bbb5
```
## Execute this below command on master node
```bash
    mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
```bash
    kubectl get nodes
    #Expected:
    output:- master   NotReady
```

# Install CNI
### Without CNI, workers will never become Ready.
I recommend Calico.
```bash
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.3/manifests/calico.yaml
```

