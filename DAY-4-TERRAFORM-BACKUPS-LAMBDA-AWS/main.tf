module "backup_role_source" {
  source            = "./modules/cross_account_backup_role"
  remote_account_id = "533266983093"
  role_name         = "BackupRoleSource"
  permissions_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateSnapshot",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DeleteSnapshot",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeSnapshots",
          "backup:StartBackupJob",
          "backup:ListBackupJobs",
          "backup:DescribeBackupJob",
          "backup:ListBackupPlans",
          "backup:ListBackupVaults",
          "backup:GetBackupVaultAccessPolicy",
          "backup:GetBackupVaultNotifications",
          "backup:ListRecoveryPointsByBackupVault",
          "backup:ListBackupSelections",
          "backup:DescribeBackupVault",
          "backup:DescribeBackupPlan",
          "backup:ListBackupJobs",
          "backup:ListBackupPlanTemplates",
          "backup:ListBackupVaults",
          "backup:ListBackupPlans",

          "backup:CopyIntoBackupVault",
          "backup:StartCopyJob"
        ],
        "Resource" : "*"
      }
    ]
  })
}

module "ebs_volume" {
  source            = "./modules/ebs"
  availability_zone = "us-west-2a"
  size              = 20 # Puedes ajustar el tamaño hasta 30GB
  tags = {
    Name = "MyFreeTierEBSVolume"
  }
}
module "backup" {
  source = "./modules/backup"

  backup_plan_name      = "my-backup-plan"
  rule_name             = "daily-backup"
  schedule              = "cron(10 3 * * ? *)"
  delete_after          = 30
  backup_vault_name     = "my-backup-vault"
  selection_name        = "my-backup-selection"
  resources             = [module.ebs_volume.arn]
  backup_role_name      = "backup-role"
  destination_vault_arn = "arn:aws:backup:us-west-2:533266983093:backup-vault:Default"
}

resource "aws_sns_topic" "backup_notifications" {
  name = "backup-notifications"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.backup_notifications.arn
  protocol  = "email"
  endpoint  = "jbricenomontano@gmail.com"
}

module "lambda" {
  source = "./modules/lambda"

  filename      = "./lambda/lambda.zip"
  function_name = "notifyBackupCompletion"
  handler       = "lambda.handler"
  runtime       = "nodejs20.x"
  environment_variables = {
    SNS_TOPIC_ARN = aws_sns_topic.backup_notifications.arn
  }
  lambda_role_name = "lambda-exec-role"
  sns_topic_arn    = aws_sns_topic.backup_notifications.arn
}

module "eventbridge" {
  source = "./modules/eventbridge"

  rule_name   = "backup-event-rule"
  description = "Rule to monitor AWS Backup events"
  states      = ["COMPLETED", "FAILED"]
  target_arn  = module.lambda.lambda_function_arn
}
