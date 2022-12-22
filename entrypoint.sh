#!/bin/sh -l

set -eo pipefail
time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT
