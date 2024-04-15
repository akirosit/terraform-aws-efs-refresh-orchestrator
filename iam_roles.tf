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

resource "aws_iam_policy" "step_function_parameter_store" {
  count  = var.store_efs_metadata_in_ssm ? 1 : 0
  name   = "${local.name_cc}StepFunctionParameterStore"
  path   = "/"
  policy = data.aws_iam_policy_document.step_function_parameter_store[0].json
}

resource "aws_iam_role_policy_attachment" "step_function_parameter_store" {
  count      = var.store_efs_metadata_in_ssm ? 1 : 0
  policy_arn = aws_iam_policy.step_function_parameter_store[0].arn
  role       = aws_iam_role.step_function.name
}
#
# Lambda IAM Role
#
resource "aws_iam_role" "lambda" {
  name               = "${local.name_cc}Lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_from_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.lambda.name
}

resource "aws_iam_policy" "lambda_role" {
  name   = "${local.name_cc}Lambda"
  policy = data.aws_iam_policy_document.lambda_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_role" {
  policy_arn = aws_iam_policy.lambda_role.arn
  role       = aws_iam_role.lambda.name
}