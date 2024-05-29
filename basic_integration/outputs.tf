output "lightlytics_api_url" {
  value = local.lightlytics_api_url
}

output "lightlytics_cloudwatch_role" {
  value = var.enable_cloudtrail ? aws_iam_role.lightlytics-CloudWatch-role[0].arn : null
}

output "lightlytics_flowlogs_role" {
  value = var.enable_flowlogs ? aws_iam_role.lightlytics-FlowLogs-lambda-role[0].arn : null
}

output "lightlytics_iam_activity_role" {
  value = var.enable_iam_activity ? aws_iam_role.lightlytics-IamActivity-lambda-role[0].arn : null
}

output "pvl_vpc" {
  value = local.pvl_vpc
}

output "pvl_subnets" {
  value = local.pvl_subnets
}

output "pvl_security_groups" {
  value = local.pvl_security_groups
}
