#!/bin/bash

# Variables (Update if needed)
GITHUB_USERNAME="kartikey-kumar"
REPO_NAME="crwn-clothing-kartikey"
NETLIFY_SITE_NAME="crwn-clothing-kartikey"  # Keep site name same for simplicity
BUILD_FOLDER="build"  # Change if your build folder is different
FUNCTIONS_FOLDER="functions"  # Folder where Netlify functions are stored

# 1. Initialize Git and Create GitHub Repo
echo "Initializing Git and creating GitHub repository..."
git init

# Check if GitHub CLI is authenticated
if ! gh auth status; then
  echo "GitHub CLI not authenticated. Please run 'gh auth login' and try again."
  exit 1
fi

# Create GitHub repo (Public)
gh repo create $REPO_NAME --public --confirm
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main

# 2. Fix Dependency Conflict with --legacy-peer-deps
echo "Installing dependencies with --legacy-peer-deps..."
npm install --legacy-peer-deps

# 3. Build the Project
echo "Building the project..."
npm run build  # Or change to `yarn build` if using Yarn

# 4. Deploy to Netlify (Check if Netlify CLI is authenticated)
if ! netlify status 2>/dev/null; then
  echo "Netlify CLI not authenticated. Please run 'netlify login' and try again."
  exit 1
fi

# 5. Create Netlify Site (If it doesn't exist)
echo "Creating Netlify site..."
netlify sites:create --name $NETLIFY_SITE_NAME --public || netlify link

# 6. Link the Project to Netlify
echo "Linking site to Netlify..."
netlify link --name $NETLIFY_SITE_NAME

# 7. Add Environment Variables in Netlify
echo "Setting up environment variables in Netlify..."
netlify env:set REACT_APP_API_KEY "your_api_key"
netlify env:set REACT_APP_AUTH_DOMAIN "your_auth_domain"
netlify env:set REACT_APP_PROJECT_ID "your_project_id"
netlify env:set REACT_APP_STORAGE_BUCKET "your_storage_bucket"
netlify env:set REACT_APP_MESSAGING_SENDER_ID "your_messaging_sender_id"
netlify env:set REACT_APP_APP_ID "your_app_id"

# 8. Deploy Build Folder and Functions to Netlify
echo "Deploying build and functions to Netlify..."
netlify deploy --prod --dir $BUILD_FOLDER --functions $FUNCTIONS_FOLDER

# 9. Open Netlify Dashboard
echo "Opening Netlify Dashboard..."
netlify open --site

# 10. Completion
echo "✅ Deployment complete! Your site is live."
