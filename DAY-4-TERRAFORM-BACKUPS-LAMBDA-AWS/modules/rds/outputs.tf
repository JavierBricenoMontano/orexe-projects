output "db_instance_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_instance_arn" {
  value = aws_db_instance.this.arn
}
