# Day 19 Task

In this capstone project, you will create a comprehensive automated deployment pipeline for a web application on an AWS EC2 instance running Ubuntu using Ansible. You will follow best practices for playbooks and roles, implement version control, document and maintain your code, break down tasks into roles, write reusable and maintainable code, and use dynamic inventory scripts. This project will culminate in a fully functional deployment, demonstrating your mastery of Ansible for infrastructure automation.

## Milestone 1: Environment Setup

**Objective:** Configure your development environment and AWS infrastructure.

**Tasks:**
  - Launch an AWS EC2 instance running Ubuntu.
  - Install Ansible and Git on your local machine or control node.

**Deliverables:**
 - AWS EC2 instance running Ubuntu.
 - Local or remote control node with Ansible and Git installed.

## Milestone 2: Create Ansible Role Structure

**Objective:** Organize your Ansible project using best practices for playbooks and roles.

**Tasks:**
  - Use Ansible Galaxy to create roles for web server, database, and application deployment.
  - Define the directory structure and initialize each role.

```
ansible-galaxy init roles/application 
```

```
ansible-galaxy init roles/database 
```

```
ansible-galaxy init roles/webserver 
```

**Deliverables:**

Ansible role directories for webserver, database, and application.

![](images/1.png)
![](images/2.png)
![](images/3.png)

## Milestone 3: Version Control with Git

**Objective:** Implement version control for your Ansible project.

**Tasks:**
- Initialize a Git repository in your project directory.
- Create a .gitignore file to exclude unnecessary files.
- Commit and push initial codebase to a remote repository.

```
git init 

git add  roles  

git commit -m "roles" 

git branch -M main 

git remote add origin git@github.com:cshital/day19.git 

git push -u origin main 
```


**Deliverables:**
  - Git repository with initial Ansible codebase.

![](images/4.png)

  - Remote repository link (e.g., GitHub).

```
https://github.com/cshital/devops-training/tree/main/ day19 
```

## Milestone 4: Develop Ansible Roles 

**Objective:** Write Ansible roles for web server, database, and application deployment. 

**Tasks:**
   - Define tasks, handlers, files, templates, and variables within each role.   

   - Ensure each role is modular and reusable. 

**Deliverables:** 
   - Completed Ansible roles for webserver, database, and application. 

     - application 
     - database 
     - webserver 

## Milestone 5: Documentation and Maintenance 

**Objective:** Document your Ansible roles and playbooks for future maintenance. 

**Tasks:** 
   - Create README.md files for each role explaining purpose, variables, tasks, and handlers. 

   - Add comments within your playbooks and roles to explain complex logic.  

**Deliverables:**
    - README.md files for webserver, database, and application roles. 
    - Well-documented playbooks and roles. 

- application - README.md 
- database - README.md 
- webserver - README.md 

## Milestone 6: Dynamic Inventory Script 

**Objective:** Use dynamic inventory scripts to manage AWS EC2 instances. 

**Tasks:** 
  - Write a Python script that queries AWS to get the list of EC2 instances. 
  - Format the output as an Ansible inventory. 

**Deliverables:**
  - Dynamic inventory script to fetch EC2 instance details. 

```
#!/usr/bin/env python3 

import json 

import boto3 

  

def get_inventory(): 

    ec2 = boto3.client('ec2', region_name='ap-south-1') 

    response = ec2.describe_instances(Filters=[{'Name': 'tag:Role', 'Values': ['shital']}]) 

  
 inventory = { 

        'all': { 

            'hosts': [], 

            'vars': {} 

        }, 

        '_meta': { 

            'hostvars': {} 

        } 

    } 

user = 'ubuntu' 

# Corrected the path and closed the string properly 

    ssh_key_file = '/home/einfochips/Downloads/training.pem' 

  
 for reservation in response['Reservations']: 

        for instance in reservation['Instances']: 

            public_dns = instance.get('PublicDnsName', instance['InstanceId']) 

            inventory['all']['hosts'].append(public_dns) 

            inventory['_meta']['hostvars'][public_dns] = { 

                'ansible_host': instance.get('PublicIpAddress', instance['InstanceId']), 

                'ansible_user': user, 

                'ansible_ssh_private_key_file': ssh_key_file 

            } 

  
  return inventory 

if __name__ == '__main__': 

    print(json.dumps(get_inventory(), indent=2)) 
```
![](images/5.png)

## Milestone 7: Playbook Development and Deployment

**Objective:** Create and execute an Ansible playbook to deploy the web application. Tasks:
   - Develop a master playbook that includes all roles.
   - Define inventory and variable files for different environments.
   - Execute the playbook to deploy the web application on the EC2 instance. Deliverables:
   - Ansible playbook for web application deployment.

 ```
---
- name: multi tier application
  hosts: all
  become: yes
  tasks:
    - name: update_cache
      apt:
        update_cache: yes

  roles:
    - database
    - application_deploy
    - webserver
```
Run Playbook
```
ansible-playbook main.yml
```
- Successfully deployed web application on the EC2 instance.

![](images/6.png)
![](images/7.png)
![](images/8.png)
![](images/9.png)

**Output:**

![](images/10.png)
![](images/11.png)




       

    

    

