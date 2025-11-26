Java Quotes Application CI/CD Pipeline

Hello! This repository hosts a simple Java application designed to demonstrate a complete Continuous Integration/Continuous Delivery (CI/CD) pipeline. Every change pushed here automatically results in a new, deployable Docker image.

🚀 Technology & Tools

Component

Tool / Version

Purpose

Application

Java 17

Core application logic (Simple Quotes App).

CI/CD

GitHub Actions

Orchestrates the automated Test, Build, and Push process.

Containerization

Docker

Packages the application into a portable image.

Registry

Docker Hub

Stores the final artifact at goutamsharma369/java-quotes-app.

Deployment

Docker Compose

Used on the EC2 Ubuntu server for simplified deployment.

⚙️ CI/CD Pipeline Flow

The workflow defined in .github/workflows/main.yml is the engine for this project.

Trigger: A push to the main branch starts the pipeline.

Test (CI): The workflow sets up Java 17 and runs mock unit tests (or real tests in a production setup).

Build (CI): The Dockerfile compiles the Java code and creates a container image.

Publish (CI): Using stored GitHub Secrets (DOCKER_USERNAME & DOCKER_PASSWORD), the image is pushed to Docker Hub.

Deploy (CD): The final image is ready to be pulled and launched on the target EC2 server.

🐳 Deployment Instructions (Continuous Delivery)

To run the application, you must use docker-compose on the EC2 host. Note that the application runs internally on port 8000, which is mapped to external port 80.

Prerequisites

GitHub Secrets are configured for the CI phase.

Docker and docker-compose are installed on the EC2 host.

The EC2 host has authenticated with Docker Hub (docker login).

The AWS Security Group must have an Inbound Rule allowing TCP Port 80 (HTTP) from your desired IP ranges.

The Correct Deployment Configuration

This is the version of the docker-compose.yml that successfully ran the application (correcting the critical 80:5000 error):

version: '3.8'

services:
  web:
    image: goutamsharma369/java-quotes-app:latest
    container_name: java_ci_cd_app
    # CRITICAL: Maps external HTTP port 80 to the internal Java application port 8000
    ports:
      - "80:8000"
    restart: always


Deployment Commands

Execute these commands from the directory containing the docker-compose.yml file:

Stop and Remove Existing Containers: (Clears old, incorrect deployments)

sudo docker-compose down


Pull Latest Image and Start Application:

sudo docker-compose up -d


⚠️ Key Troubleshooting Points

These are the main issues encountered during setup that must be addressed for future deployments:

PAT Scope: The Personal Access Token used for Git push MUST have the workflow scope checked, as the workflow files are stored in a protected directory.

Port Conflict: A pre-existing Nginx service was using host Port 80. If the deployment fails due to "address already in use," stop the conflicting service: sudo systemctl stop nginx.

Final Port Mapping: The Dockerfile exposes 8000, requiring the docker-compose.yml to use the mapping 80:8000.
