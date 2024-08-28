resource "aws_backup_plan" "this" {
  name = var.backup_plan_name

  rule {
    rule_name         = var.rule_name
    target_vault_name = aws_backup_vault.this.name
    schedule          = var.schedule
    lifecycle {
      delete_after = var.delete_after
    }

    copy_action {
      destination_vault_arn = var.destination_vault_arn
    }
  }
}

resource "aws_kms_key" "backup_vault_key" {
  description             = "KMS key for Backup Vault encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "backup_vault_alias" {
  name          = "alias/backup-vault-key"
  target_key_id = aws_kms_key.backup_vault_key.id
}

resource "aws_kms_key_policy" "backup_vault_policy" {
  key_id = aws_kms_key.backup_vault_key.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow access for AWS Backup service",
      "Effect": "Allow",
      "Principal": {
        "Service": "backup.amazonaws.com"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_backup_vault" "this" {
  name        = var.backup_vault_name
  kms_key_arn = aws_kms_key.backup_vault_key.arn
}

resource "aws_iam_role" "backup_role" {
  name = var.backup_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_backup_selection" "this" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = var.selection_name
  plan_id      = aws_backup_plan.this.id
  resources    = var.resources
}
