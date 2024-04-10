data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  current_account_id = data.aws_caller_identity.current.account_id
  current_region     = data.aws_region.current.name

  app_name = "refresh-env-efs-${var.app_name}-${var.env_name}"

  name    = local.app_name
  name_cc = replace(title(local.name), "-", "")
}
