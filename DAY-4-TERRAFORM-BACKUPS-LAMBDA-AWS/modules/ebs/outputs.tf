output "volume_id" {
  description = "El ID del volumen EBS"
  value       = aws_ebs_volume.this.id
}

output "availability_zone" {
  description = "La zona de disponibilidad del volumen EBS"
  value       = aws_ebs_volume.this.availability_zone
}

output "arn" {
  description = "ARN del volumen EBS"
  value       = aws_ebs_volume.this.arn
}
