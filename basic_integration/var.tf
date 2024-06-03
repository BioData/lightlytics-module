###############------------Global-----------#############

variable "environment" {}
variable "cloud_account_id" {}
variable "Lightlytics_internal_accountID" {
  sensitive = true
}
variable "lightlytics_account_externalID" {
  sensitive = true
}
variable "lightlytics_auth_token" {
  sensitive = true
}
data "aws_region" "current" {}

###############------------Optional Name for IAM policies and roles ----------------#############

variable "scan_role_name" {
  description = "overwrite the default xxx-lightlytics-role name."
  type        = string
  default     = null   
}
variable "scan_policy_name" {
  description = "overwrite thedefault xxx--lightlytics-policyX name."
  type        = string
  default     = null
}

variable "init_role_name" {
  description = "overwrite the default xxx-lightlytics-init-role name."
  type        = string
  default     = null
}
variable "init_policy_name" {
  description = "overwrite the default lightlytics-init-policy name."
  type        = string
  default     = null
}

variable "iam_activity_role_name" {
  description = "overwrite the default xxx-lightlytics-IamActivity-role name."
  type        = string
  default     = null
}
variable "iam_activity_policy_name" {
  description = "overwrite the defualt xxx-lightlytics-IamActivity-lambda-policy  name."
  type        = string
  default     = null
}

variable "flowlogs_role_name" {
  description = "overwrite the default xxx-lightlytics-FlowLogs-role name."
  type        = string
  default     = null
}
variable "flowlogs_policy_name" {
  description = "overwrite the default xxx-lightlytics-FlowLogs-lambda-policy name."
  type        = string
  default     = null
}
variable "flowlogs_secret_policy_name" {
  description = "overwrite the default xxx-lightlytics-flowlogs-secret-policy name."
  type        = string
  default     = null
}

variable "cloudwatch_role_name" {
  description = "overwrite the  default xxx-lightlytics-CloudWatch-role name."
  type        = string
  default     = null
}
variable "cloudwatch_policy_name" {
  description = "overwrite the default xxx-lightlytics-CloudWatch-policy name."
  type        = string
  default     = null
}
variable "cloudwatch_secret_policy_name" {
  description = "overwrite the default xxx-lightlytics-secret-policy name."
  type        = string
  default     = null
}

###############------------Environment-----------#############

variable "domain_name" {
  default = "streamsec.io"
}
variable "lightlytics_bucket" {
  default = "prod-lightlytics-artifacts"
}
variable "type_env" {
  default = "prod"
}
variable "lightlytics_account" {
  default = "624907860825"
}
variable "init_stack_version" {
  default = 1
}

###############----------Init-------------#############

variable "lambda_init_memory_size" {
  default = 128
}
variable "lambda_init_timeout" {
  default = 900
}
variable "lambda_init_max_event_age" {
  default = 21600
}
variable "lambda_init_max_retry" {
  default = 2
}
#variable "lambda_init_architectures" {                                 # requires aws provider 3.61
#  default = ["x86_64"]
#}

###############------------Optional-----------#############

variable "enable_flowlogs" {
  default = true
  type = bool
}
variable "enable_cloudtrail" {
  default = true
  type = bool
}
variable "s3_force_destroy" {
  type = bool
  default = true
}
variable "create_cloud_trail" {
  type = bool
  default = false
}
variable "enable_iam_activity" {
  default = true
  type = bool
}

###############------------Private link-----------#############

variable "create_pvl_endpoint" {
  default = false
}
variable "create_s3_endpoint" {
  default = false
}
variable "create_pvl_vpc" {
  default = false
}
variable "pvl_vpc_id" {
  default = ""
}
variable "lightlytics_endpoint_service_name" {
  default = ""
}
variable "pvl_subnets_ids" {
  type = list(string)
  default = []
}
variable "pvl_security_group_ids" {
  type = list(string)
  default = []
}
