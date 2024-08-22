resource "aws_cloudwatch_event_rule" "this" {
  name        = var.rule_name
  description = var.description
  event_pattern = jsonencode({
    "source" : ["aws.backup"],
    "detail-type" : ["Backup Job State Change"],
    "detail" : {
      "state" : var.states
    }
  })
}

resource "aws_cloudwatch_event_target" "this" {
  rule = aws_cloudwatch_event_rule.this.name
  arn  = var.target_arn
}
