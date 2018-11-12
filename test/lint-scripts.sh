#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly IMAGE_REPOSITORY="koalaman/shellcheck-alpine"

main() {
    echo
    echo "Run shell scripts linting!"
    echo

    docker run --rm -v "$(pwd):/workdir" --workdir /workdir "$IMAGE_REPOSITORY" shellcheck -x test/lint-charts.sh
    docker run --rm -v "$(pwd):/workdir" --workdir /workdir "$IMAGE_REPOSITORY" shellcheck -x .scripts/repo-sync.sh
    echo "Done Scripts Linting!"
}

main
