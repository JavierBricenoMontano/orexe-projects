module "vpc" {
  source = "./modules/vpc"

  cidr_block         = "10.0.0.0/16"
  vpc_name           = "my-vpc-orexe-day-4"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b"]

  tags = {
    Environment = "dev"
  }
}

module "rds" {
  source = "./modules/rds"

  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "mydatabase"
  username                = "admin"
  password                = "password"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  backup_retention_period = 7
  backup_window           = "07:00-09:00"
  subnet_group_name       = "my-subnet-group"
  subnet_ids              = module.vpc.private_subnet_ids
  tags = {
    Name = "My RDS instance"
  }
}

module "backup" {
  source = "./modules/backup"

  backup_plan_name  = "my-backup-plan"
  rule_name         = "daily-backup"
  schedule          = "cron(0 5 * * ? *)"
  delete_after      = 30
  backup_vault_name = "my-backup-vault"
  selection_name    = "my-backup-selection"
  resources         = [module.rds.db_instance_arn]
  backup_role_name  = "backup-role"
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
