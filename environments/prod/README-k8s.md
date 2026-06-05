# K8s-Installation
### Add master & worker node ip inside the /etc/hosts to resolve the dns
```bash
  sudo tee -a /etc/hosts << EOF
  <master-ip> master
  <worker1-ip> worker1
  <worker2-ip> worker2
  EOF
```

### Now run the kubedm init
```bash
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```
### After initated kubeadm it will print the worner node join token like this
 ```bash
    kubeadm join 10.0.4.37:6443 --token 35n00v.1l7yzey03ydgdh6w \
        --discovery-token-ca-cert-hash sha256:b56784cd5f807e8238d8ea4e6371311cb52323b95f75ccc6aa342aa76554bbb5
 ```

### To start using your cluster, you need to run the following as a regular user,execute this below commands on master node:
```bash
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  kubectl get nodes
    #Expected:
  output:- master   NotReady

```
Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf



# Install CNI
### Without CNI, workers will never become Ready.
I recommend Calico.
```bash
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.3/manifests/calico.yaml
```

### Print token list
```bash
  sudo kubeadm token list
```
