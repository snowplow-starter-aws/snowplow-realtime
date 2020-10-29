variable "name" {}

variable "instance_class" {
  type = string
}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "subnet_ids" {
  type = list(string)
}

variable "db_user" {}
variable "db_pass" {}
variable "db_name" {}
variable "publicly_accessible" {}
variable "trusted_ip_address" {}