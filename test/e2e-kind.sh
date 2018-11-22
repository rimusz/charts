#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly REPO_ROOT="${REPO_ROOT:-$(git rev-parse --show-toplevel)}"

get_kind(){
    echo "Get kind binary..."
    docker run --rm -it -v "$(pwd)":/go/bin golang go get -v sigs.k8s.io/kind
    sudo mv kind /usr/local/bin/
}


run_kind() {

    echo "Create Kubernetes cluster with kind..."
    kind create cluster
}

set_kind() {

    #echo "Download kubectl..."
    #curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/"${K8S_VERSION}"/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    #echo

    echo "Copy kubectl out of the kind container..."
    tmp_path=$(mktemp -d)
    docker cp "$config_container_id":"$(docker exec "$config_container_id" which kubectl)" "${tmp_path}/kubectl" && sudo mv "${tmp_path}"/kubectl /usr/local/bin/
    echo

    echo "Export kubeconfig..."
    # shellcheck disable=SC2155
    export KUBECONFIG="$(kind get kubeconfig-path)"
    echo

    echo "Ensure the apiserver is responding..."
    kubectl cluster-info
    echo

    echo "Wait for Kubernetes to be up and ready..."
    JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until kubectl get nodes -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1; done
    echo
}

run_tillerless() {
     # -- Work around for Tillerless Helm, till Helm v3 gets released -- #
     docker exec "$config_container_id" apk add bash
     echo "Install Tillerless Helm plugin..."
     docker exec "$config_container_id" helm init --client-only
     docker exec "$config_container_id" helm plugin install https://github.com/rimusz/helm-tiller
     docker exec "$config_container_id" bash -c 'echo "Starting Tiller..."; helm tiller start-ci >/dev/null 2>&1 &'
     docker exec "$config_container_id" bash -c 'echo "Waiting Tiller to launch on 44134..."; while ! nc -z localhost 44134; do sleep 1; done; echo "Tiller launched..."'
     echo
}

main() {

    echo "Starting kind ..."
    echo
    run_kind

    local config_container_id
    config_container_id=$(docker run -it -d -v "/home:/home" -v "$REPO_ROOT:/workdir" \
        --workdir /workdir "$CHART_TESTING_IMAGE:$CHART_TESTING_TAG" cat)

    # shellcheck disable=SC2064
    trap "docker rm -f $config_container_id > /dev/null" EXIT

    set_kind

    echo "Add git remote k8s ${CHARTS_REPO}"
    git remote add k8s "${CHARTS_REPO}" &> /dev/null || true
    git fetch k8s master
    echo

    # --- Work around for Tillerless Helm, till Helm v3 gets released --- #
    run_tillerless

    # shellcheck disable=SC2086
    docker exec -e HELM_HOST=127.0.0.1:44134 -e HELM_TILLER_SILENT=true "$config_container_id" ct install --config /workdir/test/ct.yaml

    echo "Done Testing!"
}

main
