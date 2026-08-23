# Kubernetes Milestone

This milestone documents my hands-on Kubernetes learning journey through the deployment, operation, troubleshooting, security and progressive hardening of Kubernetes workloads.

The objective is not only to learn Kubernetes commands and resource definitions, but to understand how Kubernetes is used to deploy, operate, scale, secure and troubleshoot distributed applications.

---

## Environment

* Ubuntu Server
* MicroK8s
* Kubernetes
* kubectl
* Docker
* Linux
* Git / GitHub

---

# Flagship Learning Project — Dockercoins

Throughout this milestone, I use **Dockercoins** as the main practical project for learning Kubernetes.

Dockercoins is a small microservices-based application originally designed to run with Docker Compose. It is part of the training material from [container.training](https://github.com/jpetazzo/container.training).

The application uses multiple services implemented with different technologies, including Python, JavaScript and Ruby, with Redis used as part of the application architecture.

The original project provides a Docker Compose deployment. As part of this milestone, I progressively migrate and operate the application on Kubernetes.

## Objective

The goal is not simply to convert a Docker Compose file into Kubernetes manifests.

The objective is to understand how Kubernetes concepts solve real operational problems in a distributed application:

```text
Docker Compose
      ↓
Kubernetes workloads
      ↓
Services & networking
      ↓
Service discovery & DNS
      ↓
Configuration & Secrets
      ↓
Scaling
      ↓
Security & RBAC
      ↓
Troubleshooting
      ↓
Storage
      ↓
Ingress
      ↓
Production-oriented practices
```

---

# Dockercoins Architecture

The application is composed of several microservices communicating with each other.

```text
                         ┌──────────────┐
                         │    Web UI    │
                         │   Frontend   │
                         └───────┬──────┘
                                 │
                                 ▼
                         ┌──────────────┐
                         │    Hasher    │
                         │   Service    │
                         └───────┬──────┘
                                 │
                                 ▼
                         ┌──────────────┐
                         │    Redis     │
                         │    Storage   │
                         └──────────────┘

                         ┌──────────────┐
                         │    Worker    │
                         │   Service    │
                         └───────┬──────┘
                                 │
                                 ▼
                         ┌──────────────┐
                         │     RNG      │
                         │   Service    │
                         └──────────────┘
```

The Kubernetes implementation progressively introduces:

* Pods
* Deployments
* ReplicaSets
* Services
* ClusterIP
* NodePort
* Kubernetes DNS
* ConfigMaps
* Secrets
* Horizontal scaling
* Namespace isolation
* RBAC
* Resource management
* Networking
* Troubleshooting
* Storage
* Ingress

---

# Docker Compose → Kubernetes

One of the main objectives of the project is to understand how a multi-container Docker Compose application maps to Kubernetes concepts.

| Docker Compose        | Kubernetes                                                   |
| --------------------- | ------------------------------------------------------------ |
| Service               | Deployment + Service                                         |
| Container             | Container inside a Pod                                       |
| Replicas              | Deployment replicas                                          |
| Container network     | Kubernetes networking                                        |
| Service name          | Kubernetes Service DNS                                       |
| Environment variables | ConfigMap / Secret                                           |
| Volume                | Volume / PersistentVolumeClaim                               |
| Port mapping          | Kubernetes Service                                           |
| `depends_on`          | Kubernetes readiness / application-level dependency handling |

The migration is performed progressively rather than as a simple one-to-one conversion.

This allows me to understand the architectural differences between Docker Compose and Kubernetes.

---

# Progress

| Domain                     | Status         |
| -------------------------- | -------------- |
| Kubernetes fundamentals    | 🟢 Completed   |
| Pods & workloads           | 🟢 Completed   |
| Deployments & ReplicaSets  | 🟢 Completed   |
| Services & networking      | 🟢 In progress |
| Service discovery & DNS    | 🟢 Completed   |
| Configuration / ConfigMaps | 🟡 In progress |
| Secrets                    | 🟡 In progress |
| Scaling                    | 🟢 Completed   |
| RBAC & security            | 🟢 Completed   |
| Troubleshooting            | 🟢 In progress |
| Storage                    | 🔴 Not started |
| Ingress                    | 🔴 Not started |
| Helm                       | 🔴 Not started |
| GitOps / Argo CD           | 🔴 Not started |

---

# Skills Demonstrated

* Deploy and manage Kubernetes workloads
* Work with Pods, Deployments and ReplicaSets
* Scale workloads horizontally
* Configure and expose applications using Kubernetes Services
* Implement Kubernetes service discovery
* Troubleshoot Kubernetes DNS and networking issues
* Manage application configuration using ConfigMaps
* Manage sensitive configuration using Secrets
* Mount ConfigMaps as files
* Inject configuration through environment variables
* Work with namespaces and resource isolation
* Implement namespace-level RBAC
* Diagnose Pod lifecycle and container startup failures
* Investigate Kubernetes Events
* Analyze container logs
* Troubleshoot application-level and infrastructure-level failures
* Use `kubectl` for Kubernetes administration and troubleshooting

---

# Configuration Management

Configuration is progressively separated from application containers using Kubernetes ConfigMaps and Secrets.

Examples include:

* Environment variables
* Application configuration
* Nginx configuration templates
* Runtime configuration
* Sensitive credentials
* API keys

Example architecture:

```text
                 Kubernetes
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
   ConfigMap      Secret      ConfigMap
   Application    Credentials   Template
   Configuration
        │            │            │
        └────────────┼────────────┘
                     ▼
                    Pod
                     │
                     ▼
                Application
```

Configuration is kept separate from the container image so that the same application image can be used across different environments.

---

# Security & RBAC

Kubernetes RBAC is used to understand namespace-level access control and resource permissions.

Topics covered:

* Users and contexts
* Namespaces
* Roles
* RoleBindings
* Authorization
* Namespace isolation
* Resource-level permissions
* Testing access using `kubectl auth can-i`

Practical case study:

* [RBAC namespace isolation](./04-security-rbac/authorization.md)

---

# Troubleshooting

A major objective of this milestone is learning how to troubleshoot Kubernetes systematically.

The troubleshooting methodology follows a progressive approach:

```text
Application symptoms
        ↓
Pod status
        ↓
kubectl describe
        ↓
Events
        ↓
Container logs
        ↓
Service
        ↓
Endpoints
        ↓
DNS resolution
        ↓
Network connectivity
        ↓
Node
        ↓
CNI / Kubernetes components
```

Each significant troubleshooting case is documented with:

* Symptoms
* Error messages
* Investigation commands
* Evidence
* Root cause
* Resolution
* Validation
* Lessons learned

---

# Practical Case Studies

## Security & RBAC

* [RBAC namespace isolation](./04-security-rbac/authorization.md)

## Networking & Infrastructure

* [Calico Pod Sandbox failure](./05-troubleshooting/calico-pod-sandbox.md)
* [Kubernetes DNS troubleshooting](./05-troubleshooting/dns-resolution.md)

## Configuration

* ConfigMap-based application configuration
* ConfigMap volume mounts
* Environment variable injection
* Nginx configuration templating with `envsubst`
* Kubernetes Secrets

Additional configuration case studies will be documented as the project progresses.

---

# Labs

* [Deployment scaling](./06-labs/lab-01-deployment-scaling.md)
* [Service discovery](./06-labs/lab-02-service-discovery.md)
* [RBAC isolation](./06-labs/lab-03-rbac-isolation.md)
* Docker Compose to Kubernetes migration
* Microservices communication
* ConfigMap and Secret management
* Kubernetes DNS troubleshooting
* Application scaling
* Service and endpoint troubleshooting

---

# Dockercoins Implementation

The Dockercoins implementation is maintained separately from the production-oriented application.

```text
dockercoins/
├── docker-compose/
│   └── docker-compose.yml
│
└── kubernetes/
    ├── deployments/
    ├── services/
    ├── configmaps/
    ├── secrets/
    └── ...
```

The Kubernetes implementation will evolve as new Kubernetes concepts are introduced.

---

# Kubernetes Production

The `kubernetes-production/` section applies the Kubernetes knowledge developed throughout this milestone to the **Hotel Booking Application**.

Dockercoins is used as the learning and experimentation environment, while the Hotel Booking Application is used to demonstrate a more realistic production-oriented Kubernetes architecture.

The production project will progressively integrate:

* Kubernetes
* Frontend and backend deployments
* Kubernetes Services
* Database architecture
* ConfigMaps
* Secrets
* Health checks
* Liveness and readiness probes
* Resource requests and limits
* Persistent storage
* Ingress
* Helm
* CI/CD
* AWS infrastructure
* Monitoring
* Prometheus
* Grafana
* GitOps
* Argo CD

The separation between the two projects allows this milestone to demonstrate both:

### 1. Kubernetes Learning & Troubleshooting

**Dockercoins**

A controlled microservices environment used to experiment with Kubernetes concepts, intentionally introduce failures and develop troubleshooting skills.

### 2. Production-Oriented Implementation

**Hotel Booking Application**

A more realistic application used to apply Kubernetes concepts to an end-to-end DevOps project.

---

# Learning Philosophy

This milestone follows a practical learning approach:

```text
Learn
  ↓
Implement
  ↓
Break
  ↓
Troubleshoot
  ↓
Understand
  ↓
Document
  ↓
Apply to a real application
```

The objective is to develop not only Kubernetes administration skills, but also the ability to understand application behavior, identify failures and systematically determine their root causes.

---

# Future Goals

The Kubernetes milestone will progressively evolve toward:

```text
Kubernetes Fundamentals
        ↓
Networking
        ↓
Configuration
        ↓
Security
        ↓
Storage
        ↓
Ingress
        ↓
Helm
        ↓
Monitoring
        ↓
CI/CD
        ↓
GitOps
        ↓
Production Kubernetes
```

The final objective is to demonstrate the ability to deploy, operate, secure, troubleshoot and automate Kubernetes-based applications in a production-oriented environment.
