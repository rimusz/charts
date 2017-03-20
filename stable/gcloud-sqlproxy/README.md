# GCP SQL Proxy

[sql-proxy](https://cloud.google.com/sql/docs/postgres/sql-proxy) The Cloud SQL Proxy provides secure access to your Cloud SQL instances without having to whitelist IP addresses or configure SSL.
Accessing your Cloud SQL instance using the Cloud SQL Proxy offers these advantages:

Secure connections: The proxy automatically encrypts traffic to and from the database; SSL certificates are used to verify client and server identities.
Easier connection management: The proxy handles authentication with Google Cloud SQL, removing the need to provide static IP addresses.


## Installing the Chart

Install from remote URL with the release name `gcp-sqlproxy` and into namespace `sqlproxy` and set GCP service account, SQL instance and port:

```bash
$ helm upgrade pg-sqlproxy rimusz/gcloud-sqlproxy --namespace deis \
  --set gcpServiceAccountKey="$(cat service-account.json | base64)",cloudsql.instance="PROJECT:REGION:INSTANCE",cloudsql.port="5432" -i
```

To access it from the same namespace via name `pg-sqlproxy`.
