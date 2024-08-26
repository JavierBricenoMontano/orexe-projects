# main.tf
resource "aws_iam_role" "cross_account_backup_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${var.remote_account_id}:root"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "cross_account_backup_policy" {
  name   = "${var.role_name}_Policy"
  policy = var.permissions_policy
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.cross_account_backup_role.name
  policy_arn = aws_iam_policy.cross_account_backup_policy.arn
}
