# Various Helm charts repository

#####You need to add this Chart repo to Helm:
```console
$ helm up
$ helm repo add rimusz-charts https://github.com/rimusz/charts
$ helm up
```

###Then you can install charts:

Let's install redis-guestbook chart:
```
$ helm fetch rimusz-charts/redis-guestbook
$ helm install redis-guestbook
```
