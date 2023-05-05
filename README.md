# Helm Deployment, Argo Redeployment Experimentation

This repository demonstrates the deployment of a Helm deployment based on ArgoCD resources, then an Argo deployment. This is meant to demonstrate scenarios where a Helm deployment of a tracked resource may have already been completed or is necessary to avoid race conditions between different Kubernetes operators, and where it would be most ideal to propagate changes between the two.

This whole set-up is not ideal since a fully automated Argo deployment would be preferred instead of manually defining a Helm deployment.
