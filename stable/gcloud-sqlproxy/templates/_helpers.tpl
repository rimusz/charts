{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gcloud-sqlproxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gcloud-sqlproxy.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s" .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Generate gcp service account name
*/}}
{{- define "gcloud-sqlproxy.serviceAccountName" -}}
{{ default (include "gcloud-sqlproxy.fullname" .) .Values.serviceAccountName }}
{{- end -}}

{{/*
Generate key name in the secret
*/}}
{{- define "gcloud-sqlproxy.secretKey" -}}
{{ default "credentials.json" .Values.existingSecretKey }}
{{- end -}}

{{/*
Generate the secret name
*/}}
{{- define "gcloud-sqlproxy.secretName" -}}
{{ default (include "gcloud-sqlproxy.fullname" .) .Values.existingSecret }}
{{- end -}}

{{/*
Check if any type of credentials are defined
*/}}
{{- define "gcloud-sqlproxy.hasCredentials" -}}
{{ or .Values.serviceAccountKey ( or .Values.existingSecret .Values.usingGCPController ) -}}
{{- end -}}