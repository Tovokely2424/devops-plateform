kubectl get configmap
kubectl get cm
kubectl create configmap my-configmap --from-literal=APP_ENV=production --from-literal=LOG_LEVEL=info
kubectl get configmap my-configmap -o yaml
kubectl delete cm my-configmap

kubectl create configmap nginx-config --from-file=nginx.conf


### 1. create a sample nginx conf
cat nginx.conf

```
events {}

http {
    server {
        listen 80;
        location / {
            return 200 'Hello from custom Nginx configuration!';
            add_header Content-Type text/plain;
        }
    }
}
```

### 1. push the file as configmap

kubectl create configmap nginx-config --from-file=nginx.conf

or 

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
    events {}

    http {
        server {
            listen 80;
            location / {
                return 200 'Hello from custom Nginx configuration!';
                add_header Content-Type text/plain;
            }
        }
    }
EOF
```


### create a pod and mount the configmap

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
    - name: nginx
      image: nginx:latest
      volumeMounts:
        - name: nginx-config-volume
          mountPath: /etc/nginx/nginx.conf    # Overwrite the default nginx.conf
          subPath: nginx.conf                 # Specify the key
      ports:
        - containerPort: 80
  volumes:
    - name: nginx-config-volume
      configMap:
        name: nginx-config	# name of the confgmap
        items:
          - key: nginx.conf 	# the key to be used
            path: nginx.conf	# the path
```

### 2. Create a config map with all env variables

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-env-config
data:
  SERVER_NAME: "www.example.com"
  LISTEN_PORT: "80"
  ROOT_LOCATION: "/usr/share/nginx/html"
EOF
```

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-content
data:
  index_content: "Hello Xavki !!"
EOF
```


### 2. Create a second variable with nginx.conf

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-template-config
data:
  nginx.conf.template: |
    events {}

    http {
        server {
            listen \${LISTEN_PORT};
            server_name \${SERVER_NAME};

            location / {
                root \${ROOT_LOCATION};
                index index.html index.htm;
            }
        }
    }
EOF
```

### 2. Create the pod with each volume (tips)

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-env-pod
spec:
  containers:
    - name: nginx
      image: nginx:latest
      envFrom:
        - configMapRef:
            name: nginx-env-config
      volumeMounts:
        - name: nginx-config-volume
          mountPath: /etc/nginx/templates/nginx.conf.template
          subPath: nginx.conf.template
      command: ["/bin/sh"]
      env:
        - name: INDEX_CONTENT
          valueFrom:
            configMapKeyRef:
              name: nginx-content
              key: index_content
      args:
        - "-c"
        - |
          envsubst < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf && \
          echo \${INDEX_CONTENT} > \${ROOT_LOCATION}/index.html && \
          exec nginx -g 'daemon off;'
      ports:
        - containerPort: 80
  volumes:
    - name: nginx-config-volume
      configMap:
        name: nginx-template-config
        items:
          - key: nginx.conf.template
            path: nginx.conf.template
EOF
```

### 3. For secret it's the same but in base64

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: nginx-content
type: Opaque
data:
  index_content: SGVsbG8gR3V5cyBjdXJsCg==
EOF
```

#### and the pod

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-env-pod
spec:
  containers:
    - name: nginx
      image: nginx:latest
      envFrom:
        - configMapRef:
            name: nginx-env-config
      volumeMounts:
        - name: nginx-config-volume
          mountPath: /etc/nginx/templates/nginx.conf.template
          subPath: nginx.conf.template
      command: ["/bin/sh"]
      env:
        - name: INDEX_CONTENT
          valueFrom:
            secretKeyRef:
              name: nginx-content
              key: index_content
      args:
        - "-c"
        - |
          envsubst < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf && \
          echo \${INDEX_CONTENT} > \${ROOT_LOCATION}/index.html && \
          exec nginx -g 'daemon off;'
      ports:
        - containerPort: 80
  volumes:
    - name: nginx-config-volume
      configMap:
        name: nginx-template-config
        items:
          - key: nginx.conf.template
            path: nginx.conf.template
EOF
```

### 4. For an entire directory

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: hello
data:
  test1.txt: |
    hello 1
  test2.txt: |
    hello 2
EOF
```

#### and the pod

```
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: alpine
spec:
  containers:
    - name: alpine
      image: alpine:latest
      volumeMounts:
        - name: hello
          mountPath: /tmp/test/
      command: ["/bin/sh"]
      args:
        - "-c"
        - |
          sleep infinity
  volumes:
    - name: hello
      configMap:
        name: hello
EOF
```



**** 
kubectl exec -it nginx-lsf089jhs -- bash -c "env"

****
## SECRETS

```
kubectl get secrets
kubectl create secret generic toto --from-literal=password='Test!Passw0rd##'

echo "VGVzdFBhc3MqKg==" | base64 -d
kubectl get secret -o jsonpath='{ .data.passord}' | base64 -d
password=$(kubectl get secret -o jsonpath='{ .data.passord}' | base64 -d)
echo $password
echo "PaswordLavabe$###" | base64 | tr -d "\n"