output "tracking_bucket" {
  value = aws_s3_bucket.tracking.bucket
}

output "tracking_arn" {
  value = aws_s3_bucket.tracking.arn
}
