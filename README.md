# Helm charts repository

###

You need to add this Chart repo to Helm:
```console
$ helm repo add rimusz https://rimusz.github.io/charts/
$ helm repo up
```

###

Then you can install charts as simple as:

Let's install weavescope chart:
```
$ helm install rimusz/weavescope
```
