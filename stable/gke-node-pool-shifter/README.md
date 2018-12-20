# GKE node-pool shifter

This controller shifts nodes from one GKE node pool to another, in order to favour [preemptibles](https://cloud.google.com/compute/docs/instances/preemptible) over a 'safety net' node pool of regular VMs.

In more details: controller `moves` regular VMs over to the preemptible node pool, by adding a preemptible VM and deleting a regular VM whenever one is added by the GKE cluster autoscaler.

You can read more about the use case on [Travix Engineering blog post](https://travix.io/how-we-run-kubernetes-engine-at-travix-cde7a66af2bb).

## Prerequisites

- Kubernetes cluster on Google Container Engine (GKE)
- GCP Service account with role set to `Compute Instance Admin` and `Kubernetes Engine Admin`. This key is going to be used to authenticate from the application to the GCP Compute API. See [documentation](https://developers.google.com/identity/protocols/application-default-credentials).

## Installing the Chart

To install the chart with the release name `gke-node-pool-shifter`:

```
helm upgrade --install gke-node-pool-shifter --namespace estafette rimusz/gke-node-pool-shifter \
    --set googleServiceAccount="$(cat path_to_your/google-service-account.json | base64)"
```

### Installing with existing secret

You can deploy the Google service account `google-service-account.json` file as a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/).


Create the Kubernetes secret:

```
kubectl create secret generic gke-node-pool-shifter -n estafette --from-file=path_to_your/google-service-account.json
```

Pass the configuration file to helm:

```
helm upgrade --install gke-node-pool-shifter --namespace estafette rimusz/gke-node-pool-shifter \
    --set existingSecret="gke-node-pool-shifter"
```

**NOTE:** You have to keep passing the configuration file secret parameter as `--set existingSecret="gke-node-pool-shifter"` on all future calls to `helm upgrade` or set it in `values.yaml` file `existingSecret: gke-node-pool-shifter`!

## Uninstalling the Chart

To uninstall/delete the `gke-node-pool-shifter` deployment:

```
helm delete --purge gke-node-pool-shifter
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kubernetes-dashboard chart and their default values.

|         Parameter            |                    Description                   |           Default                  |
|------------------------------|--------------------------------------------------|------------------------------------|
| `image.repository`| Image repository name | `estafette/estafette-gke-preemptible-killer` |
| `image.pullPolicy`| Image pull policy | `IfNotPresent` |
| `image.pullSecrets`| Image pull secret from private registry | `` |
| `googleServiceAccount` | base64 encoded `google-service-account.json` file | `` |
| `existingSecret` | Specifies an existing secret for `google-service-account.json` file| `` |
| `nodePool.interval` | Time in second to wait between each node pool check | `300` |
| `nodePool.from` | The name of the node pool to shift from | `` |
| `nodePool.to` | The name of the node pool to shift to | `` |
| `nodePool.fromMinNode` | The minimum number of nodes to keep for the node pool to shift from | `0` |
| `securityContext.enabled` | Enables Security Context  | `true` |
| `securityContext.userId` |  Security User Id | `1000` |
| `securityContext.groupId` |  Security Group Id | `1000` |
| `annotations.prometheus.io/scrape` | The address to listen on for Prometheus metrics requests | `true` |
| `annotations.prometheus.io/port` | The port to listen for Prometheus metrics requests | `9001` |
| `livenessProbe` | Set liveness probe | `{}` |
| `resources.limits.cpu` | Specifies CPU limit | `50m` |
| `resources.limits.memory` | Specifies memory limit | `128Mi` |
| `resources.requests.cpu` | Specifies CPU request | `10m` |
| `resources.requests.memory` | Specifies memory request | `16Mi` |
| `nodeSelector` | gke-node-pool-shifter node selector | `{}` |
| `tolerations` | gke-node-pool-shifter node tolerations | `[]` |
| `affinity` | gke-node-pool-shifter node affinity | `cloud.google.com/gke-preemptible` |
| `podDisruptionBudget.enabled` | Enables Pod Disruption Budget | `false` |
| `podDisruptionBudget.maxUnavailable` | Max unavailable Pods | `1` |
| `podDisruptionBudget.minAvailable` | min unavailable Pods | `` |
| `rbac.enabled` | Specifies whether RBAC resources should be created | `true` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```
helm upgrade --install gke-node-pool-shifter --namespace estafette rimusz/gke-node-pool-shifter --set resources.limits.cpu=200m
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```
helm upgrade --install gke-node-pool-shifter --namespace estafette rimusz/gke-node-pool-shifter -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
