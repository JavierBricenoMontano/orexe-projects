# variables.tf
variable "remote_account_id" {
  description = "ID de la cuenta AWS remota que asumirá este rol."
  type        = string
}

variable "role_name" {
  description = "Nombre del rol a crear."
  type        = string
  default     = "BackupCrossAccountRole"
}

variable "permissions_policy" {
  description = "Política que define los permisos para el rol."
  type        = string
}
