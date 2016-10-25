# Weave Scope

[Weave Scope](https://www.weave.works/products/weave-scope/) Zero configuration, zero integration — just launch Weave Scope and go! Automatically detects processes, containers, hosts. No kernel modules, no agents, no special libraries, no coding. Seamless integration with Kubernetes and AWS ECS.

## TL;DR;

```bash
$ helm install weavescope-x.x.x.tgz
```

## Introduction

This chart bootstraps a [Weave Scope](https://hub.docker.com/r/weaveworks/weave/tags/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Get this chart

Download the latest release of the chart from the [releases](../../../releases) page.

Alternatively, clone the repo if you wish to use the development snapshot:

```bash
$ git clone https://github.com/rimusz/charts.git
```

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release weavescope-x.x.x.tgz
```

*Replace the `x.x.x` placeholder with the chart release version.*

The command deploys Weave Scope on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Weave Scope chart and their default values.

|     Parameter     |        Description           |                         Default                         |
|-------------------|------------------------------|---------------------------------------------------------|
| `imageTag`        | `weaveworks/scope` image tag | Weaveworks Scope image version                          |
| `imagePullPolicy` | Image pull policy            | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `dockerBridge`    | sets Docker bridge mode      | `true`                                                  |
| `serviceToken`    | Scope Cloud service token    | `nil`                                                   |

You can specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install --name my-release \
  --set serviceToken=your_scope_weave_works_service_token \
    weavescope-x.x.x.tgz
```

The above command sets the Weave Scope to run in Cloud Service Mode.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml weavescope-x.x.x.tgz
```

> **Tip**: You can use the default [values.yaml](values.yaml)
