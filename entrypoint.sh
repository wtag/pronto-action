#!/bin/sh -l

set -eo pipefail

SHA=$(jq --raw-output .head_commit.id "${GITHUB_EVENT_PATH}")
OWNER=$(jq --raw-output .repository.owner.name "${GITHUB_EVENT_PATH}")
REPO=$(jq --raw-output .repository.name "${GITHUB_EVENT_PATH}")
HEAD_COMMIT_PULLS_URL="https://api.github.com/repos/${OWNER}/${REPO}/commits/${SHA}/pulls"
PULL_IDS=$(curl -H "Accept: application/vnd.github.groot-preview+json" -H "Authorization: token ${ACTIONS_RUNTIME_TOKEN}" $HEAD_COMMIT_PULLS_URL | jq --raw-output .[].number)
PRONTO_GITHUB_ACCESS_TOKEN="${ACTIONS_RUNTIME_TOKEN}"

if [ -z "${PULL_IDS}" ]; then
  echo "No pull request found, bailing out"
  exit 0
fi

gem install --no-document \
  pronto \
  pronto-rubocop \
  pronto-flay \
  pronto-brakeman \
  pronto-rails_best_practices \
  pronto-rails_schema \
  pronto-reek \
  pronto-scss

git fetch --unshallow

for PULL_ID in $PULL_IDS; do
  PRONTO_PULL_REQUEST_ID=$PULL_ID pronto run -f github_status github_pr -c origin/master
done
