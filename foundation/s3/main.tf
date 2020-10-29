resource "aws_s3_bucket" "tracking" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket" "lambda-artifacts" {
  bucket        = var.artifacts_bucket_name
  acl           = "private"
  force_destroy = true
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
  var.route_table_id]
}