# Terraform Module 

This is a Terraform module for deploying the EFS refresh orchestrator on AWS.

## How to Use This Module

Basic Example :

```hcl
module "refresh_efs" {
  source = "akirosit/efs-refresh-orchestrator/aws"

  efs_to_refresh = {
    "app" = {
      SourceEFSName            = aws_efs_file_system.prod.creation_token
      EFSName                  = aws_efs_file_system.preprod.creation_token
      EFSArn                   = aws_efs_file_system.preprod.arn
      Encrypted                = true
      KmsKeyId                 = aws_kms_alias.efs.arn
    }
  }

}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_efs_to_refresh"></a> [efs\_to\_refresh](#input\_efs\_to\_refresh) | n/a | <pre>map(object({<br>    SourceEFSName  = string<br>    EFSName        = string<br>    EFSArn         = string<br>    KmsKeyId       = string<br>    ItemsToRestore = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | Existing SNS topic ARN to send notifications | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_step_function"></a> [iam\_role\_step\_function](#output\_iam\_role\_step\_function) | n/a |
| <a name="output_state_machine_name"></a> [state\_machine\_name](#output\_state\_machine\_name) | n/a |
| <a name="output_step_function_dynamodb_arn"></a> [step\_function\_dynamodb\_arn](#output\_step\_function\_dynamodb\_arn) | n/a |
| <a name="output_step_function_json_files"></a> [step\_function\_json\_files](#output\_step\_function\_json\_files) | n/a |
| <a name="output_step_function_sns_arn"></a> [step\_function\_sns\_arn](#output\_step\_function\_sns\_arn) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.dynamodbTable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.step_function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.step_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.step_function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_object.step_function_json_input](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.step_function_json_input_hash](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_sfn_state_machine.refresh_env_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |
| [aws_sns_topic.refresh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [local_file.step_function_json_efs_input](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_from_step_functions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.step_function_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
