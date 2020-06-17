#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly CT_IMAGE=${CHART_TESTING_IMAGE}
readonly CT_VERSION=${CHART_TESTING_TAG}
readonly KIND_VERSION=${KIND_VERSION}
readonly CLUSTER_NAME=chart-testing
readonly K8S_VERSION=${K8S_VERSION}

lint_charts() {
    echo
    echo "Starting charts linting..."
    mkdir -p tmp
    docker run --rm -v "$(pwd):/workdir" --workdir /workdir "${CT_IMAGE}:$CT_VERSION" ct lint --config /workdir/test/ct.yaml | tee tmp/lint.log || true
    echo "Done Charts Linting!"

    if grep -q "No chart changes detected" tmp/lint.log  > /dev/null; then
        echo "No chart changes detected!"
        exit 0
    elif grep -q "Error linting charts" tmp/lint.log  > /dev/null; then
        echo "Error linting charts!!!"
        exit 1
    else
        install_charts
    fi
}

run_ct_container() {
    echo 'Running ct container...'
    docker run --rm --interactive --detach --network host --name ct \
        --volume "$(pwd)/test/ct.yaml:/etc/ct/ct.yaml" \
        --volume "$(pwd):/workdir" \
        --workdir /workdir \
        "${CT_IMAGE}:$CT_VERSION" \
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

create_kind_cluster() {
    echo 'Installing kind...'

    curl -sSLo kind "https://github.com/kubernetes-sigs/kind/releases/download/$KIND_VERSION/kind-linux-amd64"
    chmod +x kind
    sudo mv kind /usr/local/bin/kind

    kind create cluster --name "$CLUSTER_NAME" --image "kindest/node:$K8S_VERSION" --wait 60s
    ### kind create cluster --name "$CLUSTER_NAME" --config test/kind-config.yaml --image "kindest/node:$K8S_VERSION" --wait 60s

    echo 'Copying kubeconfig to ct container...'
    kind get kubeconfig > /tmp/kubeconfig
    docker cp /tmp/kubeconfig ct:/root/.kube/config
    docker_exec cat /root/.kube/config
    docker_exec kubectl cluster-info
    echo

    docker_exec kubectl get nodes
    echo

    echo 'Cluster ready!'
    echo
}

install_charts() {
    docker_exec ct install --config /workdir/test/ct.yaml
    echo
}

install_charts() {
    echo "Starting charts install testing..."
    run_ct_container
    trap cleanup EXIT

    create_kind_cluster
    install_charts
}

main() {
    install_charts
}

main
