Project 01: Deploying a Node.js App Using Minikube Kubernetes
Project Overview

In this project, you will develop a simple Node.js application, deploy it on a local Kubernetes cluster using Minikube, and configure various Kubernetes features. The project includes Git version control practices, creating and managing branches, performing rebases, and working with ConfigMaps, Secrets, environment variables, and autoscaling.
Table of Contents

    Setup Minikube and Git Repository
    Develop a Node.js Application
    Create Dockerfile and Docker Compose
    Build and Push Docker Image
    Create Kubernetes Configurations
    Implement Autoscaling
    Test the Deployment

1. Setup Minikube and Git Repository

1.1 Start Minikube:

bash

minikube start

1.2 Set Up Git Repository:

bash

mkdir nodejs-k8s-project
cd nodejs-k8s-project
git init

1.3 Create a .gitignore file:

bash

node_modules/
.env

1.4 Add and commit initial changes:

bash

git add .
git commit -m "Initial commit"

2. Develop a Node.js Application

2.1 Create the Node.js App:

bash

npm init -y
npm install express body-parser

2.2 Create app.js:

javascript

const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

2.3 Update package.json to include a start script:

json

"scripts": {
  "start": "node app.js"
}

2.4 Commit the Node.js application:

bash

git add .
git commit -m "Add Node.js application code"

3. Create Dockerfile and Docker Compose

3.1 Create a Dockerfile:

Dockerfile

# Use official Node.js image
FROM node:18

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port on which the app runs
EXPOSE 3000

# Command to run the application
CMD [ "npm", "start" ]

3.2 Create a .dockerignore file:

node_modules
.npm

3.3 (Optional) Create docker-compose.yml for local testing:

yaml

version: '3'
services:
  app:
    build: .
    ports:
      - "3000:3000"

3.4 Add and commit changes:

bash

git add Dockerfile docker-compose.yml
git commit -m "Add Dockerfile and Docker Compose configuration"

4. Build and Push Docker Image

4.1 Build the Docker image:

bash

docker build -t nodejs-app:latest .

4.2 Tag and push the image to Docker Hub:

bash

docker tag nodejs-app:latest your-dockerhub-username/nodejs-app:latest
docker push your-dockerhub-username/nodejs-app:latest

4.3 Add and commit changes:

bash

git add .
git commit -m "Build and push Docker image"

5. Create Kubernetes Configurations

5.1 Create Kubernetes Deployment (kubernetes/deployment.yaml):

yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nodejs-app
  template:
    metadata:
      labels:
        app: nodejs-app
    spec:
      containers:
      - name: nodejs-app
        image: your-dockerhub-username/nodejs-app:latest
        ports:
        - containerPort: 3000
        env:
        - name: PORT
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: PORT
        - name: NODE_ENV
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: NODE_ENV

5.2 Create ConfigMap (kubernetes/configmap.yaml):

yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  PORT: "3000"

5.3 Create Secret (kubernetes/secret.yaml):

yaml

apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  NODE_ENV: cHJvZHVjdGlvbmFs # Base64 encoded value for "production"

5.4 Add and commit Kubernetes configurations:

bash

git add kubernetes/
git commit -m "Add Kubernetes deployment, configmap, and secret"

5.5 Apply the Kubernetes Configurations:

bash

kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/secret.yaml
kubectl apply -f kubernetes/deployment.yaml

6. Implement Autoscaling

6.1 Create Horizontal Pod Autoscaler (kubernetes/hpa.yaml):

yaml

apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: nodejs-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-app-deployment
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50

6.2 Create Vertical Pod Autoscaler (kubernetes/vpa.yaml):

yaml

apiVersion: autoscaling.k8s.io/v1beta2
kind: VerticalPodAutoscaler
metadata:
  name: nodejs-app-vpa
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-app-deployment
  updatePolicy:
    updateMode: "Auto"

6.3 Apply the Autoscalers:

bash

kubectl apply -f kubernetes/hpa.yaml
kubectl apply -f kubernetes/vpa.yaml

7. Test the Deployment

7.1 Verify the Pods:

bash

kubectl get pods

7.2 Verify the Services:

bash

kubectl get svc

7.3 Verify the Horizontal Pod Autoscaler (HPA):

bash

kubectl get hpa

7.4 Expose the Service (if needed):

bash

kubectl expose deployment nodejs-app-deployment --type=NodePort --port=3000