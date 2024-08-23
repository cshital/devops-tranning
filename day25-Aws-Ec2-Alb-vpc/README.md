# **Day 25 Task**

**Deploying a Path-Based Routing Web Application on AWS**

**Objective:**

-   To evaluate your skills in deploying a web application on AWS using
    EC2 instances, configuring security groups, and setting up an
    Application Load Balancer (ALB) with path-based routing. You will
    deploy two simple web applications, configure the ALB to route
    traffic based on the URL path, and terminate all resources once the
    project is complete.

**Project Scenario:**

-   A small company needs to deploy two lightweight web applications,
    \"App1\" and \"App2,\" on AWS. The traffic to these applications
    should be routed through a single Application Load Balancer (ALB)
    based on the URL path. The company has opted for t2.micro instances
    for cost efficiency. Project Steps and Deliverables:

## **EC2 Instance Setup (30 minutes):**

-   Launch four EC2 t2.micro instances using the Amazon Linux 2 AMI.

-   SSH into each instance and deploy a simple web application:

    -   Deploy \"App1\" on two instances.

    -   Deploy \"App2\" on the other two instances.

-   Assign tags to the instances for identification (e.g.,
    \"App1-Instance1,\" \"App1-Instance2,\" \"App2-Instance1,\"
    \"App2-Instance2\").

![](</images/1.png>)

## **Security Group Configuration (20 minutes):**

-   Create a security group for the EC2 instances that allows inbound
    HTTP (port 80) and SSH (port 22) traffic from your IP address.

-   Create a security group for the ALB that allows inbound traffic on
    port 80.

-   Attach the appropriate security groups to the EC2 instances and ALB.

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/c2876ab0d11ef2b97f4e355c6cad4f267d5bd2e0.png)

## **Application Load Balancer Setup with Path-Based Routing (40 minutes):**

Create an Application Load Balancer (ALB):

-   Set up an ALB in the same VPC and subnets as your EC2 instances.

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/6e3af3c779624a5a78885d7ee6dd63ef25c308b2.png)

Configure the ALB with two target groups:

Target Group 1: For \"App1\" instances.

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/6dbdce64a169251631ff1fe5b3fd5b1631d6a380.png)

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/2c2d8c9046ea3a8923b50508dc1e8f924cd6e8b9.png)

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/2122825aea20ea8fd6925fda9ba9bf10ad20db01.png)


![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/69ecb379b065c81309356341d50e9273e2c0012f.png)

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/7befaf24c024c26482d641652d5d55c0f8e35f64.png)


![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/8a200e06da835e0d882e55978c621b3b2085e93e.png)


-   Target Group 2: For \"App2\" instances.

```{=html}
<!-- -->
```
-   Register the appropriate EC2 instances with each target group.

```{=html}
<!-- -->
```
-   Configure Path-Based Routing:

    -   Set up path-based routing rules on the ALB:

        -   Route traffic to \"App1\" instances when the URL path is
            /app1.

> ![](/photos/04f5d164071458ad6bbf15062a67d69a7788827b.png)


![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/d64efc1d1d14f3f66fe9efd7e0f6e03257254f70.png)

-   Route traffic to \"App2\" instances when the URL path is /app2.

-   Set up health checks for each target group to ensure that the
    instances are healthy and available.

## **Testing and Validation (20 minutes):**

-   Test Path-Based Routing:

    -   Access the ALB\'s DNS name and validate that requests to /app1
        are correctly routed to the \"App1\" instances and that /app2
        requests are routed to the \"App2\" instances.

-   Security Validation:

    -   Attempt to access the EC2 instances directly via their public
        IPs to ensure that only your IP address can SSH into the
        instances.

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/9e889e8b58731030d3bcb1661b25e33051960460.png)

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/bf4c9c2b5cea1cecae4c9842d2a2e46f4074f717.png)


## **Resource Termination (10 minutes):**

Terminate EC2 Instances:

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/07209aff981c2c0ceeb8f08f12cecb03fca87254.png)

Delete Load Balancer:

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/f1376b32b1dd323e89a8004f485b74391063c3aa.png)
Delete Load Balancer and Target Groups:

![](vertopal_b0e0b8e864ca44cb811f1171a011c4ec/04f5d164071458ad6bbf15062a67d69a7788827b.png)
