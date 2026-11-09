# 📑 Kubernetes Multi-Node Cluster Provisioning with Kubeadm

This repository documents the provisioning, configuration, and securing of an on-premises multi-node Kubernetes cluster deployed on Ubuntu Server using **Kubeadm**.

---

## 🏗️ 1. Cluster Architecture & Topology

The infrastructure consists of 3 dedicated virtual machines running Ubuntu Server, optimized for control plane isolation and worker node scalability.

### Node Directory

|      Hostname       |        Role           |  IP Address       |      OS / Minimum Specs         |
| --------------------| ----------------------| ----------------- | ------------------------------  |
| `master_node`       | Primary Control Plane | `192.168.165.129` | Ubuntu Server (2 vCPU, 4GB RAM) |
| `worker01_kubeadmn` | Worker Node 02        | `192.168.165.132` | Ubuntu Server (1 vCPU, 2GB RAM) |
| `worker02_kubeadm`  | Worker Node 03        | `192.168.165.133` | Ubuntu Server (1 vCPU, 2GB RAM) |

### Networking Specs
* **Container Runtime Interface (CRI):** `containerd`
* **Container Network Interface (CNI):** Calico / Cilium
* **Pod Network CIDR:** `10.244.0.0/16`

```bash
###### CNI #######
prasolonjatovo@masterkubeadm:~$ ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128 
ens33            UP             192.168.165.131/24 fe80::20c:29ff:feea:c33a/64 
vxlan.calico     UNKNOWN        10.244.168.128/32 fe80::6417:4eff:fea3:9e82/64 
calif8e95e2fa1f@if2 UP             fe80::ecee:eeff:feee:eeee/64 

########## ip route #########
prasolonjatovo@masterkubeadm:~$ ip route
default via 192.168.165.2 dev ens33 proto static 
10.244.66.128/26 via 192.168.165.133 dev ens33 proto 80 onlink 
blackhole 10.244.168.128/26 proto 80 
10.244.168.129 dev calif8e95e2fa1f scope link metric 1024 
10.244.197.192/26 via 192.168.165.132 dev ens33 proto 80 onlink 
192.168.165.0/24 dev ens33 proto kernel scope link src 192.168.165.131 
resolvectl status | head -20

##### Network config ####
prasolonjatovo@masterkubeadm:~$ sudo cat /etc/netplan/50-cloud-init.yaml 
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: false
      addresses:
        - 192.168.165.131/24
      routes:
        - to: default
          via: 192.168.165.2
      nameservers:
        addresses:
          - 192.168.165.2

sudo netplan try       #Test the connectivity after fixing the ip
sudo netplan apply     # Apply the configuration netplan

####   hosts config    ####
prasolonjatovo@masterkubeadm:~$ getent hosts
127.0.0.1       localhost
127.0.0.1       ip6-localhost ip6-loopback
192.168.165.131 masterkubeadm
192.168.165.132 node01kubeadm
192.168.165.133 node02kubeadm
```
---

## 🔒 2. Infrastructure Hardening & OS-Level Prerequisites

Before initializing the cluster, strict corporate security and systems policies were implemented across all nodes.

### SSH Security (Passwordless, Key-Only)
Password-based authentication was disabled to eliminate brute-force attack vectors. Access is explicitly restricted to verified SSH keys.

#### SSH configuration 
```bash
#### On the master node 
ssh-keygen -t ed_25519 -C "prasolonjatovo@masternode.local"
ssh-copy-id prasolonjatovo@192.168.165.132 #node01kubeadm
ssh-copy-id prasolonjatovo@192.168.165.133 #node02kubeadm

cat <<EOF | sudo tee -a ~/.ssh/config
Host    node02kubeadm
Hostname        192.168.165.131
Host    node01kubeadm
Hostname        192.168.165.132

Host *
        User    prasolonjatovo
EOF

####Check off ssh config
prasolonjatovo@masterkubeadm:~$ cat .ssh/config 

Host    node02kubeadm
Hostname        192.168.165.131
Host    node01kubeadm
Hostname        192.168.165.132

Host *
        User    prasolonjatovo
```

```text
# File: /etc/ssh/sshd_config
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
```

### Passwordless Sudo Management
To facilitate frictionless automated provisioning and administrative execution, specialized sudoers drops were generated for the deployment user without compromising systemic integrity:
```text
# File: /etc/sudoers.d/prasolonjatovo
prasolonjatovo ALL=(ALL) NOPASSWD: ALL
```

### System Configuration
* **Swap Management:** Permanently disabled (`swapoff -a` and updated `/etc/fstab`) to fulfill Kubeadm's scheduler requirements.

```bash
sudo swapoff -a
sudo sed -i '/\/swap.img/ s/^/#/' /etc/fstab
grep swap /etc/fstab
swapon --show
```

* **Kernel Modules:** Forwarding IPv4 and letting iptables see bridged traffic enabled via `br_netfilter` and `overlay`.
```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

#### Check 
prasolonjatovo@masterkubeadm:~$ lsmod | grep -E 'overlay|br_netfilter'
sysctl net.bridge.bridge-nf-call-iptables net.ipv4.ip_forward
br_netfilter           32768  0
bridge                425984  1 br_netfilter
overlay               212992  17
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
```

---

## 🛠️ 3. Provisioning & Deployment Steps

### Step 1: Install Container Runtime (`containerd`)
Configuring the underlying container ecosystem and optimizing systemd cgroup drivers.

```bash
sudo apt update
sudo apt install -y ca-certificates curl gpg
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y containerd.io
```

### Step 2: Install Kubernetes Packages
Pinning and installing standard binary toolsets across all target systems:
* `kubeadm` (Cluster bootstrapping tool)
* `kubelet` (Node-level execution agent)
* `kubectl` (Cluster management command-line utility)

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

### check 
kubeadm version -o short
kubectl version --client
systemctl status kubelet --no-pager
```

### Step 3: Initialize the Control Plane
Bootstrapping the master node utilizing a declarative configuration layout:
```bash
prasolonjatovo@masterkubeadm:~$ kubeadm version -o short
v1.35.10

cat <<'EOF' > ~/kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: InitConfigurationkubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.33.0/manifests/v3_projectcalico_org-v1beta1.yaml
localAPIEndpoint:
  advertiseAddress: 192.168.165.131
  bindPort: 6443
nodeRegistration:
  name: masterkubeadm
  criSocket: unix:///run/containerd/containerd.sock
---
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
kubernetesVersion: v1.35.10
clusterName: kubernetes
networking:
  podSubnet: 10.244.0.0/16
  serviceSubnet: 10.96.0.0/12
  dnsDomain: cluster.local
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
EOF


## check of the configuration file 
prasolonjatovo@masterkubeadm:~$ kubeadm config validate --config ~/kubeadm-config.yaml
ok


```

## Installation of control plane composant 
On this step will be the preflight, generation of certs and kubeconfig : (dmin.conf, controller-manager.conf, scheduler.conf et kubelet.conf dans /etc/kubernetes), installation of etcd and kube-apiserver /etc/kubernetes/manifests, upload config and mark controlplane . bootstrap tokne for thes workers to join the controlplane. Addons : coredns and kube-proxy

```bash
sudo kubeadm config images list --config ~/kubeadm-config.yaml
sudo kubeadm config images pull --config ~/kubeadm-config.yaml

sudo kubeadm init --config ~/kubeadm-config.yaml 2>&1 | tee ~/kubeadm-init.log

### Generation and copy of the config file
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

```

On this step, the control plane stay note ready because of the coredns in pending state . Raison : Due to the taints of the control plane, no nodes availables for the coredns to be scheduled. 

```bash
prasolonjatovo@masterkubeadm:~$ kubectl describe node masterkubeadm | grep -i taints
Taints:             node-role.kubernetes.io/control-plane:NoSchedule
prasolonjatovo@masterkubeadm:~$ kubectl describe pod coredns -n kube-system | grep Toleration
Tolerations:                 CriticalAddonsOnly op=Exists
Tolerations:                 CriticalAddonsOnly op=Exists
```

### Step 4: CNI Deployment
Applying the infrastructure's overlay network plugin to enable secure and stable pod-to-pod cross-node communication channels.

### Step 5: Joining Worker Nodes
Executing the cryptographically secured join payload generated during the control plane bootstrap across the remaining worker systems.

---

## 🔬 4. Cluster Validation & Proof of Concept

Post-deployment verification tasks executed to validate absolute functional stability.

```bash
kubectl get nodes -o wide
```

```text
NAME                STATUS   ROLES           AGE   VERSION   INTERNAL-IP       OS-IMAGE
master_node         Ready    control-plane   2h    v1.31.0   192.168.165.129   Ubuntu 22.04.4 LTS
worker              Ready    <none>          2h    v1.31.0   192.168.165.130   Ubuntu 22.04.4 LTS
worker01_kubeadmn   Ready    <none>          2h    v1.31.0   192.168.165.132   Ubuntu 22.04.4 LTS
```

### Smoke Test Deployments
* Verified active routing metrics by executing a multi-replica Nginx deployment.
* Validated operational cluster metrics, core DNS service discovery mechanisms (`coredns`), and intra-pod traffic policies.

---

## 🎯 5. Troubleshooting & Key Takeaways

* **SSH SSHD Configuration Hurdles:** Handled the transition from `ChallengeResponseAuthentication` to `KbdInteractiveAuthentication` on Ubuntu 22.04+ systems to guarantee ironclad security blocks against fallback authentication workflows.
* **Syntax Enforcement:** Solved standard syntax validation errors inside system drop-in configs (`/etc/sudoers.d/`) by enforcing strict formatting rules through `visudo`.

---

## 🚀 6. Future Enhancements & Automation Roadmap

* [ ] **Ansible Automation:** Package the entirety of the baseline OS setup, security configurations, and Kubeadm bootstrapping logic into automated Ansible Playbooks.
* [ ] **GitOps / Continuous Delivery:** Introduce ArgoCD into the deployment mix to oversee immutable platform software.
* [ ] **Telemetry Layer:** Inject a robust monitoring infrastructure utilizing Prometheus and Grafana dashboards for cluster observability.


## 🔧 5. Essential Commands Reference

Below is a curated list of commands utilized daily during the cluster's lifecycle, provisioning, and maintenance phases.
### Linux
```bash
lsb_release -a                            #Version of ubuntu release
uname -r                                  #kernel version
swapon --show                             #show the swapon state (kubernetes recommand to deactivate swap
sudo cat /etc/netplan/50-cloud-init.yaml  #network config of the VM
sudo ufw status                           #Status of firewall
ssh-keygen -t ed25519                     # Generate the ssh key on the master for other nodes
ssh-copy-id user@node01                   # ssh config already done
hostnamectl --static                      # hostname
ip -br link                               #network
sudo cat /sys/class/dmi/id/product_uuid   #product_uuid
cat /etc/machine-id                       #mac adress

```

### Network's VM configuration 
130 for master, 131 and 132 for workers
```bash

network:
  version: 2
  ethernets:
    ens33:
      dhcp4: false
      addresses:
        - 192.168.165.131/24
      routes:
        - to: default
          via: 192.168.165.2
      nameservers:
        addresses:
          - 192.168.165.2

```

## Check of version 
```bash
kubeadm version -o short
kubectl version --client
systemctl status kubelet --no-pager
```
## Package install

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
```


### Cluster Management (Control Plane)
The content of the kubeadm-config.yaml is here 
```bash
kubeadm config validate --config ~/kubeadm-config.yaml

sudo kubeadm config images list --config ~/kubeadm-config.yaml
sudo kubeadm config images pull --config ~/kubeadm-config.yaml

# Initialize the cluster control plane
sudo kubeadm init --config ~/kubeadm-config.yaml 2>&1 | tee ~/kubeadm-init.log

# Generate a new join token for worker nodes (if expired)
kubeadm token create --print-join-command

# Check cluster component health status
kubectl get componentstatuses
```

### Node Observability & Inspection
```bash
# List all nodes with detailed configuration specs
kubectl get nodes -o wide

# Check the status of all system pods (CoreDNS, kube-proxy, etc.)
kubectl get pods -n kube-system

# Troubleshoot a failing node or view detailed system events
kubectl describe node <node-name>
```

### System & SSH Security Verification
```bash
# Test SSH daemon syntax configuration after security hardening
sudo sshd -t

# Apply customized and validated sudoers policies safely
sudo visudo -f /etc/sudoers.d/prasolonjatovo

# Verify current network address assignment behavior (DHCP vs. Static)
cat /etc/netplan/*.yaml
```

---

## 🔬 6. Challenges Encountered & Troubleshooting (Lessons Learned)

Building an infrastructure from scratch always uncovers edge cases. Here are the main engineering hurdles solved during this deployment:

### Challenge 1: `visudo` Syntax Errors & Terminal Lockouts
* **Issue:** Direct manipulation or syntax typing mistakes in `/etc/sudoers.d/` caused `visudo` to prompt `What's next?` errors, risking a total lockout from administrative root privileges.
* **Solution:** Enforced formatting validation using `NOPASSWD: ALL` (with colon punctuation instead of `=` equals signs). Used `sudo visudo -f` to guarantee safety checks before saving any workspace changes to the file system.

### Challenge 2: SSH Loophole via Interactive Probing
* **Issue:** Disabling standard `PasswordAuthentication` was not enough. The OpenSSH engine defaulted to keyboard-interactive prompts, presenting an unexpected password login prompt to potential attackers.
* **Solution:** Explicitly injected `KbdInteractiveAuthentication no` and `ChallengeResponseAuthentication no` at the bottom of the SSH server configuration (`sshd_config`) to close down fallback interactive terminal dialogs entirely.

### Challenge 3: Cluster Instability Threat from Dynamic IP Allocations
* **Issue:** Relying on default DHCP network setups on Ubuntu Server means nodes might receive new IP addresses after a system reboot. This would completely break Kubeadm’s control plane API routing metrics.
* **Solution:** Audited network infrastructure files inside `/etc/netplan/` to identify DHCP flags (`dhcp4: true`). Standardized network configurations across all virtual machines to utilize fixed, immutable static IP bindings.

