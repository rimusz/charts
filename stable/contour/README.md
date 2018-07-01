# Contour

Contour is an Ingress controller for Kubernetes that works by deploying the [Envoy proxy](https://www.envoyproxy.io/) as a reverse proxy and load balancer.
Unlike other Ingress controllers, Contour supports dynamic configuration updates out of the box while maintaining a lightweight profile.

## Prerequisites

- Kubernetes 1.9+

## Installing the Chart

To install the chart with the release name `contour`:

```console
$ helm install --name contour rimusz/contour
```

By default `contour` uses `HostPort` to expose ports 80/443. You can change to use `LoadBalancer` via `-set` or in `values.yaml`

> **Tip**: List all releases using `helm list`

## Configuration

You can check `contour` configurable parameters in [values.yaml](values.yaml) file.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the configurable parameters can be provided while installing the chart. For example,

```console
$ helm install --name contour -f values.yaml .
```
> **Tip**: You can use the default [values.yaml](values.yaml)

## Uninstalling the Chart

To uninstall/delete the `contour` deployment:

```console
$ helm delete --purge contour
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
