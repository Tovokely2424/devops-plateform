# DevOps Engineering Journey

> A hands-on, project-driven journey documenting the design, automation, deployment, operation, troubleshooting, and continuous improvement of a modern application infrastructure.

## Overview

This repository is my professional DevOps portfolio and learning journey.

Rather than collecting isolated exercises, this project follows the evolution of a real application and its infrastructure through multiple stages of the DevOps lifecycle.

The repository starts with the foundations of Linux, Git, Docker, AWS, and Kubernetes, then progressively evolves toward Infrastructure as Code, CI/CD, security, observability, GitOps, and a production-oriented cloud platform.

The goal is not only to learn tools.

The goal is to understand:

* how applications are packaged and deployed
* how infrastructure is provisioned and managed
* how distributed systems communicate
* how environments are separated
* how access is controlled
* how failures are investigated
* how deployments are automated
* how systems are monitored and operated
* how infrastructure decisions are documented and improved

This repository therefore contains both **implementation artifacts** and **engineering documentation**, including manifests, scripts, infrastructure code, troubleshooting records, architectural decisions, and lessons learned.

---

# 🎯 Project Goals

The long-term objective of this repository is to build and operate a production-oriented DevOps platform around a multi-tier application.

The journey progressively covers:

```text
Linux
  │
  ▼
Git & Version Control
  │
  ▼
Docker & Containerization
  │
  ▼
AWS & Cloud Infrastructure
  │
  ▼
Kubernetes & Container Orchestration
  │
  ▼
Infrastructure as Code with Terraform
  │
  ▼
CI/CD Automation
  │
  ▼
Security & Access Control
  │
  ▼
Monitoring & Observability
  │
  ▼
GitOps
  │
  ▼
Production-Oriented DevOps Platform
```

The final objective is to demonstrate the ability to move from:

> **Application → Container → Infrastructure → Kubernetes → Automation → Observability → Production Operations**

---

# 🏗️ Repository Architecture

```text
.
├── app/                    # Application source code
│   ├── backend/
│   ├── database/
│   └── frontend/
│
├── aws-cli/                # AWS CLI practice and service-specific exercises
│   ├── alb/
│   ├── ec2/
│   ├── ecr/
│   ├── eks/
│   ├── iam/
│   ├── networking/
│   ├── rds/
│   └── s3/
│
├── ci-cd/                  # CI/CD pipelines and automation
│
├── docker/                 # Dockerfiles and container configuration
│   ├── backend/
│   ├── frontend/
│   └── nginx/
│
├── docker-compose/         # Local multi-container environment
│
├── docs/                   # Engineering documentation
│   ├── architecture/
│   ├── decisions/
│   ├── learning-notes/
│   └── troubleshooting/
│
├── kubernetes/             # Application Kubernetes manifests
│   ├── base/
│   └── overlays/
│       ├── dev/
│       ├── staging/
│       └── prod/
│
├── Linux/                  # Linux configuration and automation
│
├── milestones/             # Structured learning milestones
│   ├── 00-foundations/
│   ├── 01-linux/
│   ├── 02-git/
│   ├── 03-docker/
│   ├── 04-aws-cli/
│   ├── 05-aws-networking/
│   ├── 06-kubernetes/
│   ├── 07-kubernetes-production/
│   ├── 08-terraform/
│   ├── 09-cicd/
│   ├── 10-security/
│   ├── 11-monitoring/
│   └── 12-final-platform/
│
├── monitoring/             # Monitoring and observability
│
├── scripts/                # Automation scripts
│   ├── aws/
│   ├── docker/
│   ├── kubernetes/
│   └── linux/
│
└── terraform/              # Infrastructure as Code
    ├── environments/
    │   ├── dev/
    │   ├── staging/
    │   └── prod/
    └── modules/
```

---

# 🚀 The Application

The repository is centered around a multi-tier application that serves as the main workload for the DevOps journey.

The application is progressively transformed and deployed through different stages:

```text
Application Source Code
        │
        ▼
Containerized Services
        │
        ▼
Docker Compose Environment
        │
        ▼
AWS Infrastructure
        │
        ▼
Kubernetes Deployment
        │
        ▼
Environment-Specific Configuration
        │
        ▼
Automated CI/CD
        │
        ▼
Monitoring & Observability
        │
        ▼
Production-Oriented Platform
```

The purpose is to work with the same application across the different stages instead of learning each technology in isolation.

---

# 🧱 Learning Milestones

Each milestone represents a practical stage of the journey.

## 00 — Foundations

Core concepts required before moving into infrastructure automation and orchestration.

Topics include:

* Linux fundamentals
* networking concepts
* processes and services
* filesystems
* permissions
* shell usage
* basic infrastructure concepts

---

## 01 — Linux

Practical Linux administration and automation.

Focus areas include:

* users and groups
* permissions
* processes
* system services
* networking
* storage
* package management
* shell scripting
* troubleshooting

📁 [`milestones/01-linux`](./milestones/01-linux)

---

## 02 — Git

Version control and collaborative workflows.

Topics include:

* repositories
* branches
* merges
* rebasing
* tags
* remote repositories
* Git workflows
* versioning practices

📁 [`milestones/02-git`](./milestones/02-git)

---

## 03 — Docker

Application containerization.

Focus areas include:

* Docker images
* Dockerfiles
* layers
* containers
* networks
* volumes
* image optimization
* multi-container applications

📁 [`milestones/03-docker`](./milestones/03-docker)

---

## 04 — AWS CLI

Hands-on AWS operations using the command line.

Services explored include:

* EC2
* IAM
* S3
* VPC and networking
* RDS
* ALB
* ECR
* EKS

The objective is to understand cloud operations both conceptually and through direct interaction with AWS services.

📁 [`aws-cli`](./aws-cli)

---

## 05 — AWS Networking

Networking architecture and cloud connectivity.

Topics include:

* VPC
* public and private subnets
* route tables
* Internet Gateway
* NAT
* security groups
* network segmentation
* load balancing

📁 [`milestones/05-aws-networking`](./milestones/05-aws-networking)

---

# ☸️ 06 — Kubernetes

Kubernetes is a major part of this journey.

The objective is not simply to deploy containers with Kubernetes, but to understand how the platform works internally and how to troubleshoot real failures.

Current topics include:

## Fundamentals

* Pods
* ReplicaSets
* Deployments
* Labels and Selectors
* Namespaces
* Declarative resource management

📁 [`01-Foundamentals`](./milestones/06-kubernetes/01-Foundamentals)

## Services and Networking

* Services
* ClusterIP
* NodePort
* DNS
* Service Discovery
* Pod-to-Pod communication

📁 [`02-services-networking`](./milestones/06-kubernetes/02-services-networking)

## Configuration Management

* ConfigMaps
* Secrets
* Environment variables
* Configuration injection
* Configuration from files

📁 [`03-configuration`](./milestones/06-kubernetes/03-configuration)

## Security and RBAC

* Authentication
* Authorization
* Roles
* RoleBindings
* Namespace isolation
* Permission troubleshooting

📁 [`04-security-RBAC`](./milestones/06-kubernetes/04-security-RBAC)

## Troubleshooting

Real issues encountered during hands-on cluster operation are documented instead of being discarded.

Examples include:

* Node `NotReady` conditions
* Calico Pod Sandbox failures
* DNS resolution failures
* RBAC permission issues
* Kubernetes API and client errors

Each troubleshooting document focuses on:

```text
Problem
   ↓
Symptoms
   ↓
Investigation
   ↓
Commands Used
   ↓
Root Cause
   ↓
Resolution
   ↓
Lessons Learned
```

📁 [`05-Troubleshooting`](./milestones/06-kubernetes/05-Troubleshooting)

---

# 🧪 Kubernetes Labs

Practical labs are used to validate concepts through implementation.

Examples include:

* deployment and scaling
* service discovery
* namespace isolation
* RBAC
* configuration management
* multi-service application deployment

A multi-service application called **Dockercoins** is also used as a Kubernetes learning project.

The application includes multiple services communicating inside the cluster.

```text
                    ┌─────────────┐
                    │    Web UI   │
                    └──────┬──────┘
                           │
                 ┌─────────▼─────────┐
                 │      Worker       │
                 └────┬─────────┬────┘
                      │         │
              ┌───────▼───┐ ┌──▼────────┐
              │    RNG    │ │  Hasher   │
              └───────────┘ └───────────┘
                      │
                      ▼
                   ┌───────┐
                   │ Redis │
                   └───────┘
```

The lab covers:

* containerized microservices
* Kubernetes Deployments
* Services
* internal service discovery
* DNS
* scaling
* troubleshooting
* application connectivity

📁 [`06-labs`](./milestones/06-kubernetes/06-labs)

---

# 🏭 Kubernetes Production Concepts

The next stage focuses on production-oriented Kubernetes practices.

Planned topics include:

* resource requests and limits
* health checks
* liveness probes
* readiness probes
* persistent storage
* Ingress
* Horizontal Pod Autoscaling
* rolling updates
* deployment strategies
* high availability
* production troubleshooting

📁 [`07-kubernetes-production`](./milestones/07-kubernetes-production)

---

# 🌍 Infrastructure as Code

Infrastructure will progressively move from manual configuration toward reproducible Infrastructure as Code.

Terraform will be used to provision and manage infrastructure.

The structure separates:

```text
terraform/
│
├── modules/
│
└── environments/
    ├── dev/
    ├── staging/
    └── prod/
```

The objective is to build reusable infrastructure components while maintaining clear separation between environments.

Expected infrastructure components include:

* networking
* compute
* Kubernetes infrastructure
* databases
* IAM
* load balancing
* security configuration

📁 [`terraform`](./terraform)

---

# 🔄 CI/CD

The CI/CD milestone focuses on automating the software delivery lifecycle.

Planned tools include:

* GitHub Actions
* GitLab CI/CD
* Jenkins

Typical pipeline stages will include:

```text
Code
 │
 ▼
Build
 │
 ▼
Test
 │
 ▼
Security / Validation
 │
 ▼
Container Build
 │
 ▼
Image Registry
 │
 ▼
Deployment
 │
 ▼
Verification
```

The goal is to compare different CI/CD platforms while understanding the common engineering principles behind them.

📁 [`ci-cd`](./ci-cd)

---

# 🔐 Security

Security will be integrated progressively throughout the platform.

Focus areas include:

* IAM
* Kubernetes RBAC
* Secrets management
* least privilege
* container security
* infrastructure security
* CI/CD security
* access control

The objective is to avoid treating security as a separate final step and instead integrate it into the engineering workflow.

---

# 📊 Monitoring and Observability

The monitoring milestone focuses on understanding system behavior and detecting failures.

Planned technologies include:

* Prometheus
* Grafana

Areas of focus include:

* infrastructure metrics
* container metrics
* Kubernetes metrics
* application monitoring
* dashboards
* alerting
* resource utilization
* troubleshooting through observability

📁 [`monitoring`](./monitoring)

---

# 🔁 GitOps

GitOps will be introduced to manage application and infrastructure changes declaratively.

Planned tooling includes:

* Helm
* Argo CD

The objective is to establish a workflow where:

```text
Git Repository
      │
      ▼
Declared Desired State
      │
      ▼
GitOps Controller
      │
      ▼
Kubernetes Cluster
      │
      ▼
Continuous Reconciliation
```

---

# 🏁 Final Platform

The final milestone will bring together the technologies explored throughout the repository.

The target architecture will progressively evolve toward something similar to:

```text
                    Developers
                         │
                         ▼
                    Git Repository
                         │
                         ▼
                    CI Pipeline
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
        Build           Test          Security
          │
          ▼
    Container Registry
          │
          ▼
       GitOps Flow
          │
          ▼
    Kubernetes Platform
          │
     ┌────┼───────────┐
     ▼    ▼           ▼
    Dev  Staging      Prod
     │     │           │
     └─────┴───────────┘
               │
               ▼
        Monitoring Stack
               │
               ▼
     Prometheus + Grafana
```

This final platform is intended to demonstrate how the different components of the DevOps lifecycle work together.

📁 [`milestones/12-final-plateform`](./milestones/12-final-plateform)

---

# 🛠️ Technologies

| Area                    | Technologies / Concepts               |
| ----------------------- | ------------------------------------- |
| Operating Systems       | Linux                                 |
| Version Control         | Git, GitHub                           |
| Containers              | Docker, Docker Compose                |
| Web                     | Nginx                                 |
| Cloud                   | AWS                                   |
| AWS Services            | EC2, IAM, S3, VPC, ALB, RDS, ECR, EKS |
| Container Orchestration | Kubernetes                            |
| Kubernetes Networking   | Services, DNS, Service Discovery      |
| Kubernetes Security     | RBAC, Namespace Isolation             |
| Infrastructure as Code  | Terraform                             |
| CI/CD                   | GitHub Actions, GitLab CI/CD, Jenkins |
| Monitoring              | Prometheus, Grafana                   |
| GitOps                  | Helm, Argo CD                         |
| Scripting               | Bash                                  |
| Databases               | MySQL / relational database concepts  |

> The list above represents technologies currently being practiced as well as technologies planned in the upcoming milestones. Each milestone documents the implementation and progress made over time.

---

# 📚 Engineering Documentation

This repository does not only contain code.

The `docs/` directory is used to document engineering decisions, incidents, troubleshooting processes, and lessons learned.

```text
docs/
├── architecture/
├── decisions/
├── learning-notes/
├── troubleshooting/
├── decisions.md
├── incidents.md
└── lesson-learned.md
```

The purpose is to document the reasoning behind the implementation.

For example:

### Architecture

Documents describing how components interact.

### Decisions

Records explaining technical choices and trade-offs.

### Incidents

Documents describing failures encountered during implementation or operation.

### Troubleshooting

Step-by-step investigations of real technical problems.

### Lessons Learned

Knowledge extracted from successful implementations and failures.

---

# 🔍 Troubleshooting Philosophy

Failures are treated as part of the project.

Instead of simply fixing an issue and moving on, important incidents are documented to create reusable engineering knowledge.

The process generally follows:

```text
Observe
   ↓
Collect Evidence
   ↓
Form Hypothesis
   ↓
Test
   ↓
Identify Root Cause
   ↓
Implement Fix
   ↓
Validate
   ↓
Document
```

Examples of tools used during troubleshooting include:

```bash
kubectl get
kubectl describe
kubectl logs
kubectl exec
kubectl rollout status
kubectl auth can-i

journalctl
systemctl

ip
ss
ping
curl
dig
nslookup
```

The objective is to develop troubleshooting skills rather than relying exclusively on predefined solutions.

---

# 🧠 Repository Philosophy

This project follows several principles.

## Learn by building

Concepts are validated through practical implementation.

## Understand before memorizing

Commands and tools are not treated as isolated syntax.

The focus is on understanding:

```text
What is happening?
Why is it happening?
Which component is involved?
How can it be verified?
How can it be fixed?
```

## Document real failures

Troubleshooting documentation is considered part of the engineering work.

## Prefer reproducibility

Manual steps should progressively be replaced by:

* scripts
* manifests
* Infrastructure as Code
* automated pipelines
* declarative configuration

## Build progressively

The platform evolves milestone by milestone instead of attempting to build everything at once.

---

# 📈 Current Progress

| Milestone               | Status         |
| ----------------------- | -------------- |
| Foundations             | 🟡 In Progress |
| Linux                   | 🟢 Practiced   |
| Git                     | 🟢 Practiced   |
| Docker                  | 🟢 Practiced   |
| AWS CLI                 | 🟡 In Progress |
| AWS Networking          | 🟡 In Progress |
| Kubernetes Fundamentals | 🟢 Active      |
| Kubernetes Production   | 🔵 Planned     |
| Terraform               | 🔵 Planned     |
| CI/CD                   | 🔵 Planned     |
| Security                | 🔵 Planned     |
| Monitoring              | 🔵 Planned     |
| Final Platform          | 🔵 Planned     |

Legend:

* 🟢 Implemented / actively practiced
* 🟡 In progress
* 🔵 Planned

---

# 📂 How to Navigate This Repository

If you are reviewing this repository as a recruiter:

Start here:

1. Read this README for the project overview.
2. Explore the `milestones/` directory to see the learning progression.
3. Review `kubernetes/` for Kubernetes manifests.
4. Review `terraform/` for Infrastructure as Code.
5. Review `ci-cd/` for pipeline implementations.
6. Review `docs/troubleshooting/` and Kubernetes troubleshooting documentation for real problem-solving examples.
7. Review `docs/decisions/` to understand technical reasoning.

If you are reviewing this repository as an engineer:

The most relevant areas are likely:

```text
kubernetes/
terraform/
ci-cd/
monitoring/
scripts/
docs/architecture/
docs/decisions/
docs/troubleshooting/
```

---

# 🎯 What This Repository Demonstrates

This repository is intended to demonstrate practical experience and continuous development in:

* Linux administration
* infrastructure fundamentals
* cloud operations
* AWS services
* Docker and containerization
* multi-container applications
* Kubernetes
* Kubernetes networking
* Kubernetes RBAC
* declarative infrastructure
* troubleshooting distributed systems
* Infrastructure as Code
* CI/CD automation
* monitoring and observability
* GitOps
* technical documentation

More importantly, the project focuses on the ability to connect these technologies into a complete engineering workflow.

---

# 🗺️ Roadmap

The detailed learning and implementation roadmap is available here:

📁 [`Roadmap.md`](./Roadmap.md)

The repository will continue to evolve as new milestones are completed.

---

# 👤 About Me

I am an IT professional transitioning toward DevOps and Cloud Engineering through a structured, hands-on learning path.

My background includes IT support, system administration, Windows and Linux environments, networking, virtualization, and infrastructure operations.

This repository documents the practical progression from traditional infrastructure operations toward modern DevOps practices, cloud infrastructure, automation, container orchestration, Infrastructure as Code, CI/CD, and observability.

The objective is to develop the ability to not only deploy systems, but also understand, automate, troubleshoot, monitor, and continuously improve them.

---

# 📫 Connect

* GitHub: `https://github.com/Tovokely2424`
* LinkedIn: *To be added*

---

## Continuous Evolution

This repository is actively evolving.

Each milestone represents practical work, experiments, troubleshooting, documentation, and lessons learned.

The objective is simple:

> **Build it. Break it. Understand it. Fix it. Automate it. Document it.**

---

**This repository is a living engineering portfolio.**