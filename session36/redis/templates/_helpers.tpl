{{/*
Return the fully qualified app name.
*/}}
{{- define "redis.fullname" -}}
{{- default .Chart.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
