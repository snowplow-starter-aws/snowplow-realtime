locals {
  function_name = "json-to-postgres-loader"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${local.function_name}-role"

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
  name   = "${local.function_name}-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
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

resource "aws_iam_role_policy_attachment" "lambda-in-vpc" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}





resource "aws_lambda_function" "tsv-to-json-transformer" {
  depends_on = [
    aws_iam_role_policy_attachment.lambda,
  ]
  s3_bucket     = var.deploy_s3_bucket
  s3_key        = var.deploy_s3_key
  function_name = local.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.lambda_handler"

  runtime = "python3.7"

  timeout = 120
  # Default is 3s, this 300s = 5min
  memory_size = 128
  # Default is 128MB

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    security_group_ids = [
    var.security_group_id]
    subnet_ids = var.subnet_ids
  }

  environment {
    variables = {
      DATABASE = var.dwh_database
      HOST     = var.dwh_host
      PORT     = var.dwh_port
      USERNAME = var.dwh_username
      PASSWORD = var.dwh_password
      IN_VPC   = true
    }

  }
  tags = {
    s3-key = var.deploy_s3_key
  }
}