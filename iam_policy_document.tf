# Purpose: This file is used to create IAM policy documents for the lambda role and step function role.

#
# Step Function IAM Policy Document
#
data "aws_iam_policy_document" "assume_from_step_functions" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "step_function_role" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem"
    ]
    resources = [aws_dynamodb_table.dynamodbTable.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [local.sns_topic_arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "backup:ListRecoveryPointsByResource",
      "backup:StartRestoreJob",
      "backup:DescribeRestoreJob",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole",
    ]
    resources = [local.aws_backup_arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:CreateMountTarget",
      "elasticfilesystem:DescribeMountTargets",
      "elasticfilesystem:ListTagsForResource",
      "elasticfilesystem:TagResource",
      "elasticfilesystem:CreateAccessPoint"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeSubnets",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
      "lambda:InvokeAsync",
      "lambda:UpdateFunctionConfiguration"
    ]
    resources = [for lambda in aws_lambda_function.functions : lambda.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "states:StartExecution"
    ]
    resources = [aws_sfn_state_machine.refresh_env.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "tag:TagResources",
      "elasticfilesystem:CreateTags"
    ]
    resources = ["*"]
  }
}

#
# Lambda IAM Policy Document
#
data "aws_iam_policy_document" "assume_from_lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_role" {
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeMountTargets",
      "elasticfilesystem:ListTagsForResource",
      "elasticfilesystem:TagResource"
    ]
    resources = ["*"]
  }
}