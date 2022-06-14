{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongodb.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mongodb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongodb.labels" -}}
helm.sh/chart: {{ include "mongodb.chart" . }}
{{ include "mongodb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mongodb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mongodb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mongodb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mongodb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "mongodb.nodes" -}}
{{ $replicaCount := .Values.replicaCount | int}}
{{ $name := (include "mongodb.fullname" .) }}
localhost{{- range $i := until $replicaCount }},{{$name}}-{{ $i }}{{- end }}
{{- end }}

{{- define "mongodb.members_js" -}}
{{ $replicaCount := .Values.replicaCount | int}}
{{ $name := (include "mongodb.fullname" .) }}
{{- range $i := until $replicaCount }}{{ if gt $i 0}},{{ end }}{ _id: {{ $i }}, host: "{{$name}}-{{ $i }}:27017"}{{- end }}
{{- end }}

{{- define "mongodb.cluster_init_js" -}}
{{ $name := (include "mongodb.fullname" .) }}
rs.initiate({ _id :  "{{ $name }}", members: [{{ include "mongodb.members_js" . }}]})
{{- end }}


{{- define "mongodb.cluster_init" -}}
{{ $name := (include "mongodb.fullname" .) }}
apt update && apt install -y mongodb-mongosh && mongosh -h {{ $name }}-0 -u user -p pass --eval "{{ include "mongodb.cluster_init_js" . }}"
{{- end }}