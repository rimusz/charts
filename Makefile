
# Test charts locally
MAC_ARGS ?=
CHARTS_REPO ?= https://github.com/rimusz/charts
CHART_TESTING_IMAGE ?= quay.io/helmpack/chart-testing
CHART_TESTING_TAG ?= v3.0.0-rc.1
GKE_TESTING_IMAGE ?= docker.io/rimusz/gke-charts-ci
GKE_TESTING_TAG ?= v0.0.2

# If the first argument is "lint" or "mac" or "gke" or "kind"
ifneq ( $(filter wordlist 1,lint mac gke kind), $(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "lint" "mac" or "gke" or "kind"
  MAC_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(MAC_ARGS):;@:)
endif

.PHONY: lint
lint:
	$(eval export CHART_TESTING_IMAGE)
	$(eval export CHART_TESTING_TAG)
	$(eval export CHARTS_REPO)
	$(eval export CHART_TESTING_ARGS=${MAC_ARGS})
	@test/lint-charts-local.sh

.PHONY: mac
mac:
	$(eval export CHART_TESTING_IMAGE)
	$(eval export CHART_TESTING_TAG)
	$(eval export CHARTS_REPO)
	$(eval export CHART_TESTING_ARGS=${MAC_ARGS})
	@test/e2e-docker4mac.sh

.PHONY: gke
gke:
	$(eval export GKE_TESTING_IMAGE)
	$(eval export GKE_TESTING_TAG)
	$(eval export CHARTS_REPO)
	$(eval export CHART_TESTING_ARGS=${MAC_ARGS})
	@test/e2e-local-gke.sh

.PHONY: publish
publish:
	@./.scripts/repo-sync.sh
