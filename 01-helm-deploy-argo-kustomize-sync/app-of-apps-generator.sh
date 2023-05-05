#!/bin/bash

# Create the Kustomize repository directory structure
mkdir -p kustomize-repo/base
mkdir -p kustomize-repo/overlays/app-of-apps

# Create the base kustomization.yaml file
cat <<EOF > kustomize-repo/base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: []
EOF

# Create the app-of-apps overlay kustomization.yaml file
cat <<EOF > kustomize-repo/overlays/app-of-apps/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
bases:
  - ../../base
resources: []
EOF

# Clone the repository containing repos.txt and the values folder
git clone https://github.com/example/super-repo.git
# Replace with the actual URL of the Git repository containing repos.txt and the values folder

# Go to the cloned repository directory containing repos.txt
cd repos-list

# Read the list of repositories, tags, and deployment names from repos.txt
while IFS=' ' read -r repo tag deployment_name; do
  # Extract the repo name from the URL
  repo_name=$(basename "$repo" .git)

  # Read the contents of the values override file
  values_content=$(cat "values/${deployment_name}.yaml" | sed 's/"/\\"/g' | sed 's/^/        /')

  # Generate the Application resource for the current deployment
  cat <<EOF > "../kustomize-repo/overlays/app-of-apps/${deployment_name}-application.yaml"
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${deployment_name}
spec:
  project: default
  source:
    repoURL: ${repo}
    targetRevision: ${tag}
    path: ${repo_name}
    helm:
      releaseName: ${deployment_name}
      valueFiles:
        - values.yaml
      values: |
${values_content}
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

  # Add the generated Application resource to the Kustomization resources list
  echo "resources:" >> "../kustomize-repo/overlays/app-of-apps/kustomization.yaml"
  echo "- ${deployment_name}-application.yaml" >> "../kustomize-repo/overlays/app-of-apps/kustomization.yaml"

done < repos.txt

# Go back to the script's initial directory
cd ..
