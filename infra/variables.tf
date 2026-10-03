variable "entorno" {
  description = "Nombre del entorno de despliegue simulado"
  type        = string
  default     = "desarrollo"
}

variable "api_port" {
  description = "Puerto en el que corre la API de Node"
  type        = number
  default     = 3000
}
