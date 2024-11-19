#!/usr/bin/env bash

if [ -z "$BITRISE_TOKEN" ]; then
  echo "Error: BITRISE_TOKEN is not set."
  exit 1
fi

if [ -z "$BUNDLE_ID" ]; then
  echo "Error: BUNDLE_ID is not set."
  exit 1
fi

if [ -z "$BITRISE_WORKSPACE" ]; then
  echo "Error: BITRISE_WORKSPACE is not set."
  exit 1
fi

if [ -z "$CI_PROJECT_SLUG" ]; then
  echo "Error: CI_PROJECT_SLUG is not set."
  exit 1
fi

curl -X 'PUT' \
  "https://api.bitrise.io/release-management/v1/connected-apps/$(uuidgen)" \
  -H 'accept: application/json' \
  -H "Authorization: $BITRISE_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
  "bitrise_project_slug": "'"${CI_PROJECT_SLUG}"'",
  "manual_connection": false,
  "platform": "ios",
  "store_app_id": "'"${BUNDLE_ID}"'"
}'