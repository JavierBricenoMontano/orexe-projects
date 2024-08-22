resource "aws_iam_role" "backup_role" {
  name = "backup_role_alt"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "backup.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_backup_vault" "primary" {
  provider = aws.primary
  name     = "PrimaryBackupVaultAlt"
}

resource "aws_backup_vault" "secondary" {
  provider   = aws.secondary
  name       = "PrimaryBackupVaultAlt"
  depends_on = [aws_backup_vault.primary]
}

resource "aws_backup_plan" "main" {
  name = "EC2BackupPlanAlt"

  rule {
    rule_name         = "DailyBackupPrimary"
    target_vault_name = aws_backup_vault.primary.name
    schedule          = "cron(0 12 * * ? *)"
    start_window      = 120
    completion_window = 360

    copy_action {
      destination_vault_arn = aws_backup_vault.secondary.arn
    }
  }

  depends_on = [
    aws_backup_vault.primary,
    aws_backup_vault.secondary
  ]
}


resource "aws_backup_selection" "ec2_backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "EC2BackupSelectionAlt"
  plan_id      = aws_backup_plan.main.id

  resources = [
    aws_instance.web_server.arn
  ]

  depends_on = [
    aws_backup_plan.main
  ]
}
