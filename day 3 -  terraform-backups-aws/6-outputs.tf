output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "backup_vault_arn" {
  description = "The ARN of the primary backup vault"
  value       = aws_backup_vault.primary.arn
}
