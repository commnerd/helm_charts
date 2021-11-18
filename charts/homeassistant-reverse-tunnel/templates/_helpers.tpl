{{/*
Expand the name of the chart.
*/}}
{{- define "homeassistant-reverse-tunnel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "homeassistant-reverse-tunnel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "homeassistant-reverse-tunnel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
