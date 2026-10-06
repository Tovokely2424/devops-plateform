## E0820 14:42:37.842990 10365 memcache.go:265 "Unhandled Error" err="couldn't get current server API group list: Get

# Context
Laptop host was out of charge and shuting down unexpectedly


# Command used 
microk8s status
sudo snap services microk8s
sudo ss -lntp | grep 16443 => Connection refused
ps aux | grep -E 'kubelite|kube-apiserver' | grep -v grep

curl -k https://127.0.0.1:16443/version
curl -k -v https://127.0.0.1:16443/healthz
pgrep -af kubelite
sudo systemctl status snap.microk8s.daemon-kubelite --no-pager
sudo cat /var/snap/microk8s/current/args/kube-apiserver
sudo ls -lah /var/snap/microk8s/current/args/

ps aux | grep -E 'kine|dqlite' | grep -v grep
sudo ss -lxnp | grep kine

sudo find /var/snap/microk8s/9072/var/kubernetes/backend -maxdepth 2 -name 'cluster.yaml' -ls
sudo file /var/snap/microk8s/9072/var/kubernetes/backend/cluster.yaml
sudo ls -lah /var/snap/microk8s/9072/var/kubernetes/backend/cluster.yaml

sudo xxd -l 64 /var/snap/microk8s/9072/var/kubernetes/backend/cluster.yaml
sudo head -20 /var/snap/microk8s/9072/var/kubernetes/backend/cluster.yaml
sudo iconv -f UTF-8 -t UTF-8 /var/snap/microk8s/9072/var/kubernetes/backend/cluster.yaml >/dev/null #integrity of file
sudo wc -c /var/snap/microk8s/9072/var/kubernetes/backend/cluster.yaml

#Backup 
sudo tar -czf ~/microk8s-dqlite-backup-20260820.tar.gz \
  -C /var/snap/microk8s/9072/var/kubernetes backend
ls -lh ~/microk8s-dqlite-backup-20260820.tar.gz #integrity and check
sudo tar -tzf ~/microk8s-dqlite-backup-20260820.tar.gz | head -30

# Log Analysis
sudo journalctl -u snap.microk8s.daemon-kubelite --since "20 minutes ago" --no-pager | grep -Ei 'error|fail|fatal|panic|apiserver|dqlite|certificate|listen|bind'
sudo systemctl status snap.microk8s.daemon-kubelite --no-pager
sudo journalctl -u snap.microk8s.daemon-k8s-dqlite --since "15 minutes ago" --no-pager | grep -Ei 'error|fail|fatal|panic|kine|leader|timeout|database'

# Try to resolve

sudo tee /var/snap/microk8s/9072/var/kubernetes/backend/cluster.yaml > /dev/null <<'EOF'
- ID: 3297041220608546238
  Address: 127.0.0.1:19001
  Role: 0
EOF

sudo cat /var/snap/microk8s/9072/var/kubernetes/backend/cluster.yaml
sudo snap restart microk8s.daemon-k8s-dqlite
sudo snap services microk8s | grep dqlite
sudo ls -l /var/snap/microk8s/9072/var/kubernetes/backend/kine.sock 

## Route Causes
After the server shuting down unexpectedly, the cluster.yaml file was corrupted. Right value found on backup restored . Reboot of k8s-dqlite and the process kine.sock was laucnhed automatically. All thing goes well. 