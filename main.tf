# This file is used to create step function and associated input json files

locals {
  step_function_input = {
    for app_name, app_input in var.efs_to_refresh : app_name => {
      AppName          = app_name
      Encrypted        = app_input.Encrypted
      KmsKeyId         = app_input.KmsKeyId
      SourceEFSName    = app_input.SourceEFSName
      EFSName          = app_input.EFSName
      AWSBackupRoleArn = local.aws_backup_arn
      ItemsToRestore   = app_input.ItemsToRestore
      DynamoDBTable    = aws_dynamodb_table.dynamodbTable.name
      SnsTopicArn      = local.sns_topic_arn
    }
  }
}

resource "aws_sfn_state_machine" "refresh_env" {
  name       = "${local.name_cc}Efs"
  role_arn   = aws_iam_role.step_function.arn
  definition = templatefile("${path.module}/templates/step_function_definition.json", {})
}
resource "local_file" "step_function_json_input" {
  for_each = local.step_function_input
  content  = templatefile("${path.module}/templates/step_function_input.json", each.value)
  filename = "${path.module}/files/efs-json/${local.current_region}/efs-${each.key}.json"
}

resource "aws_s3_bucket" "refresh_bucket" {
  count         = var.create_s3_bucket ? 1 : 0
  bucket        = var.s3_bucket_name == null ? null : var.s3_bucket_name
  bucket_prefix = var.s3_bucket_name == null ? local.name : null
}
locals {
  refresh_bucket_id = var.s3_bucket_name == null ? aws_s3_bucket.refresh_bucket[0].id : var.s3_bucket_name
}

resource "aws_s3_object" "step_function_json_input" {
  for_each = var.put_step_function_input_json_files_on_s3 ? local.step_function_input : {}
  bucket   = local.refresh_bucket_id
  key      = "efs-json/${local.current_region}/efs-${each.key}.json"
  source   = local_file.step_function_json_input[each.key].filename
  etag     = local_file.step_function_json_input[each.key].content_md5
}

resource "aws_s3_object" "step_function_json_input_hash" {
  for_each = var.put_step_function_input_json_files_on_s3 ? local.step_function_input : {}
  bucket   = local.refresh_bucket_id
  key      = "efs-json/${local.current_region}/efs-${each.key}.json.base64sha256"
  content  = local_file.step_function_json_input[each.key].content_base64sha256
}
