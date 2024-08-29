# Day 27 

# Multi-Tier Architecture Deployment with AWS CloudFormation

## Project Objective

This project aims to test your ability to deploy a multi-tier architecture application using AWS CloudFormation. The deployment includes an EC2 instance, an S3 bucket, a MySQL DB instance in RDS, and a VPC.

### Specifications

- **EC2 Instance:**

  - Instance Type: `t2.micro`
  - Location: Public subnet
  - Access: SSH allowed from a specific IP range

  ![](images/1.png)

- **RDS MySQL DB Instance:**

  - Instance Type: `t3.micro`
  - Location: Private subnet 

![](images/2.png) 

- **S3 Bucket:**

  - Purpose: Store configuration files or assets for the web server

![](images/3.png)   

- **VPC:**

  - Includes public and private subnets
  - Internet access for EC2 via an Internet Gateway
  - No NAT Gateway or Elastic IP should be used

![](images/4.png)   
![](images/5.png) 

- **CloudFormation Template:**

  - Automates the deployment of the above components

```
AWSTemplateFormatVersion: '2010-09-09'
Description: AWS CloudFormation Template to create a VPC, EC2 instance, RDS
  MySQL database, and S3 bucket without SSH access.

Parameters:
  VpcCidr:
    Type: String
    Default: 10.0.0.0/16
    Description: CIDR block for the VPC.

  PublicSubnetCidr:
    Type: String
    Default: 10.0.1.0/24
    Description: CIDR block for the public subnet.

  PrivateSubnetCidr:
    Type: String
    Default: 10.0.2.0/24
    Description: CIDR block for the private subnet.


  InstanceType:
    Type: String
    Default: t2.micro
    Description: EC2 instance type.

  KeyName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: Name of an existing EC2 KeyPair.

  DBUsername:
    Type: String
    Default: admin
    NoEcho: true
    Description: The database admin account username.

  DBPassword:
    Type: String
    NoEcho: true
    Description: The database admin account password.
    MinLength: 6
    MaxLength: 41
    AllowedPattern: '[a-zA-Z0-9]*'
    ConstraintDescription: Must contain only alphanumeric characters.

  DBAllocatedStorage:
    Type: Number
    Default: 20
    Description: The size of the database (Gb).

  AMIId:
    Type: String
    Description: The AMI ID for the EC2 instance.
    Default: 'ami-0075013580f6322a1' # Replace with a region-specific AMI

  S3BucketName:
    Type: String
    Description: Unique name for the S3 bucket.

Resources:
  # VPC
  CustomVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCidr
      EnableDnsSupport: 'true'
      EnableDnsHostnames: 'true'
      Tags:
        - Key: Name
          Value: CustomVPC

  # Internet Gateway
  MyInternetGateway:
    Type: AWS::EC2::InternetGateway

  # Attach Internet Gateway to VPC
  AttachGateway:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref CustomVPC
      InternetGatewayId: !Ref MyInternetGateway

  # Public Subnet
  PublicSubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref CustomVPC
      CidrBlock: !Ref PublicSubnetCidr
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: 'true'
      Tags:
        - Key: Name
          Value: PublicSubnet

  # Private Subnet
  PrivateSubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref CustomVPC
      CidrBlock: !Ref PrivateSubnetCidr
      AvailabilityZone: !Select [0, !GetAZs '']
      Tags:
        - Key: Name
          Value: PrivateSubnet

    # Private Subnet 2
  PrivateSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref CustomVPC
      CidrBlock: 10.0.3.0/24  # Adjust the CIDR block for the second subnet
      AvailabilityZone: !Select [1, !GetAZs '']
      Tags:
        - Key: Name
          Value: PrivateSubnet2

  # Route Table for Public Subnet
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref CustomVPC
      Tags:
        - Key: Name
          Value: PublicRouteTable

  # Route to Internet Gateway for Public Subnet
  PublicRoute:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref MyInternetGateway

  # Associate Public Subnet with Route Table
  PublicSubnetRouteTableAssociation:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet
      RouteTableId: !Ref PublicRouteTable

  # Security Group for EC2 instance
  EC2SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable HTTP access on the inbound.
      VpcId: !Ref CustomVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: '80'
          ToPort: '80'
          CidrIp: 0.0.0.0/0

  # Security Group for RDS instance
  RDSSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow MySQL access only from the EC2 instance.
      VpcId: !Ref CustomVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: '3306'
          ToPort: '3306'
          SourceSecurityGroupId: !Ref EC2SecurityGroup

  # EC2 Instance
  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !Ref InstanceType
      KeyName: !Ref KeyName
      SecurityGroupIds:
        - !Ref EC2SecurityGroup
      SubnetId: !Ref PublicSubnet
      # IamInstanceProfile: !Ref EC2InstanceProfile
      ImageId: !Ref AMIId
      UserData: !Base64
        Fn::Sub: |
          #!/bin/bash
          apt update -y
          apt install -y apache2 mysql-client
          systemctl start apache2
          systemctl enable apache2

  # S3 Bucket
  MyS3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Ref S3BucketName

  #IAM Role for EC2 to Access S3
  EC2Role:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: S3AccessPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action: s3:*
                Resource: !Sub arn:aws:s3:::${MyS3Bucket}/*

  #IAM Instance Profile for EC2
  EC2InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref EC2Role

  # RDS MySQL DB Instance
  MyRDSInstance:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceClass: db.t3.micro
      Engine: MySQL
      MasterUsername: !Ref DBUsername
      MasterUserPassword: !Ref DBPassword
      AllocatedStorage: !Ref DBAllocatedStorage
      DBSubnetGroupName: !Ref DBSubnetGroup
      VPCSecurityGroups:
        - !Ref RDSSecurityGroup

  # DB Subnet Group
  DBSubnetGroup:
    Type: AWS::RDS::DBSubnetGroup
    Properties:
      DBSubnetGroupDescription: Subnet group for RDS
      SubnetIds:
        - !Ref PrivateSubnet
        - !Ref PrivateSubnet2
```
## Key Tasks

### 1. Create a CloudFormation Template

### VPC and Subnets

- Define a VPC with one public and one private subnet.
-Attach an Internet Gateway to the VPC to provide internet access for the public subnet.

![](images/6.png)

### Security Groups

- EC2 Security Group:

  - Allow SSH and HTTP access from a specific IP range.

- RDS Security Group:

  - Allow MySQL access from the EC2 instance only.

![](images/7.png)  

### EC2 Instance

- Launch a `t2.micro EC2` instance in the public subnet.

![](images/8.png)  

### S3 Bucket

- Create an S3 bucket for storing static assets or configuration files.

![](images/9.png)  

## RDS MySQL DB Instance

- Launch a `t3.micro` MySQL database in the private subnet.

![](images/10.png) 

## 2. Deploy the Application

- Deploy the CloudFormation stack using the created template.

- Verify that all components are correctly configured and operational.

![](images/11.png) 
![](images/12.png) 
![](images/13.png) 

## Resource Termination:

- Once the deployment and testing are complete, terminate all resources by deleting the CloudFormation stack. Ensure that no resources, such as EC2 instances, RDS instances, or S3 buckets, are left running.

![](images/14.png)
![](images/15.png)
![](images/16.png)

