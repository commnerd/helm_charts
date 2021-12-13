{{/*
Expand the name of the chart.
*/}}
{{- define "reverse-tunnel.name" -}}
{{- default .Chart.Name .Values.deployment.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "reverse-tunnel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "reverse-tunnel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
