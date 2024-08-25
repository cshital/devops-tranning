# Day-13

# Multi-Branch Project

## Project Overview

This project demonstrates a simple Java Maven project with Git version control and Jenkins multi-branch pipeline for automated build and deployment.
Objectives:

- Create a Java Maven project.
- Use Git to manage multiple branches: development, staging, and production.
- Set up a Jenkins multi-branch pipeline to automate builds and deployments.

Project Deliverables
## 1. Git Repository

Initialize Local Git Repository:

```bash
mkdir app
cd app
git init
```

![](</images/1.png>)

Create Branches:

```bash
git branch development
git branch staging
git branch production
```

Repository pushed to remote Git server (e.g., GitHub, GitLab, Bitbucket).

![](</images/2.png>)

Switch to Branches:

```bash
git checkout -b development
git checkout -b staging
git checkout -b production
```

Push to Remote Git Server (e.g., GitHub, GitLab, Bitbucket):

```bash
    git add .
    git commit -m "Initial commit on [branch name] branch"
    git push -u origin [branch name]
```

## 2. Maven Project

Create a Simple Java Maven Project:

Create Project Directory:

```bash
mkdir -p src/main/java/com/example/
cd src/main/java/com/example/
```

Create App.java:

```java
package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
```

Create pom.xml:

```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/POM/4.0.0/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>com.example</groupId>
        <artifactId>my-java-app</artifactId>
        <version>1.0-SNAPSHOT</version>
        <properties>
            <maven.compiler.source>1.8</maven.compiler.source>
            <maven.compiler.target>1.8</maven.compiler.target>
        </properties>
    </project>
```

Push the Project Code to All Branches:

```bash
    git branch
    git checkout development
    git add .
    git commit -m "Initial commit on development branch"
    git push -u origin development

    git checkout staging
    git add .
    git commit -m "Initial commit on staging branch"
    git push -u origin staging

    git checkout production
    git add .
    git commit -m "Initial commit on production branch"
    git push -u origin production
```

## 3. Jenkins Setup

Configure Multi-Branch Pipeline Job in Jenkins.

![](</images/4.png>)

![](</images/5.png>)

![](</images/6.png>)

Create Jenkinsfile for Build and Deployment:

```groovy

    pipeline {
        agent any
        tools {
            maven 'maven-3.9.8'
        }

        stages {
            stage('Checkout') {
                steps {
                    git url: 'https://github.com/cshital/maven.git', branch: env.BRANCH
                }
            }

            stage('Build') {
                steps {
                    script {
                        echo "Building pull request branch: ${env.BRANCH}"
                        sh 'mvn clean install'
                    }
                }
            }

            stage('Test') {
                steps {
                    script {
                        echo "Running tests on pull request branch: ${env.BRANCH}"
                        sh 'mvn test'
                    }
                }
            }

            stage('Output') {
                steps {
                    script {
                        sh 'java src/main/java/com/example/App.java'
                    }
                }
            }

            stage('Archive Artifacts') {
                steps {
                    archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
                }
            }
        }

        post {
            always {
                echo 'Pipeline finished.'
            }
            success {
                echo 'Pipeline succeeded.'
            }
            failure {
                echo 'Pipeline failed.'
            }
        }
    }
```

![](</images/7.png>)

## Output

    The Jenkins pipeline automates the build, test, and deployment of the Java Maven project across multiple branches.
    Artifacts generated during the build process are archived for future reference.