variable "backup_plan_name" {
  type        = string
  description = "The name of the backup plan."
}

variable "rule_name" {
  type        = string
  description = "The name of the backup rule."
}

variable "schedule" {
  type        = string
  description = "The CRON schedule for the backup."
}

variable "delete_after" {
  type        = number
  description = "The number of days to retain the backup."
}

variable "backup_vault_name" {
  type        = string
  description = "The name of the backup vault."
}

variable "selection_name" {
  type        = string
  description = "The name of the backup selection."
}

variable "resources" {
  type        = list(string)
  description = "The list of ARNs of the resources to back up."
}

variable "backup_role_name" {
  type        = string
  description = "The name of the IAM role for backup."
}

variable "destination_vault_arn" {
  type        = string
  description = "The ARN of the destination backup vault."
}
