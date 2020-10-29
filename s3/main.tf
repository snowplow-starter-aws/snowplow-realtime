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

