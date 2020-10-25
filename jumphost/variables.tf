variable "ami_id" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "key_name" {}
variable "instance_type" {
  default = "t3.small"
}