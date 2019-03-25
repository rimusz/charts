#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# shellcheck disable=SC2082
readonly IMAGE_TAG=${CHART_TESTING_TAG}
# shellcheck disable=SC2082
readonly IMAGE_REPOSITORY=${$CHART_TESTING_IMAGE}
readonly REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"

main() {
    git remote add k8s "${CHARTS_REPO}" &> /dev/null || true
    git fetch k8s master
    
    mkdir -p tmp
    docker run --rm -v "$(pwd):/workdir" --workdir /workdir "$IMAGE_REPOSITORY:$IMAGE_TAG" ct lint --config /workdir/.test/ct.yaml

    echo "Done Charts Linting!"
}

main
