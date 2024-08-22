variable "rule_name" {
  type        = string
  description = "The name of the EventBridge rule."
}

variable "description" {
  type        = string
  description = "The description of the EventBridge rule."
}

variable "states" {
  type        = list(string)
  description = "List of backup states to monitor."
}

variable "target_arn" {
  type        = string
  description = "The ARN of the target to invoke when the rule matches."
}
