#!/usr/bin/env bash

set -euo pipefail

ORG=jatilab
TFVARS_FILE="terraform.tfvars"
TFVARS_FILE_EXAMPLE="terraform.tfvars.example"

if [[ ! -f "$TFVARS_FILE" ]]; then
  if [[ ! -f "$TFVARS_FILE_EXAMPLE" ]]; then
    echo "Error: Neither '$TFVARS_FILE' nor '$TFVARS_FILE_EXAMPLE' exists." >&2
    exit 1
  fi

  cp "$TFVARS_FILE_EXAMPLE" "$TFVARS_FILE"
  echo "Created $TFVARS_FILE from $TFVARS_FILE_EXAMPLE"
fi

TOKEN=$(
  gh api \
    -X POST \
    "/orgs/${ORG}/actions/runners/registration-token" \
    --jq .token
)

case "$(uname -s)" in
  Darwin)
    sed -i '' \
      "s|^gh_runner_token   = \".*\"|gh_runner_token   = \"$TOKEN\"|" \
      "$TFVARS_FILE"
    ;;
  Linux)
    sed -i \
      "s|^gh_runner_token   = \".*\"|gh_runner_token   = \"$TOKEN\"|" \
      "$TFVARS_FILE"
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

echo "Updated gh_runner_token in ${TFVARS_FILE}"
