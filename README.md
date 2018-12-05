# Helm Charts Repository

The official Rimusz [Helm](https://helm.sh) Charts repository.

## Getting Started

### Install Helm

Get the latest [Helm release](https://github.com/kubernetes/helm#install).

### Add Helm chart repository to Helm:

 ```console
 $ helm repo add rimusz https://charts.rimusz.net
 $ helm repo update
 ```

**Note:** Repo name was changed from `https://helm-charts.rimusz.net` to `https://charts.rimusz.net`

### Install some chart

To install the contour chart with the release name `contour`:

```console
$ helm upgrade --install contour rimusz/contour
```

Check contour chart [readme](stable/contour/README.md) for more customisation options.

## Contributing to Rimusz Charts

Fork the `repo`, make changes and test it by installing the chart to see it is working. :)

On success make a [pull request](https://help.github.com/articles/using-pull-requests) (PR).

Upon successful review, someone will give the PR a __LGTM__ in the review thread.
