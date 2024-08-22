variable "allocated_storage" {
  type        = number
  description = "The amount of allocated storage in gigabytes."
}

variable "engine" {
  type        = string
  description = "The database engine to use."
}

variable "engine_version" {
  type        = string
  description = "The version of the database engine."
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS instance."
}

variable "db_name" {
  type        = string
  description = "The name of the database."
}

variable "username" {
  type        = string
  description = "The username for the master DB user."
}

variable "password" {
  type        = string
  description = "The password for the master DB user."
  sensitive   = true
}

variable "parameter_group_name" {
  type        = string
  description = "The name of the DB parameter group to associate with this instance."
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  default     = true
}

variable "backup_retention_period" {
  type        = number
  description = "The number of days to retain backups for."
  default     = 7
}

variable "backup_window" {
  type        = string
  description = "The preferred backup window."
  default     = "07:00-09:00"
}

variable "subnet_group_name" {
  type        = string
  description = "The name of the RDS subnet group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
}
