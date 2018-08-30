# NFS Client Provisioner

[NFS Client Provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client)
is an automatic provisioner that uses your already configured NFS server to automatically create Persistent Volumes.

## TL;DR;

```console
$ helm install rimusz/nfs-client-provisioner --set nfs.server="1.2.3.4"
```

## Introduction

This chart bootstraps a [nfs-client-provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client)
deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh)
package manager.

## Installing the Chart

To install the chart with the release name `nfs`:

```console
$ helm install rimusz/nfs-client-provisioner --name nfs --set nfs.server="1.2.3.4"
```

The command deploys nfs-client-provisioner on the Kubernetes cluster in the default
configuration. The [configuration](#configuration) section lists the parameters
that can be configured during installation.

## Testing the Chart

Now we'll test your NFS provisioner.

Deploy:

```console
$ kubectl create -f test/test-claim.yaml -f test/test-pod.yaml
```

Now check in PVC folder on your NFS Server for the file `SUCCESS`.

Delete:

```console
kubectl delete -f test/test-pod.yaml -f test/test-claim.yaml
```

Now check that PVC folder got renamed to `archived-???`.

## Deploying your own PersistentVolumeClaim

To deploy your own PVC, make sure that you have the correct `storage-class` as indicated by your `values.yaml` file.

For example:

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-claim
  annotations:
    volume.beta.kubernetes.io/storage-class: "nfs"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Mi
```

## Uninstalling the Chart

To uninstall/delete the `nfs` deployment:

```console
$ helm delete nfs
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.

## Configuration

The following table lists the configurable parameters of the kibana chart and
their default values.

| Parameter                      | Description                                                                       | Default                                               |
|:-------------------------------|:----------------------------------------------------------------------------------|:------------------------------------------------------|
| `image.repository`             | The image repository to pull from                                                 | `quay.io/kubernetes_incubator/nfs-client-provisioner` |
| `image.tag`                    | The image tag to pull from                                                        | `v2.1.0-k8s1.10`                                      |
| `image.pullPolicy`             | Image pull policy                                                                 | `IfNotPresent`                                        |
| `nfs.server`                   | NFS server IP                                                                     | ``                                                    |
| `nfs.path`                     | NFS server share path                                                             | `/vol1`                                               |
| `storageClass.create`          | Enable creation of a StorageClass to consume this nfs-client-provisioner instance | `true`                                                |
| `storageClass.name`            | The name to assign the created StorageClass                                       | `nfs`                                                 |
| `storageClass.reclaimPolicy`   | Set the reclaimPolicy for PV within StorageClass                                  | `Delete`                                              |
| `rbac.create`                  | Enable RABC                                                                       | `false`                                               |
| `rbac.serviceAccountName`      | Service account name                                                              | `default`                                             |
| `resources`                    | Resource limits for nfs-client-provisioner pod                                    | `{}`                                                  |
| `nodeSelector`                 | Map of node labels for pod assignment                                             | `{}`                                                  |
| `tolerations`                  | List of node taints to tolerate                                                   | `[]`                                                  |
| `affinity`                     | Map of node/pod affinities                                                        | `{}`                                                  |

```console
$ helm install rimusz/nfs-client-provisioner --name nfs \
  --set nfs.server="1.2.3.4",resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters
can be provided while installing the chart. For example,

```console
$ helm install rimusz/nfs-client-provisioner --name nfs -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml) as an example
