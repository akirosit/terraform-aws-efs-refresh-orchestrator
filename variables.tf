variable "vpc_id" {
  description = "The VPC ID (where lambda functions will be deployed)"
}

variable "private_subnets_ids" {
  description = "The private subnets IDs (where lambda functions will be deployed)"
  type        = list(string)
}

variable "source_efs_name" {
  description = "The source EFS Name"
  type        = string
}

variable "efs_name" {
  description = "The EFS name to be refreshed"
  type        = string
}

variable "efs_sg_id" {
  description = "The EFS security group ID"
  type        = string
}

variable "delete_old_efs" {
  description = "Delete old EFS"
  type        = bool
  default     = false
}

variable "items_to_restore" {
  description = "Items to restore from source EFS"
  type        = list(string)
}

variable "encrypted" {
  description = "New/refresh cluster is encrypted"
  default     = false
}

variable "kms_key_id" {
  description = "KMS key to encrypt new/refresh cluster"
  type        = string
  default     = null
}

variable "store_efs_metadata_in_ssm" {
  description = "Store EFS ID and sub path in SSM"
  type        = bool
  default     = false
}
variable "efs_id_ssm_parameter_name" {
  description = "SSM parameter name to store the EFS ID"
  type        = string
}

variable "efs_sub_path_ssm_parameter_name" {
  description = "SSM parameter name to store the EFS sub path"
  type        = string
}

variable "sns_topic_arn" {
  description = "Existing SNS topic ARN to send notifications"
  type        = string
  default     = null
}
variable "create_s3_bucket" {
  description = "Create S3 bucket to put step function input json files"
  type        = bool
  default     = false
}
variable "put_step_function_input_json_files_on_s3" {
  description = "Push or not step function input json files to S3 bucket"
  type        = bool
  default     = false
}
variable "s3_bucket_name" {
  description = "Name of the bucket s3 created within this module or existing S3 name to put step function input json files"
  type        = string
  default     = null
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}