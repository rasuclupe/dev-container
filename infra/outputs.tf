output "config_file" {
  description = "Ruta del archivo de configuración generado"
  value       = local_file.config_app.filename
}

output "entorno" {
  description = "Entorno configurado"
  value       = var.entorno
}
