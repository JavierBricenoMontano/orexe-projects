variable "filename" {
  type        = string
  description = "The path to the ZIP file containing your Lambda function code."
}

variable "function_name" {
  type        = string
  description = "The name of the Lambda function."
}

variable "handler" {
  type        = string
  description = "The function entrypoint in your code."
}

variable "runtime" {
  type        = string
  description = "The runtime environment for the Lambda function."
}

variable "environment_variables" {
  type        = map(string)
  description = "A map of environment variables to pass to the Lambda function."
}

variable "lambda_role_name" {
  type        = string
  description = "The name of the IAM role for Lambda execution."
}

variable "sns_topic_arn" {
  type        = string
  description = "The ARN of the SNS topic for Lambda to publish to."
}
