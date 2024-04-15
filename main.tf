# This file is used to create step function and associated input json files

locals {
  step_function_input = {
    AppName                    = var.app_name
    EnvName                    = var.env_name
    SourceEFSId                = var.source_efs_id
    EFSId                      = var.efs_id
    DeleteOldEfs               = var.delete_old_efs
    AWSBackupRoleArn           = local.aws_backup_arn
    ItemsToRestore             = jsonencode(var.items_to_restore)
    StoreEfsMetadataInSSM      = var.store_efs_metadata_in_ssm
    EfsIdSSMParameterName      = var.efs_id_ssm_parameter_name
    EfsSubPathSSMParameterName = var.efs_sub_path_ssm_parameter_name
    LambdaEfsFunction          = aws_lambda_function.functions["GetEfsRestoreBackupDirectory"].function_name
    SubnetIDs                  = jsonencode(var.private_subnets_ids)
    SecurityGroupID = jsonencode([
      var.efs_sg_id,
      aws_security_group.lambda.id
    ])
    Encrypted     = var.encrypted
    KmsKeyId      = var.kms_key_id == null ? "" : var.kms_key_id
    DynamoDBTable = aws_dynamodb_table.dynamodbTable.name
    SnsTopicArn   = local.sns_topic_arn
    Tags          = jsonencode(var.tags)
  }
}

resource "aws_sfn_state_machine" "refresh_env" {
  name       = local.name_cc
  role_arn   = aws_iam_role.step_function.arn
  definition = templatefile("${path.module}/templates/step_function_definition.json", local.step_function_input)
}
resource "local_file" "step_function_json_input" {
  content  = templatefile("${path.module}/templates/step_function_input.json", local.step_function_input)
  filename = "step_funcion_input/${local.current_region}/efs-${var.app_name}-${var.env_name}.json"
}

resource "aws_s3_bucket" "refresh_bucket" {
  count         = var.create_s3_bucket ? 1 : 0
  bucket        = var.s3_bucket_name == null ? null : var.s3_bucket_name
  bucket_prefix = var.s3_bucket_name == null ? local.name : null
}
locals {
  refresh_bucket_id = var.s3_bucket_name == null ? (
    var.create_s3_bucket ? aws_s3_bucket.refresh_bucket[0].id : null
  ) : var.s3_bucket_name
}

resource "aws_s3_object" "step_function_json_input" {
  count  = var.put_step_function_input_json_files_on_s3 ? 1 : 0
  bucket = local.refresh_bucket_id
  key    = "efs-json/${local.current_region}/efs-${var.app_name}-${var.env_name}.json"
  source = local_file.step_function_json_input.filename
  etag   = local_file.step_function_json_input.content_md5
}

resource "aws_s3_object" "step_function_json_input_hash" {
  count   = var.put_step_function_input_json_files_on_s3 ? 1 : 0
  bucket  = local.refresh_bucket_id
  key     = "efs-json/${local.current_region}/efs-${var.app_name}-${var.env_name}.json.base64sha256"
  content = local_file.step_function_json_input.content_base64sha256
}
