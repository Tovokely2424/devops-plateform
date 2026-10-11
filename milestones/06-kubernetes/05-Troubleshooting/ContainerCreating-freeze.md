## Deploy
kubectl describe deploy nginx
## Pod level
--> kubectl describe pod nginx-xxx-xxx
--> kubectl describe pod nginx-5cdc8f5d5f-4jf25 | tail -30
--> kubectl get events -n demo1 --sort-by='.lastTimestamp'
--> kubectl get configmap nginx-config -n demo1 -o yaml
--> kubectl get pod nginx-5cdc8f5d5f-4jf25 -o yaml

## What I learned from it
```
Deployment
   ↓
ReplicaSet ✅
   ↓
Pod created ✅
   ↓
ContainerCreating ❌
   ↓
No application logs yet
   ↓
describe POD + Events
   ↓
ConfigMap / volume configuration
   ↓
Fix manifest
```