#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"

main() {
    git remote add k8s "${CHARTS_REPO}" &> /dev/null || true
    git fetch k8s master
    
    mkdir -p tmp
    docker run --rm -v "$(pwd):/workdir" --workdir /workdir "$CHART_TESTING_IMAGE:$CHART_TESTING_TAG" ct lint --config /workdir/.test/ct.yaml

    echo "Done Charts Linting!"
}

main
