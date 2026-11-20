# OOMKilled Troubleshooting – Kubernetes

**Category:** Kubernetes / Linux / Container Runtime / Resource Management  
**Environment:** kubeadm cluster – Ubuntu 24.04 / containerd / Kubernetes  
**Incident Date:** November 20, 2026  
**Affected Workload:** MySQL Deployment  
**Namespace:** `demo1`  
**Affected Node:** `node01kubeadm` (`192.168.165.132`)

---

## 1. Incident Description

While monitoring my Kubernetes cluster, I noticed that the MySQL container had restarted three times.

The Pod was currently running, but its restart count indicated that the container had experienced multiple unexpected terminations.

**Initial observation:**

```bash
prasolonjatovo@masterkubeadm:~$ kubectl get pods -o wide
```

```text
NAME                                   READY   STATUS    RESTARTS       AGE     IP               NODE
mysql-86b756bfbf-6q6fh                 1/1     Running   3 (16m ago)   2d18h   10.244.197.211   node01kubeadm
nginx-747b9656b-djr7w                  1/1     Running   1 (17h ago)   2d17h   10.244.66.188    node02kubeadm
vengineers-backend-5f5694f69-bc8x8     1/1     Running   1 (17h ago)   2d18h   10.244.197.208   node01kubeadm
vengineers-frontend-7fcc9bddc7-gl55b   1/1     Running   1 (17h ago)   41h     10.244.197.209   node01kubeadm
```

**Initial hypothesis:** The MySQL container was crashing or being terminated unexpectedly.

---

## 2. Initial Investigation

### Step 1 – Inspect container logs

I checked the current container logs:

```bash
prasolonjatovo@masterkubeadm:~$ kubectl logs mysql-86b756bfbf-6q6fh -n demo1
2026-11-20T08:56:49.973038Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
```

The logs showed that MySQL started successfully:

```text
[System] /usr/sbin/mysqld: ready for connections.
```

No application-level error was reported.

I also checked the logs from the previous container instance:

```bash
prasolonjatovo@masterkubeadm:~$ kubectl logs mysql-86b756bfbf-6q6fh -n demo1 --previous
2026-11-20T08:01:14.432970Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '26.10.0'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
```

The previous instance also showed a successful startup, without an explicit shutdown message.

**Observation:** Application logs alone were insufficient to identify the root cause.

### Step 2 – Inspect Pod details

I used:

```bash
prasolonjatovo@masterkubeadm:~$ kubectl describe pod mysql-86b756bfbf-6q6fh -n demo1
Name:             mysql-86b756bfbf-6q6fh
Namespace:        demo1
IPs:
  IP:           10.244.197.211
Controlled By:  ReplicaSet/mysql-86b756bfbf
Containers:
  mysql:
    Last State:     Terminated
      Reason:       OOMKilled
      Exit Code:    137
      Started:      Fri, 20 Nov 2026 08:01:06 +0000
      Finished:     Fri, 20 Nov 2026 08:56:38 +0000
```

Relevant output:

```text
State:          Running
  Started:      Fri, 20 Nov 2026 08:56:43 +0000

Last State:     Terminated
  Reason:       OOMKilled
  Exit Code:    137

Restart Count: 3

QoS Class:      BestEffort
```

**Important findings:**

- `OOMKilled`: The container was terminated due to an out-of-memory event.
- `Exit Code 137`: The process received SIGKILL (signal 9).
- `Restart Count 3`: Kubernetes restarted the container three times.
- `BestEffort`: The Pod had no CPU or memory requests or limits configured.

At this point, memory pressure became the primary investigation path.

---

## 3. Inspect Kubernetes Resource Configuration

I checked the MySQL Deployment configuration:

```bash
prasolonjatovo@masterkubeadm:~$ kubectl get deployment mysql -n demo1 -o yaml
```

To quickly identify resource configuration:

```bash
prasolonjatovo@masterkubeadm:~$ kubectl get deployment mysql -n demo1 -o yaml | grep -E 'requests:|limits:|memory:|cpu:'
```

No resource configuration was found.

**Finding:** The MySQL container had neither resource requests nor resource limits.

Consequently, Kubernetes assigned the Pod the `BestEffort` QoS class.

---

## 4. Investigate the Linux Kernel

Since application logs did not reveal the termination reason, I moved to the underlying Kubernetes worker node.

Node:

```text
node01kubeadm
192.168.165.132
```

I inspected the Linux kernel logs:

```bash
prasolonjatovo@node01kubeadm:~$ sudo journalctl -k --since "2026-11-20 07:00:00" --until "2026-11-20 09:00:00" | grep -i -E 'oom|killed process|out of memory'
Nov 20 07:41:35 node01kubeadm kernel: kworker/1:1 invoked oom-killer: gfp_mask=0xdc0(GFP_KERNEL|__GFP_ZERO), order=0, oom_score_adj=0
Nov 20 07:41:35 node01kubeadm kernel:  oom_kill_process+0x118/0x280
Nov 20 07:41:35 node01kubeadm kernel: oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod31d89919_ab58_4477_b7ba_f3121d7d37db.slice/cri-containerd-910f763bcc5eb8f1c3780d9bfbf66531f533246e972f8e5d39d9912b27edf0b6.scope,task=mysqld,pid=2970,uid=999
```

**Critical finding – First OOM event:**

```text
Nov 20 07:41:35 node01kubeadm kernel:
oom-kill:constraint=CONSTRAINT_NONE,
global_oom,
task_memcg=/kubepods.slice/kubepods-besteffort.slice/...

task=mysqld,pid=2970,uid=999
```

The kernel explicitly reported:

```text
Out of memory: Killed process 2970 (mysqld)
total-vm:1868464kB,
anon-rss:451844kB,
oom_score_adj:1000
```

**Second OOM event:**

```text
Nov 20 08:56:38 node01kubeadm kernel:
oom-kill:constraint=CONSTRAINT_NONE,
global_oom,
task_memcg=/kubepods.slice/kubepods-besteffort.slice/...

task=mysqld,pid=142339,uid=999
```

The kernel confirmed:

```text
Out of memory: Killed process 142339 (mysqld)
total-vm:1867440kB,
anon-rss:437560kB,
oom_score_adj:1000
```

### Understanding the kernel output

| Parameter | Meaning |
|---|---|
| `global_oom` | The kernel encountered a system-wide out-of-memory condition. |
| `task=mysqld` | MySQL was the process selected by the OOM Killer. |
| `total-vm` | Virtual memory allocated or mapped by the process. |
| `anon-rss` | Resident anonymous physical memory used by the process. |
| `oom_score_adj=1000` | Maximum OOM score adjustment, making the process a highly preferred victim. |
| `kubepods-besteffort.slice` | The process belonged to a Kubernetes BestEffort Pod. |

**Conclusion:** This was a node-level global OOM event, not simply a MySQL application crash.

---

## 5. Check Node Memory Availability

I checked the memory status directly on the affected node:

```bash
prasolonjatovo@node01kubeadm:~$ free -m
               total        used        free      shared  buff/cache   available
Mem:            1919        1578          87           5         409         340
Swap:              0           0           0free -m
```

Output:

```text
               total        used        free      shared  buff/cache   available
Mem:            1919        1574         120           5         381         345
Swap:              0           0           0
```

The node had approximately:

- 1.9 GiB total RAM.
- 1.5 GiB used memory.
- 345 MiB available memory.
- No swap configured.

**Observation:** The worker node had limited memory capacity, and multiple workloads were running simultaneously.

Note: These values represent memory usage at the time of investigation, not necessarily the exact memory state during the OOM events.

---

## 6. Root Cause Analysis

After investigating both Kubernetes and Linux kernel logs, I identified the following contributing factors:

1. **Limited node resources:** The affected worker node had approximately 2 GiB of RAM.
2. **No memory requests:** The MySQL Pod had no guaranteed memory reservation.
3. **No memory limits:** The container had no configured memory ceiling.
4. **BestEffort QoS:** The Pod received the lowest Kubernetes QoS protection.
5. **System-wide memory exhaustion:** The Linux kernel triggered the global OOM Killer and selected the MySQL process.

### Root Cause

The MySQL container was repeatedly terminated by the Linux kernel's Out-Of-Memory Killer during node-level memory exhaustion.

Its `BestEffort` QoS classification and high OOM score made it a vulnerable candidate for termination.

Kubernetes subsequently restarted the container according to the Pod's restart policy.

---

## 7. Lessons Learned

This incident highlighted several important Kubernetes and Linux concepts:

- Kubernetes does not directly kill containers simply because a Pod has no resource requests.
- Resource requests influence scheduling and QoS classification.
- Resource limits establish enforceable resource boundaries.
- `BestEffort` Pods are more vulnerable during memory pressure.
- `OOMKilled` and exit code `137` are important troubleshooting indicators.
- Container logs may not contain the actual termination reason when a process receives SIGKILL.
- Linux kernel logs are essential when investigating container termination and node-level resource exhaustion.
- A running Pod does not necessarily mean that the application has been stable.

### Useful troubleshooting commands

```bash
# Check Pod status and restart count
kubectl get pods -A -o wide

# Inspect container termination reason
kubectl describe pod <pod-name> -n <namespace>

# Inspect current container logs
kubectl logs <pod-name> -n <namespace>

# Inspect previous container logs
kubectl logs <pod-name> -n <namespace> --previous

# Inspect Deployment resource configuration
kubectl get deployment <deployment-name> -n <namespace> -o yaml

# Check node memory
free -m

# Investigate Linux kernel OOM events
sudo journalctl -k | grep -i -E 'oom|killed process|out of memory'

# Inspect node conditions and allocated resources
kubectl describe node <node-name>
```

---

## 8. Planned Remediation

The next step is to configure appropriate resource requests and limits for MySQL, based on actual workload requirements and available node capacity.

Example configuration (illustrative values):

```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "768Mi"
    cpu: "500m"
```

This configuration would change the Pod QoS class from `BestEffort` to `Burstable`.

Additional improvements:

- Monitor node and Pod memory consumption.
- Review MySQL memory configuration, including InnoDB buffer pool size and maximum connections.
- Evaluate whether the worker node needs additional RAM.
- Deploy Metrics Server for real-time resource metrics.
- Consider Prometheus and Grafana for historical monitoring and alerting.

**Remediation status:** Root cause identified. Resource optimization and monitoring improvements planned.