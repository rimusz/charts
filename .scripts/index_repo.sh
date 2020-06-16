#!/bin/sh
set -e

echo "Installing curl"
apt update
apt install curl -y

echo "Installing helm"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version

echo "Indexing repository"
if [ -f index.yaml ]; then
  helm repo index --url "${REPO_URL}" --merge index.yaml ./temp
else
  helm repo index --url "${REPO_URL}" ./temp
fi
cat ./temp/index.yaml
