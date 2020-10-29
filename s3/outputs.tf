output "tracking_bucket" {
  value = aws_s3_bucket.tracking.bucket
}

output "tracking_arn" {
  value = aws_s3_bucket.tracking.arn
}

output "artifacts_bucket" {
  value = aws_s3_bucket.tracking.bucket
}

output "artifacts_arn" {
  value = aws_s3_bucket.tracking.arn
}
