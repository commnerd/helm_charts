{{/*
Expand the name of the chart.
*/}}
{{- define "k3s-ssh-reverse-tunnel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "k3s-ssh-reverse-tunnel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k3s-ssh-reverse-tunnel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
