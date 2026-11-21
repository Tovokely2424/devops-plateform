
# 11/10/2026 - Began CKAD content on KodeKloud


17/10/2026
# Resource request and Limit
- [x] Limit and resource request
```
- Manifest under spec.[containers]
- Default configuration can be done with [LimitRange](./limitrange.yaml) file
```

- [x] Resource Quotas
```
- Namespace level
- Default configuration of ns Level quota can be set like [quota](./resourcequota.yaml)
```

18/10/2026
# DaemonSet


# Static Pod 

## Commands used 
```
- [] ps -aux | grep kubelet
--config=/var/lib/kubelet/config.yaml
- [] cat /var/lib/kubelet/config.yaml | grep StaticPodPath
--

```

23/10/2026
# Admission controller
- [x] Validation and Mutating admission controller
- [x] Admission webhook server with labs

29/10/2026
- [x] Monitoring solution for Cluster
- [x] Metrics server deployment
```
kubectl top node
kubectl top pod
minikube addons enable metrics-server

```
- [x] Application lifecycle management

```
kubectl rollout status deploy/deploy-name
kubetcl rollout undo deploy/deploy-name
kubetcl rollout history deploy deploy-name
```
# Configure aplications with kubernetes 
- [x] Commands and arguments in Docker
```
Conflict with dev resolved
```

01/11/2026
# ConfigMap
```
env: 
    - name: APP_COLOR
      valueFrom:
        configMapKeyRef:
            name: app-config
            key: APP_COLOR
envFrom:
    - configMapRef:
        name: app-config
volumes:
    - name: app-config-volume
      configMap:
        name: app-config

```

# Secrets

```
env:
    - name: DB-SECRET
      valueFrom:
        secretKeyRef:
            name: app-secret
            key: DB-PASSWORD
envFrom:
    - secretRef:
        name: app-secret

volumes:
    - name: app-secret-volume
      secret:
        name: app-secret

```

# Dploying an maintenance of kubernetes

## Deploy kubernetes cluset the hard way services by services via systemd 

## Deploy kubernetes cluster multinode with kubeadm tool 
```text
- Verification of prerequisites of OS : swap, kernel module (overlay, br-netfilter), sysctl ipv4, ipv6 an port forward
- Installation of CRI, containerd
- configuration of containerd and config.toml, SystemdCgroup
- MAJ OF gpg key for the right version of kubeadm, kubectl, k8s
- apt update
- Installation of kubeadm, kubectl, kubelet
- kubeadm init with the right configuration like : 
  --apiserver-advertise-address=192.168.165.128 \
  --pod-network-cidr=10.244.0.0/16 ..
- Join worker nodes one by one using the right token generated kubeadm join 192.168.165.131:6443 
  --token 5jdf88.7t18cxx7dsuiomls \
  -discovery-token-ca-cert-hash xxx
- Deployment of the network module such as flanel, calico ... to finalise the coredns deployment and make the cluster ready
```

```