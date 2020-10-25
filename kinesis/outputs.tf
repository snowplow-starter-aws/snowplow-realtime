output "collector_good_arn" {
  value = aws_kinesis_stream.good.arn
}

output "collector_bad_arn" {
  value = aws_kinesis_stream.bad.arn
}

output "enriched_good_arn" {
  value = aws_kinesis_stream.good-enriched.arn
}

output "enriched_bad_arn" {
  value = aws_kinesis_stream.bad-enriched.arn
}

output "enriched_good_pii_arn" {
  value = aws_kinesis_stream.good-enriched-pii.arn
}

output "s3_loader_enriched_bad_arn" {
  value = aws_kinesis_stream.s3-loader-bad-enriched.arn
}


output "collector_good_name" {
  value = aws_kinesis_stream.good.name
}

output "collector_bad_name" {
  value = aws_kinesis_stream.bad.name
}

output "enriched_good_name" {
  value = aws_kinesis_stream.good-enriched.name
}

output "enriched_bad_name" {
  value = aws_kinesis_stream.bad-enriched.name
}

output "enriched_good_pii_name" {
  value = aws_kinesis_stream.good-enriched-pii.name
}

output "s3_loader_enriched_bad_name" {
  value = aws_kinesis_stream.s3-loader-bad-enriched.name
}