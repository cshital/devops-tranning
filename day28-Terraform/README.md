## 1. Setup Terraform Configuration

### Provider Configuration

**AWS Provider:** Configure the AWS provider to specify the region for deployment.

**Region Parameterization:** Ensure the region is parameterized using a Terraform variable for flexibility.

`provider.tf`

```
provider "aws" {
  region = var.region
}
```
## VPC and Security Groups

- **VPC Creation:** Create a Virtual Private Cloud (VPC) with a public subnet for the EC2 instance.

- **Security Groups:** Define security groups to:
   - Allow HTTP (port 80) and SSH (port 22) access to the EC2 instance.
   - Allow MySQL (port 3306) access to the RDS instance from the EC2 instance.

```
resource "aws_security_group" "ec2" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
## EC2 Instance

- **Instance Type:** Define an EC2 instance using the t2.micro instance type.
- **Configuration:** Configure the instance to allow SSH and HTTP access.
- **Variables:** Use Terraform variables to define instance parameters like AMI ID and instance type.

```
resource "aws_instance" "web" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2.id]  
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  key_name             = "terraform"

  tags = {
    Name = "web-instance"
  }
}
```
## RDS MySQL DB Instance

- **Instance Type:** Create a `t3.micro` MySQL DB instance within the same VPC.
- **Parameters:** Use Terraform variables to define database parameters such as DB name, username, and password.
- **Accessibility:** Ensure the DB instance is publicly accessible and configure security groups to allow access from the EC2 instance.

## S3 Bucket

- **Bucket Creation:** Create an S3 bucket for storing static files or configurations.

```
resource "aws_s3_bucket" "static_files" {
  bucket = var.bucket_name
}
```

- **IAM Role and Policy:** Allow the EC2 instance to access the S3 bucket by assigning the appropriate IAM role and policy.


