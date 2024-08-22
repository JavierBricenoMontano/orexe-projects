resource "aws_organizations_policy" "backup_policy" {
  name        = "PreventBackupDeletionAlt"
  description = "Prevents deletion of backup resources."

  content = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Deny",
        Action = [
          "aws-backup:DeleteBackupVault",
          "aws-backup:DeleteRecoveryPoint"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "backup_policy_attachment" {
  policy_id = aws_organizations_policy.backup_policy.id
  target_id = var.organizational_unit_id
}
