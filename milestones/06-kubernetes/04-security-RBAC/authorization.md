# Kubernetes RBAC Authorization

## Objective

Implement namespace-level access control for a development user and another for testers user.

## Scenario

A developer should be able to manage workloads inside `dev-ns`,
but must not have access to cluster-wide resources.

At the same level, testers should be able te access worklods , logs and resources inside `stagin-ns`only.

## Architecture

- Namespace: `dev-ns`
- User: `admin-dev`
- Group: `developers`
- Role: `dev-role`
- RoleBinding: `dev-rolebinding`

- Namespace: `staging-ns`
- User: `admin-staging`
- Group: `testers`
- Role: `staging-role`
- RoleBinding: `staging-rolebinding`

## Requirements

The developer must be able to:

- View Pods
- Manage Deployments
- Scale Deployments

The developer must NOT be able to:

- Access Nodes
- Access resources outside `dev-ns`
- Perform cluster-wide administrative operations

## Implementation

...

## Validation

...

## Lessons Learned

RBAC permissions are resource and namespace scoped.
Actions such as scaling a Deployment may require permissions on
subresources such as `deployments/scale`.