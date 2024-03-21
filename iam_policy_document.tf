# Purpose: This file is used to create IAM policy documents for the lambda role and step function role.

# Locals block to store the EFS ARNs
locals {
  efs_arn = [
    for app_name, app_input in var.efs_to_refresh : app_input.EFSArn
  ]
}

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
      "elasticfilesystem:ListTagsForResource",
      "elasticfilesystem:TagResource"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DeleteFileSystem"
    ]
    resources = local.efs_arn
  }
}