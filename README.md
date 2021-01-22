# The official Rimusz [Helm](https://helm.sh) Charts repository.

## Getting Started

### Install Helm

Get the latest [Helm](https://helm.sh/docs/intro/install/).

### Add Helm chart repository

Adding `rimusz` chart repository:

 ```console
 helm repo add rimusz https://charts.rimusz.net
 helm repo update
 ```
 
### Install some chart

To install the `gcloud-sqlproxy` chart with the release name `gcloud-sqlproxy`:

```console
helm upgrade --install gcloud-sqlproxy rimusz/gcloud-sqlproxy
```

Check `gcloud-sqlproxy` chart [readme](stable/gcloud-sqlproxy/README.md) for more customization options.

## Contributing to Rimusz Charts

Fork the `repo`, make changes and test it by installing the chart to see it is working. :)

On success make a [pull request](https://help.github.com/articles/using-pull-requests) (PR).

Upon successful review, someone will give the PR a __LGTM__ in the review thread.

## Linting charts locally

**Note:** Docker must be running on your Mac/Linux machine. 
The command will only lint changed charts.

To lint all charts:

```console
make lint
```

### Forcing to lint unchanged charts

**Note:** Chart version bump check will be ignored.

You can force to lint one chart with `--charts` flag:

```console
make lint -- --charts stable/gcloud-sqlproxy
```

You can force to lint a list of charts (separated by comma) with `--charts` flag:

```console
make lint -- --charts stable/contour,stable/gcloud-sqlproxy
```

You can force to lint all charts with `--all` flag:

```console
make lint -- --all
```

## Manually testing charts with Docker for Mac Kubernetes Cluster

**Note:** Make sure **'Show system containers (advanced)'** is enabled in `Preferences/Kubernetes`.

On the Mac you can install and test all changed charts in `Docker for Mac`:

```console
make mac
```

### Forcing to install unchanged charts

You can force to install one chart with `--charts` flag:

```console
make mac -- --charts stable/gcloud-sqlproxy
```

You can force to install a list of charts (separated by comma) with `--charts` flag:

```console
make mac -- --charts stable/contour,stable/gcloud-sqlproxy
```

You can force to install all charts with `--all` flag:

```console
make mac -- --all
```

**Note:** It might take a while to run install test for all charts in `Docker for Mac`.

## Manually testing charts with remote GKE cluster

You can install and test changed charts with `GKE` cluster set in kubeconfig `context`:

```console
make gke
```

### Forcing to install unchanged charts

You can force to install one chart with `--charts` flag:

```console
make gke -- --charts stable/gcloud-sqlproxy
```

You can force to install a list of charts (separated by comma) with `--charts` flag:

```console
make gke -- --charts stable/contour,stable/gcloud-sqlproxy
```

You can force to install all charts with `--all` flag:

```console
make gke -- --all
```

### Using dedicated GKE cluster for manual charts testing

By default it uses the `GKE` cluster set in kubeconfig `context`, you can specify the dedicated cluster (it must be set in the kubeconfig) in the file `CLUSTER`:

```
GKE_CLUSTER=gke_my_cluster_context_name
```

Then store the `CLUSTER` file in the root folder of the repo. It is also ignored by git.

In such setup your local default cluster can be different from the charts testing one.

## Docs

For more information on using Helm, refer to the Helm's [documentation](https://docs.helm.sh/using_helm/#quickstart-guide).

To get a quick introduction to Charts see this Chart's [documentation](https://docs.helm.sh/developing_charts/#charts). 
