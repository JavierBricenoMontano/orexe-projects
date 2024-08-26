variable "availability_zone" {
  description = "La zona de disponibilidad donde se creará el volumen EBS"
  type        = string
}

variable "size" {
  description = "Tamaño del volumen EBS en GB"
  type        = number
}

variable "volume_type" {
  description = "El tipo de volumen EBS. Ejemplo: gp2, io1, standard"
  type        = string
  default     = "gp2"
}

variable "tags" {
  description = "Etiquetas opcionales para el volumen EBS"
  type        = map(string)
  default     = {}
}
