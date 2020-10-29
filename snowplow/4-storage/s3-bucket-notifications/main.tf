resource "aws_lambda_permission" "exec-from-s3" {
  for_each = toset([
  for lambda_notification in var.lambda_notifications :
  lambda_notification.lambda_arn
  ])

  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = each.value
  principal = "s3.amazonaws.com"
  source_arn = var.bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket

  dynamic "lambda_function" {
    for_each = var.lambda_notifications

    content {
      lambda_function_arn = lambda_function.value.lambda_arn
      events = lambda_function.value.events
      filter_prefix = lambda_function.value.filter_prefix
    }
  }

  depends_on = [
    aws_lambda_permission.exec-from-s3]
}
