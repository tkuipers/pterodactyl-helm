{{/*
Expand the name of the chart.
*/}}
{{- define "pterodactyl.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pterodactyl.fullname" -}}
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
{{- define "pterodactyl.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pterodactyl.labels" -}}
helm.sh/chart: {{ include "pterodactyl.chart" . }}
{{ include "pterodactyl.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pterodactyl.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pterodactyl.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Panel selector labels
*/}}
{{- define "pterodactyl.panel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pterodactyl.name" . }}-panel
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: panel
{{- end }}

{{/*
Wings selector labels
*/}}
{{- define "pterodactyl.wings.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pterodactyl.name" . }}-wings
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: wings
{{- end }}

{{/*
Queue worker selector labels
*/}}
{{- define "pterodactyl.worker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pterodactyl.name" . }}-worker
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: worker
{{- end }}

{{/*
MySQL selector labels
*/}}
{{- define "pterodactyl.mysql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pterodactyl.name" . }}-mysql
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: mysql
{{- end }}

{{/*
Redis selector labels
*/}}
{{- define "pterodactyl.redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pterodactyl.name" . }}-redis
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: redis
{{- end }}

{{/*
Panel name
*/}}
{{- define "pterodactyl.panel.name" -}}
{{- printf "%s-panel" (include "pterodactyl.fullname" .) }}
{{- end }}

{{/*
Wings name
*/}}
{{- define "pterodactyl.wings.name" -}}
{{- printf "%s-wings" (include "pterodactyl.fullname" .) }}
{{- end }}

{{/*
Queue worker name
*/}}
{{- define "pterodactyl.worker.name" -}}
{{- printf "%s-worker" (include "pterodactyl.fullname" .) }}
{{- end }}

{{/*
MySQL name
*/}}
{{- define "pterodactyl.mysql.name" -}}
{{- printf "%s-mysql" (include "pterodactyl.fullname" .) }}
{{- end }}

{{/*
Redis name
*/}}
{{- define "pterodactyl.redis.name" -}}
{{- printf "%s-redis" (include "pterodactyl.fullname" .) }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "pterodactyl-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pterodactyl-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
