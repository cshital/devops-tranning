# Project: Deploying a Static Web App on Kubernetes with Ingress and Horizontal Pod Autoscaling

## Project Overview

This project involves deploying a static web application using Minikube, configuring ingress networking, implementing horizontal pod autoscaling (HPA), and performing stress testing. The project is divided into four main stages:

- Setting Up the Kubernetes Cluster and Static Web App
- Configuring Ingress Networking
- Implementing Horizontal Pod Autoscaling
- Final Validation and Cleanup

Stage 1: Setting Up the Kubernetes Cluster and Static Web App

1.1 Set Up Minikube

Ensure Minikube is installed and running on your local Ubuntu machine.

```bash
minikube start
```

![](</images/1.png>)

1.2 Deploy Static Web App
1.2.1 Create a Dockerfile for the Static Web Application

Create an HTML file index.html:

```bash
nano index.html
```
![](</images/2.png>)


Add the following content:

```html
<!doctype html>
<html>
<body>
    <head>
        <title>Static Web</title>
    </head>
    <body>
        <p>Welcome to my Static website!</p>
    </body>
</html>
```

Create a Dockerfile:

```bash
nano Dockerfile
```

Add the following content:

```Dockerfile
FROM nginx:1.10.1-alpine
COPY index.html /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

1.2.2 Build and Push Docker Image

Build the Docker image:

```bash
docker build -t shital37/customnginx-app .
```

![](</images/3.png>)


Push the image to Docker Hub:

```bash
docker push shital37/customnginx-app:latest
```

![](</images/4.png>)


1.3 Kubernetes Deployment
1.3.1 Frontend Deployment

Create frontend-deployment.yml:

```bash
nano frontend-deployment.yml
```

Add the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: nginx
spec:
  replicas: 1 
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: shital37/customnginx-app:latest
          ports:
            - containerPort: 80
          resources:
            limits:
              cpu: 50m
            requests:
              cpu: 20m
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx  
  ports:
    - protocol: TCP
      port: 80  
      targetPort: 80  
  type: NodePort
```

1.3.2 Backend Deployment

Create backend-deployment.yml:

```bash
nano backend-deployment.yml
```

Add the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: hashicorp/http-echo
        args:
          - "-text= This is test message from backend"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5678
```

1.3.3 Apply Deployment and Service Manifests

```bash
kubectl apply -f frontend-deployment.yml
kubectl apply -f backend-deployment.yml
```

![](</images/5.png>)


Stage 2: Configuring Ingress Networking
2.1 Install and Configure Ingress Controller

Start Minikube with the Ingress addon:

```bash
minikube start --addons=ingress
minikube addons enable ingress
kubectl get pods -n kube-system
```

![](</images/6.png>)

![](</images/7.png>)



2.2 Create Ingress Resource

Create ingress-resource.yaml:

```bash
nano ingress-resource.yaml
```

Add the following content:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: static-web-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "route"
spec:
  rules:
    - host: myapp.com
      http:
        paths:
          - path: /home
            pathType: Prefix
            backend:
              service:
                name: nginx-service
                port:
                  number: 80
          - path: /page
            pathType: Prefix
            backend:
              service:
                name: backend-service
                port:
                  number: 80
  tls:
    - hosts:
        - myapp.com
      secretName: tls-secret
```

Apply the Ingress resource:

```bash
kubectl apply -f ingress-resource.yaml
```

![](</images/10.png>)


2.3 Update /etc/hosts

Update your /etc/hosts file:

```bash
sudo nano /etc/hosts
```

Add the following line (replace <minikube-ip> with your Minikube IP):

```
<minikube-ip> myapp.com
```

Get the Minikube IP:


```bash
minikube ip
```
![](</images/9.png>)


2.4 Generating a Self-Signed SSL/TLS Certificate

Generate the certificate:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=myapp.com/O=myapp"
```
![](</images/10.png>)


2.5 Creating a Kubernetes Secret

Create a secret:

```bash
kubectl create secret tls tls-secret --cert=tls.crt --key=tls.key
kubectl get secret tls-secret
```

2.6 Access the Application

Check the application:

```
    https://myapp.com/home
    https://myapp.com/page
```

![](</images/12.png>)

![](</images/13.png>)


Stage 3: Implementing Horizontal Pod Autoscaling
3.1 Configure Horizontal Pod Autoscaler

Create hpa.yaml:

```bash
nano hpa.yaml
```

![](</images/14.png>)


Add the following content:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nginx-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: frontend
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 5
```

Apply the HPA manifest:

```bash
kubectl apply -f hpa.yaml
```

![](</images/18.png>)


3.2 Stress Testing

Perform stress testing and monitor the scaling behavior to ensure the application scales based on load.
Stage 4: Final Validation and Cleanup
4.1 Final Validation

Validate the following:

```
    Ingress networking
    URL rewriting
    Sticky sessions
    Application performance under different load conditions
```

4.2 Cleanup

Delete the resources created during the project:

```bash
kubectl delete deployment frontend
kubectl delete deployment backend
kubectl delete service frontend-service
kubectl delete service backend-service
kubectl delete ingress static-web-app-ingress
kubectl delete hpa nginx-app-hpa
```

![](</images/19.png>)
