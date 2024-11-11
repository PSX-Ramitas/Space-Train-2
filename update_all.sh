#!/bin/bash

# Fetch all updates from remote repositories
git fetch --all

# Loop through each local branch
for branch in $(git branch --format '%(refname:short)'); do
  echo "Pulling updates for branch: $branch"
  
  # Checkout the branch
  git checkout "$branch"
  
  # Pull the latest changes from the corresponding remote branch
  git pull origin "$branch"
done

# Optionally, checkout back to the original branch (optional)
# git checkout <your-original-branch>

