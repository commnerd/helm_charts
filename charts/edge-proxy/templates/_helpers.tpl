{{/*
Expand the name of the chart.
*/}}
{{- define "edge-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "edge-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "edge-proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
