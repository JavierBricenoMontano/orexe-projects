# outputs.tf
output "role_arn" {
  description = "ARN del rol creado."
  value       = aws_iam_role.cross_account_backup_role.arn
}
