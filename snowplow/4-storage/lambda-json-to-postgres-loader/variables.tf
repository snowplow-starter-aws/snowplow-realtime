variable "deploy_s3_bucket" {}
variable "deploy_s3_key" {}
variable "trigger_s3_bucket_arn" {}

variable "dwh_database" {}
variable "dwh_host" {}
variable "dwh_port" {}
variable "dwh_username" {}
variable "dwh_password" {}

variable "security_group_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "region" {}
