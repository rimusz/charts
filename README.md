# Rimusz Helm Charts Repository

The official Rimusz [Helm](https://helm.sh) Charts repository.

## Getting Started

### Install Helm

Get the latest [Helm release](https://github.com/kubernetes/helm#install).

### Add Helm chart repository to Helm:

 ```console
 $ helm repo add rimusz https://helm-charts.rimusz.net
 $ helm repo update
 ```

### Install some chart

To install the Keel chart with the release name `keel`:

```console
$ helm upgrade --install keel rimusz/keel
```

Check Keel chart [readme](stable/keel/README.md) for more customisation options.

## Contributing to Rimusz Charts

Fork the `repo`, make changes and test it by installing the chart to see it is working. :)

On success make a [pull request](https://help.github.com/articles/using-pull-requests) (PR).

Upon successful review, someone will give the PR a __LGTM__ in the review thread.
