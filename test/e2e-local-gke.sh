#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly IMAGE_REPOSITORY=${GKE_TESTING_IMAGE}
readonly IMAGE_TAG=${GKE_TESTING_TAG}
readonly REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"

run_ct_container() {
    echo 'Running ct container...'
    docker run --rm --interactive --detach --name ct \
        -v "$HOME/.config/gcloud:/root/.config/gcloud" \
        -v "$REPO_ROOT:/workdir" \
        --workdir /workdir \
        "$IMAGE_REPOSITORY:$IMAGE_TAG" \
        cat
    echo
}

cleanup() {
    echo 'Removing ct container...'
    docker kill ct > /dev/null 2>&1

    echo 'Done!'
}

docker_exec() {
    docker exec --interactive ct "$@"
}

connect_to_cluster() {
    # copy and update kubeconfig file
    docker cp "$HOME/.kube"  ct:/root/.kube
    # shellcheck disable=SC2086
    docker_exec sed -i 's|'${HOME}'||g' /root/.kube/config
    # Set to specified cluster
    if [[ -e CLUSTER ]]; then
        # shellcheck disable=SC1091
        source CLUSTER
        if [[ -n "${GKE_CLUSTER}" ]]; then
            echo
            docker_exec kubectl config use-context "${GKE_CLUSTER}"
            echo
        fi
    fi
}

install_charts() {
    echo "Add git remote k8s ${CHARTS_REPO}"
    git remote add k8s "${CHARTS_REPO}" &> /dev/null || true
    git fetch k8s master
    echo
    # shellcheck disable=SC2086
    docker_exec ct install ${CHART_TESTING_ARGS} --config /workdir/test/ct.yaml
    echo
}

main() {
    run_ct_container
    trap cleanup EXIT

    connect_to_cluster
    install_charts
}

main
