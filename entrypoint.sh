#!/bin/sh -l

set -eo pipefail

export PRONTO_GITHUB_ACCESS_TOKEN="${1}"

curlGH() {
  curl --silent -H "Accept: application/vnd.github.groot-preview+json" -H "Authorization: token ${PRONTO_GITHUB_ACCESS_TOKEN}" ${@}
}

SHA=$(jq --raw-output .head_commit.id "${GITHUB_EVENT_PATH}")
OWNER=$(jq --raw-output .repository.owner.name "${GITHUB_EVENT_PATH}")
REPO=$(jq --raw-output .repository.name "${GITHUB_EVENT_PATH}")
HEAD_COMMIT_PULLS_URL="https://api.github.com/repos/${OWNER}/${REPO}/commits/${SHA}/pulls"
PULL_IDS=$(curlGH $HEAD_COMMIT_PULLS_URL | jq --raw-output .[].number)

if [ -z "${PULL_IDS}" ]; then
  echo "No pull request found, bailing out"
  exit 0
else
  echo "Running pronto for PRs ${PULL_IDS}"
fi

git fetch --unshallow

for PULL_ID in $PULL_IDS; do
  REF=$(curlGH "https://api.github.com/repos/${OWNER}/${REPO}/pulls/${PULL_ID}" | jq --raw-output .base.ref)
  PRONTO_PULL_REQUEST_ID=$PULL_ID /usr/local/bundle/bin/pronto run -f github_status github_pr -c "origin/${REF}"
done
