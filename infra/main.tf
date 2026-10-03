# Componente Terraform del proyecto poliglota (Módulo 6).
#
# Usa el provider 'local' a propósito: el objetivo del módulo es validar que la
# herramienta Terraform está disponible y funcional en el Codespace, no
# aprovisionar nube. Así 'init/validate/plan' corren sin credenciales.

locals {
  config = {
    entorno  = var.entorno
    api_port = var.api_port
    csv_path = "../datos/salida/inventario.csv"
  }
}

resource "local_file" "config_app" {
  filename = "${path.module}/generado/config.json"
  content  = jsonencode(local.config)
}
