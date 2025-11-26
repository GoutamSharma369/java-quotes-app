# 🚀 CI/CD Pipeline for Java Quotes Application

[cite_start]This document outlines the successful implementation of a full **Continuous Integration/Continuous Delivery (CI/CD) pipeline**, which automates the path from source code to a live application on an AWS EC2 instance[cite: 3].

---

## 🗺️ Overview of the Pipeline

[cite_start]The pipeline is triggered by a push to the **main branch**, automatically building a Docker image and preparing it for deployment[cite: 5].

| Component | Tool / Target | Role in the Pipeline |
| :--- | :--- | :--- |
| **Source/Trigger** | GitHub | [cite_start]Code hosting and primary workflow trigger[cite: 6]. |
| **CI Runner** | GitHub Actions | [cite_start]Executes tests, builds the artifact[cite: 6]. |
| **Artifact Registry** | Docker Hub | [cite_start]Stores the final image (`goutamsharma369/java-quotes-app:latest`)[cite: 6]. |
| **Deployment Target** | AWS EC2 (Ubuntu) | [cite_start]Production environment for container execution[cite: 6]. |
| **Application** | Java 17 | [cite_start]Runs internally on port 8000[cite: 6]. |

---

## 🛠️ Phase 1: Continuous Integration (CI)

[cite_start]The CI phase ensures code quality and creates the deployable container artifact[cite: 8].

### Critical Setup Fixes

[cite_start]These actions resolved initial configuration hurdles[cite: 10]:

| Action | Command Executed | Purpose |
| :--- | :--- | :--- |
| **Sync Repository** | `git push --force origin master:main` | [cite_start]Overwrote conflicting remote files to align local and remote branches[cite: 12]. |
| **Security Fix** | *(New PAT Required)* | [cite_start]Updated Personal Access Token (PAT) to include the **workflow scope**, resolving write permission errors for GitHub Actions files[cite: 12]. |

### CI Workflow Result

[cite_start]The workflow successfully built the Java application and published the image[cite: 14].

* [cite_start]**Image Path:** `goutamsharma369/java-quotes-app:latest` [cite: 15]
* [cite_start]**Status:** Confirmed by a green checkmark in GitHub Actions[cite: 16].

---

## 🚚 Phase 2: Continuous Delivery (CD) & Deployment

[cite_start]The CD phase uses Docker Compose on the EC2 host to deploy the latest image[cite: 18].

### Crucial Deployment Fixes

[cite_start]The application failed to launch or be reached due to two environmental conflicts[cite: 20]:

| Issue | Diagnosis | Resolution Command / Action |
| :--- | :--- | :--- |
| **Port 80 Conflict** | [cite_start]Nginx was running on host Port 80, blocking Docker[cite: 21]. | [cite_start]`sudo systemctl stop nginx` [cite: 21] |
| **Port Mismatch** | [cite_start]`docker-compose.yml` was incorrectly mapping `80:5000` while the Java app ran on `8000`[cite: 21]. | [cite_start]File was updated to `ports: - "80:8000"`[cite: 21]. |

### Final Deployment Sequence

[cite_start]After resolving the conflicts, the application was launched using the corrected configuration[cite: 23]:

1.  **Cleanup & Stop Old Container:**
    ```bash
    sudo docker-compose down
    ```
2.  **Pull Latest Image and Launch:**
    ```bash
    sudo docker-compose up -d
    ```

### Final Deployment Status

[cite_start]The application is successfully running and exposed on the standard HTTP port[cite: 29]:

### Final Deployment Configuration (`docker-compose.yml`)

[cite_start]This is the final, corrected configuration used to launch the application[cite: 31, 33]:

```yaml
version: '3.8'
services:
  web:
    image: goutamsharma369/java-quotes-app:latest
    container_name: java_ci_cd_app
    # Correct mapping of external HTTP (80) to internal Java app (8000)
    ports:
      - [cite_start]"80:8000" [cite: 39, 40]
    [cite_start]restart: always [cite: 41]
