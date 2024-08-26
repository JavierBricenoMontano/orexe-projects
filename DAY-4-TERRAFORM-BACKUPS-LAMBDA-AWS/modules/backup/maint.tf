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

resource "aws_backup_vault" "this" {
  name = var.backup_vault_name
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
