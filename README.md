# 🚀 CI/CD Pipeline for Java Quotes Application

This document outlines the successful implementation of a full **Continuous Integration/Continuous Delivery (CI/CD) pipeline**, which automates the path from source code to a live application on an AWS EC2 instance.

---

## 🗺️ Overview of the Pipeline

The pipeline is triggered by a push to the **main branch**, automatically building a Docker image and preparing it for deployment.

| Component | Tool / Target | Role in the Pipeline |
| :--- | :--- | :--- |
| **Source/Trigger** | GitHub | Code hosting and primary workflow trigger. |
| **CI Runner** | GitHub Actions | Executes tests, builds the artifact. |
| **Artifact Registry** | Docker Hub | Stores the final image (`goutamsharma369/java-quotes-app:latest`). |
| **Deployment Target** | AWS EC2 (Ubuntu) | Production environment for container execution. |
| **Application** | Java 17 | Runs internally on port 8000. |

---

## 🛠️ Phase 1: Continuous Integration (CI)

The CI phase ensures code quality and creates the deployable container artifact.

### Critical Setup Fixes

These actions resolved initial configuration hurdles:

| Action | Command Executed | Purpose |
| :--- | :--- | :--- |
| **Sync Repository** | `git push --force origin master:main` | Overwrote conflicting remote files to align local and remote branches. |
| **Security Fix** | *(New PAT Required)* | Updated Personal Access Token (PAT) to include the **workflow scope**, resolving write permission errors for GitHub Actions files. |

### CI Workflow Result

The workflow successfully built the Java application and published the image.

* **Image Path:** `goutamsharma369/java-quotes-app:latest`
* **Status:** Confirmed by a green checkmark in GitHub Actions.

---

## 🚚 Phase 2: Continuous Delivery (CD) & Deployment

The CD phase uses Docker Compose on the EC2 host to deploy the latest image.

### Crucial Deployment Fixes

The application failed to launch or be reached due to two environmental conflicts:

| Issue | Diagnosis | Resolution Command / Action |
| :--- | :--- | :--- |
| **Port 80 Conflict** | Nginx was running on host Port 80, blocking Docker. | `sudo systemctl stop nginx` |
| **Port Mismatch** | `docker-compose.yml` was incorrectly mapping `80:5000` while the Java app ran on `8000`. | File was updated to `ports: - "80:8000"`. |

### Final Deployment Sequence

After resolving the conflicts, the application was launched using the corrected configuration:

1.  **Cleanup & Stop Old Container:**
    ```bash
    sudo docker-compose down
    ```
2.  **Pull Latest Image and Launch:**
    ```bash
    sudo docker-compose up -d
    ```
### Final Deployment Configuration (`docker-compose.yml`)

This is the final, corrected configuration used to launch the application:

```yaml
version: '3.8'
services:
  web:
    image: goutamsharma369/java-quotes-app:latest
    container_name: java_ci_cd_app
    # Correct mapping of external HTTP (80) to internal Java app (8000)
    ports:
      - "80:8000"
    restart: always
### Final Deployment Status

The application is successfully running and exposed on the standard HTTP port:
