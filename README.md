# Helm charts repository

###

You need to add this Chart repo to Helm:
```console
$ helm repo add rimusz https://helm-charts.rimusz.net
$ helm repo up
```

###

Then you can install charts as simple as:

Let's install weavescope chart:
```
$ helm install rimusz/weavescope
```
