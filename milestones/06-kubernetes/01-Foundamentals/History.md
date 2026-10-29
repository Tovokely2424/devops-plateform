
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

