{{/* Nom complet de l'application */}}
{{- define "odoo-cnpg.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}