# Hostpath Provisioner

This chart bootstraps a [hostpath-provisioner](https://github.com/rimusz/hostpath-provisioner) deployment on a [Kubernetes](http://kubernetes.io),
which dynamically provisions Kubernetes HostPath Volumes, it is particularly handy to use on single-node Kubernetes cluster as [kind](https://github.com/kubernetes-sigs/kind).

## Installing the Chart

To install the chart with the release name `hostpath-provisioner`:

```console
$ helm upgrade --install hostpath-provisioner --namespace kube-system rimusz/hostpath-provisioner
```

**Note:** On [kind](https://github.com/kubernetes-sigs/kind) please delete the default storage class:

```console
kubectl delete storageclass standard
```

The command deploys hostpath-provisioner on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

## Deploying your own PersistentVolumeClaim

To deploy your own PVC, make sure that you have the correct `storage-class` as indicated by your `values.yaml` file.

For example:

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-dynamic-volume-claim
spec:
  storageClassName: hostpath
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
```

## Uninstalling the Chart

To uninstall/delete the `hostpath-provisioner` deployment:

```console
$ helm delete --purge hostpath-provisioner
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the `hostpath-provisioner` chart and their default values.

| Parameter                      | Description                                                                       | Default                               |
|:-------------------------------|:----------------------------------------------------------------------------------|:--------------------------------------|
| `strategyType`                 | Pod recreation type                                                               | `Recreate`                            |
| `image.repository`             | The image repository to pull from                                                 | `quay.io/rimusz/hostpath-provisioner` |
| `image.tag`                    | The image tag to use                                                              | ``                                    |
| `image.pullPolicy`             | Image pull policy                                                                 | `IfNotPresent`                        |
| `storageClass.create`          | Enable creation of a StorageClass to consume this hostpath-provisioner instance   | `true`                                |
| `storageClass.defaultClass`    | Enable as default storage class                                                   | `true`                                |
| `storageClass.name`            | The name to assign the created StorageClass                                       | `hostpath`                            |
| `provisionerName`              | The name to assign the created Provisioner                                        | `hostpath`                            |
| `reclaimPolicy`                | Set the reclaimPolicy | `Delete` |
| `rbac.create`                  | Enable RABC                                                                       | `true`                                |
| `rbac.serviceAccountName`      | Service account name                                                              | `default`                             |
| `resources`                    | Resource limits for hostpath-provisioner pod                                      | `{}`                                  |

```console
$ helm install rimusz/hostpath-provisioner --name hostpath-provisioner \
  --set resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install rimusz/hostpath-provisioner --name hostpath-provisioner -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml) as an example
