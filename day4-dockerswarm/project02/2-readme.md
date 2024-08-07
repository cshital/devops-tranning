# Project 02: Deploying an Application Across Multiple Docker Swarm Worker Nodes

Objectives:

- Deploy an application across multiple Docker Swarm worker nodes.
- Place specific components on designated nodes.
- Monitor and troubleoot using Docker logs.
- Modify and redeploy the application.

Project Outline:

- Initialize Docker Swarm and Join Worker Nodes
- Label Nodes for Specific Component Placement
- Create a Docker Stack File
- Deploy the Application
- Monitor and Troubleoot Using Docker Logs
- Modify and Redeploy the Application

Step-by-Step Guide
1. Initialize Docker Swarm and Join Worker Nodes

On the manager node, initialize Docker Swarm:


```
docker swarm init --advertise-addr <MANAGER-IP>
```
![](</project02/images/1.1.png>)


Example:

```
docker swarm init --advertise-addr 13.201.80.142
```


Join the worker nodes to the swarm. On each worker node, run the command provided by the docker swarm init output:


```
docker swarm join --token <SWARM-TOKEN> <MANAGER-IP>:2377
```

Example:

```
docker swarm join --token SWMTKN-1-62eb6ununwaneewo0dnvf9f39k2x4zrv9nsl9pmd067rg80wjk-834fthh0d8g9u8gli0i7pyow9 13.201.80.142:2377
```


Verify the nodes have joined:

```
docker node ls
```

![](</project02/images/1.3.png>)


2. Label Nodes for Specific Component Placement

Label nodes to specify where certain components ould run. For example, label a node for the database service:

```
docker node update --label-add db=true <NODE-ID>
```

![](</project02/images/2.1.png>)


Example:


```
docker node update --label-add db=true x2wne8asx9zlycpqi6zpgf68x
```

![](</project02/images/2.2.png>)


Label another node for the application service:


```
docker node update --label-add app=true <NODE-ID>
```


Examples:


```
docker node update --label-add app=true 4lm786bohq5yxvw0krfop1zkv
docker node update --label-add app=true x2wne8asx9zlycpqi6zpgf68x
```

Verify the labels:

```
docker node inspect <NODE-ID>
```

Example:

```
docker node inspect x2wne8asx9zlycpqi6zpgf68x
```
![](</project02/images/2.3.png>)


3. Create a Docker Stack File

Create a docker-stack.yml file to define the services and node placement constraints:

```yaml
version: '3.8'
services:
  db:
    image: mysql:5.7
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - app_network
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: appdb
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    deploy:
      placement:
        constraints:
          - node.labels.db == true
  app:
    image: your-app-image
    networks:
      - app_network
    ports:
      - "8000:80"
    environment:
      DB_HOST: db
    deploy:
      replicas: 2
      placement:
        constraints:
          - node.labels.app == true
volumes:
  mysql_data:
networks:
  app_network:
```

4. Deploy the Application

Deploy the stack using Docker Swarm:

```
docker stack deploy -c docker-stack.yml app_stack
```
![](</project02/images/3.png>)


Verify the stack services:

```
docker stack services app_stack
```

5. Monitor and Troubleoot Using Docker Logs

Check the logs for the services:

```
docker service logs app_stack_db
docker service logs app_stack_app
```

![](</project02/images/5.1.png>)

![](</project02/images/5.2.png>)



Follow the logs in real-time to monitor issues:

```
docker service logs -f app_stack_app
```

6. Modify and Redeploy the Application

Make modifications to the application or the stack file as needed. For example, change the number of replicas:

```yaml
services:
  app:
    deploy:
      replicas: 3
```

![](</project02/images/6.1.png>)


Update the stack with the new configuration:

```
docker stack deploy -c docker-stack.yml app_stack
```
![](</project02/images/6.2.png>)


Verify the changes:


```
docker stack services app_stack
```

