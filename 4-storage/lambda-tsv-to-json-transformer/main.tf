resource "aws_iam_role" "iam_for_lambda" {
  name = "lambda-tsv-to-json-transformer-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy" "tsv-to-json-transformer-policy" {
  name   = "lambda-tsv-to-json-transformer-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Resource": ["${var.trigger_s3_bucket_arn}/*"],
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*",
        "events:*",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:ListRolePolicies",
        "iam:ListRoles",
        "iam:PassRole",
        "kms:ListAliases",
        "logs:*",
        "tag:GetResources",
        "xray:PutTelemetryRecords",
        "xray:PutTraceSegments"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.tsv-to-json-transformer-policy.arn
}


resource "aws_lambda_function" "tsv-to-json-transformer" {
  depends_on = [
    aws_iam_role_policy_attachment.lambda,
  ]
  s3_bucket     = var.deploy_s3_bucket
  s3_key        = var.deploy_s3_key
  function_name = "tsv-to-json-transformer"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.lambda_handler"

  runtime = "python3.7"

  timeout     = 60  # Default is 3s, this 300s = 5min
  memory_size = 128 # Default is 128MB

  tags = {
    s3-key = var.deploy_s3_key
  }

}
