# Description: This file contains the IAM roles for the Lambda and Step Function

locals {
  aws_backup_arn = "arn:aws:iam::${local.current_account_id}:role/service-role/AWSBackupDefaultServiceRole"
}

#
# Step Function EFS IAM Role
#
resource "aws_iam_role" "step_function" {
  name               = "${local.name_cc}StepFunction"
  assume_role_policy = data.aws_iam_policy_document.assume_from_step_functions.json
}

resource "aws_iam_policy" "step_function_role" {
  name   = "${local.name_cc}StepFunction"
  path   = "/"
  policy = data.aws_iam_policy_document.step_function_role.json
}

resource "aws_iam_role_policy_attachment" "step_function_role" {
  policy_arn = aws_iam_policy.step_function_role.arn
  role       = aws_iam_role.step_function.name
}
