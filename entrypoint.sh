#!/bin/sh -l

set -eo pipefail

export PRONTO_GITHUB_ACCESS_TOKEN="${1}"
export GITHUB_REPO_FROM_ENV="${2}"
export GITHUB_SHA_FROM_ENV="${3}"

echo 'Start Printing GH ENV variables'
echo $GITHUB_EVENT_NAME
echo $GITHUB_REPOSITORY
echo $GITHUB_SHA

curlGH() {
  curl --silent -H "Accept: application/vnd.github.groot-preview+json" -H "Authorization: token ${PRONTO_GITHUB_ACCESS_TOKEN}" ${@}
}

SHA=$(jq --raw-output .head_commit.id "${GITHUB_EVENT_PATH}")
OWNER=$(jq --raw-output .repository.owner.name "${GITHUB_EVENT_PATH}")
REPO=$(jq --raw-output .repository.name "${GITHUB_EVENT_PATH}")
HEAD_COMMIT_PULLS_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/commits/${GITHUB_SHA}/pulls"

echo $GITHUB_EVENT_PATH
echo $SHA
echo $OWNER
echo $REPO
echo $HEAD_COMMIT_PULLS_URL

echo $GITHUB_REPO_FROM_ENV
echo $GITHUB_SHA_FROM_ENV

echo "Attempting to print directly the repository value"

REPO_INFO=github.repository
echo $REPO_INFO

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
