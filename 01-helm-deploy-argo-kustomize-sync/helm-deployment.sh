#!/bin/bash

# Clone the repository containing repos.txt
git clone https://github.com/example/super-repo.git

# Change to the cloned repository directory
cd repos-list

# Check if repos.txt file exists
if [ ! -f "repos.txt" ]; then
  echo "repos.txt file not found."
  exit 1
fi

# Read the list of repositories, tags, and deployment names from repos.txt
while IFS=' ' read -r repo tag deployment_name; do
  # Extract the repo name from the URL
  repo_name=$(basename "$repo" .git)

  # Clone the repository and overwrite existing directory
  git clone --force "$repo" "$repo_name"

  # Change to the repository directory
  cd "$repo_name"

  # Checkout the specified tag
  git checkout "$tag"

  # Find the Helm Chart directory
  chart_dir=$(find . -name "Chart.yaml" -exec dirname {} \;)

  # Go to the chart directory
  cd "$chart_dir"

  # Install the chart with the specified deployment name
  helm install "$deployment_name" .

  # Go back to the script's initial directory and remove the cloned repo
  cd ../..
  rm -rf "$repo_name"

done < repos.txt

# Go back to the script's initial directory and remove the repos-list directory
cd ..
rm -rf repos-list
