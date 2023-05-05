# 01 - Helm Deployment first, Argo Kustomize Repository Generation, ArgoCD deployment

This set up contains the following:
1. A Helm deployment of repos.txt with values overrides under a remote repository.
2. A generator that creates Application resources based on the overrides provided, to be pushed onto the remote repository.

This is for the scenario where a Helm Deployment is already defined, and needs to be migrated to an ArgoCD deployment.

## Assumptions

Remote repository github.com/example/super-repo follows the following structure.

```
super-repo/
├── values/
│   └── deployment1.yaml
│   └── deployment....yaml
└── repos.txt
```

Each file should be consistent with the following:

* `repos.txt` contains Git repository addresses, revision names and deployment names.
* For each deployment name, a `deploymentname.yaml` exists in folder `values`.

## Downsides

Uses kustomize, thus not providing generation capability.