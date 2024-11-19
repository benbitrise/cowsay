#!/usr/bin/env bash

if [ -z "$BITRISE_TOKEN" ]; then
  echo "Error: BITRISE_TOKEN is not set."
  exit 1
fi

if [ -z "$CUSTOMER_BRANCH" ]; then
  echo "Error: CUSTOMER_BRANCH is not set."
  exit 1
fi

if [ -z "$BITRISE_WORKSPACE" ]; then
  echo "Error: BITRISE_WORKSPACE is not set."
  exit 1
fi

curl -s -X 'POST' \
  'https://api.bitrise.io/v0.1/apps/register' \
  -H 'accept: application/json' \
  -H "Authorization: $BITRISE_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "default_branch_name": "'"${CUSTOMER_BRANCH}"'",
  "is_public": false,
  "manual_approval_enabled": false,
  "organization_slug": "'"${BITRISE_WORKSPACE}"'",
  "provider": "github-app",
  "repo_url": "https://github.com/benbitrise/cowsay.git",
  "title": "App for '"${CUSTOMER_BRANCH}"'"
}'

new_app_slug=$(curl -s -X 'POST' \
  'https://api.bitrise.io/v0.1/apps/register' \
  -H 'accept: application/json' \
  -H "Authorization: $BITRISE_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "default_branch_name": "'"${CUSTOMER_BRANCH}"'",
  "is_public": false,
  "manual_approval_enabled": false,
  "organization_slug": "'"${BITRISE_WORKSPACE}"'",
  "provider": "github-app",
  "repo_url": "https://github.com/benbitrise/cowsay.git",
  "title": "App for '"${CUSTOMER_BRANCH}"'"
}' | jq -r '.slug')

echo "New App Slug: $new_app_slug"

curl -s -X 'POST' \
  "https://api.bitrise.io/v0.1/apps/${new_app_slug}/finish" \
  -H 'accept: application/json' \
  -H "Authorization: $BITRISE_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "config": "other-config",
  "mode": "manual",
  "organization_slug": "'"${BITRISE_WORKSPACE}"'",
  "project_type": "other",
  "stack_id": "linux-docker-android-22.04"
}' #> /dev/null

curl -s -X 'PUT' \
  "https://api.bitrise.io/v0.1/apps/${new_app_slug}/bitrise.yml/config" \
  -H 'accept: application/json' \
  -H "Authorization: $BITRISE_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "location": "repository"
}' #> /dev/null


echo "Add Apple Connection at https://app.bitrise.io/app/${new_app_slug}/settings/integrations?tab=stores"
open -a Firefox "https://app.bitrise.io/app/${new_app_slug}/settings/integrations?tab=stores"