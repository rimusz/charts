#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly IMAGE_TAG=${CHART_TESTING_TAG}
readonly IMAGE_REPOSITORY=${CHART_TESTING_IMAGE}

main() {
    local testcontainer_id
    testcontainer_id=$(create_testcontainer)

    # shellcheck disable=SC2064
    trap "docker container rm --force $testcontainer_id > /dev/null" EXIT

    configure_kubectl "$testcontainer_id"
    run_test
}

lookup_apiserver_container_id() {
    docker container list --filter name=k8s_kube-apiserver --format '{{ .ID }}'
}

get_apiserver_arg() {
    local container_id="$1"
    local arg="$2"
    docker container inspect "$container_id" | jq -r ".[].Args[] | capture(\"$arg=(?<arg>.*)\") | .arg"
}

create_testcontainer() {
    docker container run --interactive --tty --detach \
        --volume "$(pwd):/workdir" --workdir /workdir \
        "$IMAGE_REPOSITORY:$IMAGE_TAG" cat
}

configure_kubectl() {
    local testcontainer_id="$1"

    local apiserver_id
    apiserver_id=$(lookup_apiserver_container_id)

    if [[ -z "$apiserver_id" ]]; then
        echo "ERROR: API-Server container not found. Make sure 'Show system containers' is enabled in Docker4Mac 'Preferences'!" >&2
        exit 1
    fi

    local ip
    ip=$(get_apiserver_arg "$apiserver_id" --advertise-address)

    local port
    port=$(get_apiserver_arg "$apiserver_id" --secure-port)

    docker cp "$HOME/.kube" "$testcontainer_id:/root/.kube"
    docker exec "$testcontainer_id" kubectl config set-cluster docker-desktop "--server=https://$ip:$port"
    docker exec "$testcontainer_id" kubectl config set-cluster docker-desktop --insecure-skip-tls-verify=true
    docker exec "$testcontainer_id" kubectl config use-context docker-desktop
}

run_test() {
    git remote add k8s "${CHARTS_REPO}" &> /dev/null || true
    git fetch k8s
    docker exec "$testcontainer_id" ct install --chart-dirs stable,incubator --remote k8s
}

main
