locals {
  lambdas_path = "${path.module}/lambdas"
}

resource "null_resource" "pip_install" {
  for_each = toset(local.lambda_layers)
  triggers = {
    shell_hash = "${sha256(file("${local.lambdas_path}/layers/${each.key}/requirements.txt"))}"
  }

  provisioner "local-exec" {
    command = "python3 -m pip --isolated install -r ${local.lambdas_path}/layers/${each.key}/requirements.txt -t ${local.lambdas_path}/layers/${each.key}/python"
  }
}

data "archive_file" "lambda_layers" {
  for_each    = null_resource.pip_install
  type        = "zip"
  source_dir  = "${local.lambdas_path}/layers/${each.key}/"
  output_path = "${local.lambdas_path}/layers/${each.key}.zip"
}

data "archive_file" "lambda_functions" {
  for_each         = toset(local.lambda_functions)
  type             = "zip"
  source_file      = "${local.lambdas_path}/${each.key}.py"
  output_file_mode = "0666"
  output_path      = "${local.lambdas_path}/${each.key}.zip"
}

resource "aws_s3_object" "lambda_functions" {
  for_each = data.archive_file.lambda_functions
  bucket   = local.refresh_bucket_id
  key      = "lambdas/${each.key}.zip"
  source   = each.value.output_path
  etag     = each.value.output_md5
}

resource "aws_s3_object" "lambda_functions_hash" {
  for_each = data.archive_file.lambda_functions
  bucket   = local.refresh_bucket_id
  key      = "lambdas/${each.key}.zip.base64sha256"
  content  = each.value.output_base64sha256
}