Connect AWS Account to Stream.Security Terraform Module
===================================================
A terraform module for connecting AWS account to [Stream.Security](https://www.stream.security/) and enabling [real-time events](https://www.stream.security/events) within the account's region.


Prerequisites
-------------
- A Stream.Security account
- Terraform CLI
- AWS credentials configured for use with Terraform


Requirements
------------
- Must be used with Stream.Security Terraform [provider](https://github.com/lightlytics-terraform/lightlytics-provider.git) module


Usage
-----
```hcl
# Configure Lightlytics Terraform Provider host and credentials
terraform {
  required_providers {
    lightlytics = {
      version   = "0.2"
      source    = "lightlytics.com/api/lightlytics"
    }
  }
}

provider "lightlytics" {
  host         = "<https://<env_name>.lightlytics.com>"
  username     = "<Your_Lightlytics_Login_Email>"
  password     = "<Your_Lightlytics_Login_Password>"
  workspace_id = "<Your_Lightlytics_Workspace_ID>"  ## Can be obtained from Lightlytics platform, if not specified, it will use the first WS
}

# Configure AWS Account
resource "lightlytics_account" "aws" {
  account_type     = "AWS"
  cloud_account_id = "<Your_Cloud_Provider_Account_ID>"
  display_name     = "<Your_Desired_Lightlytics_Integration_Display_Name>"
  stack_region     = "us-east-1"
  cloud_regions    = ["us-east-1", "us-east-2"]
}

# Connect AWS account to Lightlytics (Basic Integration)
module "lightlytics" {
  providers = {
    aws = aws.us-east-1
  }
  source = "github.com/lightlytics-terraform/lightlytics-module/basic_integration"
  environment                    = "<Your_Organization_Name_From_The_URL>" 
  cloud_account_id               = "lightlytics_account.<Lightlytics_provider_resource>.cloud_account_id"
  Lightlytics_internal_accountID = "lightlytics_account.<Lightlytics_provider_resource>.id"
  lightlytics_account_externalID = "lightlytics_account.<Lightlytics_provider_resource>.external_id"
  lightlytics_auth_token         = "lightlytics_account.<Lightlytics_provider_resource>.account_auth_token"
}

# Enable Real-time Events
module "lightlytics-collection-us-east-1" {
  source = "github.com/lightlytics-terraform/lightlytics-module/collection_lambda"
  providers = {
    aws = aws.us-east-1
  }
  environment                  = "<Your_Organization_Name_From_The_URL>"
  cloud_account_id             = "lightlytics_account.<Lightlytics_provider_resource>.cloud_account_id"
  lightlytics_collection_token = "lightlytics_account.<Lightlytics_provider_resource>.lightlytics_collection_token"
  lightlytics_cloudwatch_role  = module.lightlytics.lightlytics_cloudwatch_role
}

# Enable Network Traffic Activity (VPC Flow Logs)
module "flow-logs-us-east-1" {
  source = "github.com/lightlytics-terraform/lightlytics-module/flowlogs_lambda"
  environment                  = "<Your_Organization_Name_From_The_URL>"
  lightlytics_collection_token = "lightlytics_account.<Lightlytics_provider_resource>.lightlytics_collection_token"
  vpc_flowlogs_ids             = ["vpc-1234","vpc-5678"]
  lightlytics_flowlogs_role    = module.lightlytics-module.lightlytics_flowlogs_role
  flowlogs_bucket_name         = "<Your_Existing_Flow_Logs_S3_Bucket>"
}

# Enable Identity Activity (IAM Logs)
module "iam-activity-logs-us-east-1" {
  source = "github.com/lightlytics-terraform/lightlytics-module/iam_activity_lambda"
  environment                   = "<Your_Organization_Name_From_The_URL>"
  lightlytics_collection_token  = "lightlytics_account.<Lightlytics_provider_resource>.lightlytics_collection_token"
  lightlytics_iam_activity_role = module.lightlytics-module.lightlytics_iam_activity_role
  iam_activity_bucket_name      = "<Your_S3_Bucket_Name_Storing_CloudTrail_Events>"
}

```

Examples
--------
- [Single Region Basic Integration](https://github.com/lightlytics-terraform/lightlytics-module/tree/main/examples/single%20region%20basic%20integration)
- [Single Region with Network Traffic Activity (VPC Flow Logs)](https://github.com/lightlytics-terraform/lightlytics-module/tree/main/examples/single%20region%20with%20identity%20activity%20(iam%20logs))
- [Single Region with Identity Activity (IAM Logs)](https://github.com/lightlytics-terraform/lightlytics-module/tree/main/examples/single%20region%20with%20identity%20activity%20(iam%20logs))
- [Multi Region Basic Integration](https://github.com/lightlytics-terraform/lightlytics-module/tree/main/examples/multi%20region%20basic%20integration)


Inputs
------
| Variable Name                      | Description                                                                | Notes                                               		   | Type           | Required? | Default |
|:-----------------------------------|:---------------------------------------------------------------------------|:------------------------------------------------------------|:---------------|:--------- |:--------|
| host                               | Your environment URL including https://                                    | e.g `https://org.streamsec.io`                   		   | `string`       | Yes       | n/a     |
| username                           | Your Stream.Security user Email                                                |                                                     		   | `string`       | Yes       | n/a     |
| password                           | Your Stream.Security user password                                             |                                                     		   | `string`       | Yes       | n/a     |
| workspace_id                       | Can be obtained from Stream.Security platform                                  | Will use default workspace in case not specified   		   | `string`       | No        | n/a     |
| cloud_account_id                   | Your Cloud Provider account ID                                             |                       			                 		   | `string`       | Yes       | n/a     |
| display_name                       | Your integration display name within Stream.Security platform                  |                                                  		   | `string`       | No       | n/a     |
| stack_region                       | The primary region where Stream.Security read access resources will be created |                                                   		   | `string`       | Yes       | n/a     |
| cloud_regions                      | List of desired regions to be scanned                                      | us-east-1 region is mandatory for the integration  		   | `list(string)` | Yes       | n/a     | 
| environment                        | Your organization name from the URL     									 | Only the name, e.g mike from `https://mike.streamsec.io` | `string`       | Yes       | n/a     |
| Lightlytics_internal_accountID     | Stream.Security internal account ID       								     |                                                             | `string`       | Yes       | n/a     |
| lightlytics_account_externalID     | Stream.Security external account ID        									 |                                                             | `string`       | Yes       | n/a     |
| lightlytics_auth_token             | Stream.Security authentocation token        									 |                                                             | `string`       | Yes       | n/a     | 
| enable_cloudtrail                  | Enables Stream.Security real-time events                                       |															   | `bool`         | No        | `true`  |
| create_cloud_trail                 | Creates a CloudTrail to capture all compatible management events           |                                                             | `bool`         | No        | `false` |
| enable_flowlogs                    | Enables Stream.Security network traffic activity (VPC flow logs)               |															   | `bool`         | No        | `true`  |
| enable_iam_activity                | Enables Stream.Security identity activity (IAM logs)							 |															   | `bool`         | No        | `true`  |
| s3_force_destroy                   | Deletes the created S3 bucket upon destroy     						     |															   | `bool`         | No        | `true`  |
| lightlytics_collection_token       | Stream.Security collection token          								     |                                                             | `int`          | Yes       | n/a     |
| lightlytics_cloudwatch_role        | Lightlytic CloudWatch role arn         									 |                                                             | `string`       | Yes       | n/a     |
| lightlytics_flowlogs_role          | Stream.Security role arn                                                       |															   | `string`       | Yes       | n/a     |
| vpc_flowlogs_ids					              | List of VPC IDs for creating flowlogs                                      |   														   | `list(string)` | No        | n/a     |
| create_new_flowlogs_bucket		       | Creates new S3 bucket to publish flow logs data to                         |                                                             | `bool`         | No        | `false` |
| flowlogs_bucket_name               | Your existing S3 bucket flow logs are published to                         | Required if `create_new_flowlogs_bucket` set to false       | `string`       | No        | n/a     | 
| lightlytics_iam_activity_role      | Stream.Security IAM Activity role arn            								 |                                                             | `string`       | Yes       | n/a     |
| iam_activity_bucket_name           | Your S3 bucket name storing CloudTrail events 							 |                                                             | `string`       | Yes       | n/a     |


Stream.Security Featured Products
=============================

[Connect AWS Account to Stream.Security Terraform Module (basic_integration)](https://github.com/lightlytics-terraform/lightlytics-module/tree/main/basic_integration#lightlytics-terraform-module---basic-integration)
-----------------------------------------------------------------------
- This module connects your AWS account to [Stream.Security](https://www.stream.security/) and triggers your account initial scan.


[Stream.Security Real-Time Events Collection Terraform Module (collection_lambda)](https://github.com/lightlytics-terraform/lightlytics-module/tree/main/collection_lambda#lightlytics-real-time-events-collection-terraform-module)
----------------------------------------------------------------------------
- This module enables Stream.Security to receive real-time events of your AWS account based on AWS CloudWatch. Integrating with this module will help you track cloud configuration changes with a complete context of who, what, where, and when while providing impact analysis of your cloud environment in real time.


[Stream.Security Network Traffic Activity (Flow Logs) Terraform Module (flowlogs_lambda)](https://github.com/lightlytics-terraform/lightlytics-module/tree/main/flowlogs_lambda#lightlytics-network-traffic-activity-flow-logs-terraform-module)
-----------------------------------------------------------------------------------
- This module is in charge of creating VPC flow logs with a custom format and sending it over to Stream.Security. Integrating with this module will help you analyze and troubleshoot network traffic activity and quickly identify issues in your cloud environments using enriched and detailed logs across VPCs, services, clusters, workloads, network components, and much more.


[Stream.Security Identity Activity (IAM Logs) Terraform Module (iam_activity_lambda)](https://github.com/lightlytics-terraform/lightlytics-module/tree/main/iam_activity_lambda#lightlytics-identity-activity-iam-logs-terraform-module)
-------------------------------------------------------------------------------
- This module creates and collects CloudTrail logs to provide visibility of how identities are being assumed and used across your AWS environment. Integrating with this module will help you monitor and analyze any identity (Identity Access Management - IAM) activity in your account with automatic correlation to your cloud resources.


Stream.Security Cost
----------------
- Coming soon...


## Providers
| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.70.0 |


Documentation
-------------
If you're new to Stream.Security and want to get started, feel free to [contact us](https://www.stream.security/contact-us) or checkout our [documentation](https://docs.streamsec.io/) website.


Community
---------
- Comming soon...


Getting Help
------------
Please use these resources for getting help:
- Email: support@stream.security
