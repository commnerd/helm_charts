{{/*
Expand the name of the chart.
*/}}
{{- define "edge-reverse-tunnel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "edge-reverse-tunnel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "edge-reverse-tunnel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
