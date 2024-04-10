# Description: This file contains the code to create the lambda functions

locals {
  lambda_layers = []
  lambda_functions = [
    "GetEfsRestoreBackupDirectory"
  ]
  lambda_functions_layers = {}
}

resource "aws_lambda_layer_version" "layer" {
  for_each            = data.archive_file.lambda_layers
  layer_name          = each.key
  filename            = each.value.output_path
  source_code_hash    = each.value.output_base64sha256
  compatible_runtimes = ["python3.9", "python3.8"]
}

resource "aws_lambda_function" "functions" {
  for_each         = aws_s3_object.lambda_functions
  function_name    = "${each.key}-${var.app_name}-${var.env_name}"
  role             = aws_iam_role.lambda.arn
  s3_bucket        = each.value.bucket
  s3_key           = each.value.key
  source_code_hash = aws_s3_object.lambda_functions_hash[each.key].content
  handler          = "${each.key}.lambda_handler"
  runtime          = "python3.8"
  layers           = lookup(local.lambda_functions_layers, each.key, [])
  timeout          = 300
  memory_size      = 320
  vpc_config {
    security_group_ids = [
      aws_security_group.lambda.id
    ]
    subnet_ids = var.private_subnets_ids
  }
}
