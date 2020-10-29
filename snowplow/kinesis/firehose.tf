resource "aws_iam_role" "firehose-role" {
  name = "firehose-snowplow-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy" "firehose-one-sizes-fits-all" {
  name   = "kinesis-firehose-one-size-fits-all-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "glue:GetTable",
                "glue:GetTableVersion",
                "glue:GetTableVersions"
            ],
            "Resource": "*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "${var.snowplow_bucket_arn}/",
                "${var.snowplow_bucket_arn}/*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-central-1:320039544529:log-group:/aws/kinesisfirehose/*:log-stream:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:eu-central-1:320039544529:key/*"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "kinesis.eu-central-1.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "write-to-bad-stream-prefix" {
  name   = "snowplow-kinesis-firehose-bad-stream"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.snowplow_bucket_arn}/bad-stream/*",
        "${var.snowplow_bucket_arn}/bad-stream-eriched/*"
        ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "read-only-kinesis" {
  role       = aws_iam_role.firehose-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "one-size-fits-all" {
  role       = aws_iam_role.firehose-role.name
  policy_arn = aws_iam_policy.firehose-one-sizes-fits-all.arn
}


resource "aws_iam_role_policy_attachment" "write-to-bad-stream-prefix" {
  role       = aws_iam_role.firehose-role.name
  policy_arn = aws_iam_policy.write-to-bad-stream-prefix.arn
}

resource "aws_kinesis_firehose_delivery_stream" "bad_stream" {
  name        = "bad-stream"
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.bad.arn
    role_arn           = aws_iam_role.firehose-role.arn
  }

  s3_configuration {
    buffer_interval = 60
    buffer_size     = 1
    role_arn        = aws_iam_role.firehose-role.arn
    bucket_arn      = var.snowplow_bucket_arn
    prefix          = "bad-stream/"


    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/bad-stream"
      log_stream_name = "S3Delivery"
    }
  }
}


resource "aws_kinesis_firehose_delivery_stream" "bad_stream_enriched" {
  name        = "bad-stream-enriched"
  destination = "s3"


  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.bad-enriched.arn
    role_arn           = aws_iam_role.firehose-role.arn
  }


  s3_configuration {
    buffer_interval = 60
    buffer_size     = 1
    role_arn        = aws_iam_role.firehose-role.arn
    bucket_arn      = var.snowplow_bucket_arn
    prefix          = "bad-stream-enriched/"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/bad-stream-enriched"
      log_stream_name = "S3Delivery"
    }
  }
}

//resource "aws_kinesis_firehose_delivery_stream" "bad_stream_pii_loader_enriched" {
//  name        = "bad-stream-s3-loader-enriched"
//  destination = "s3"
//
//
//  kinesis_source_configuration {
//    kinesis_stream_arn = aws_kinesis_stream.s3-loader-bad-enriched.arn
//    role_arn           = aws_iam_role.firehose-role.arn
//  }
//
//
//  s3_configuration {
//    buffer_interval = 60
//    buffer_size     = 1
//    role_arn        = aws_iam_role.firehose-role.arn
//    bucket_arn      = var.snowplow_bucket_arn
//    prefix          = "bad-stream-s3-loader-enriched/"
//
//    cloudwatch_logging_options {
//      enabled         = true
//      log_group_name  = "/aws/kinesisfirehose/bad-stream-s3-loader-enriched"
//      log_stream_name = "S3Delivery"
//    }
//  }
//}


resource "aws_kinesis_firehose_delivery_stream" "good_stream_enriched" {
  name        = "good-stream-enriched"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.good-enriched.arn
    role_arn           = aws_iam_role.firehose-role.arn
  }

  extended_s3_configuration {
    buffer_interval = 60
    buffer_size     = 1
    role_arn        = aws_iam_role.firehose-role.arn
    bucket_arn      = var.snowplow_bucket_arn
    prefix          = "good-stream-enriched/"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/good-stream-s3-enriched"
      log_stream_name = "S3Delivery"
    }

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${var.lambda_tsv_to_json_transformer_arn}:$LATEST"
        }
      }
    }
  }

  //
  //  s3_configuration {
  //    buffer_interval = 60
  //    buffer_size     = 1
  //    role_arn        = aws_iam_role.firehose-role.arn
  //    bucket_arn      = var.snowplow_bucket_arn
  //    prefix          = "good-stream-enriched/"
  //
  //
  //
  //    cloudwatch_logging_options {
  //      enabled         = true
  //      log_group_name  = "/aws/kinesisfirehose/good-stream-s3-enriched"
  //      log_stream_name = "S3Delivery"
  //    }
  //
  //  }


}
