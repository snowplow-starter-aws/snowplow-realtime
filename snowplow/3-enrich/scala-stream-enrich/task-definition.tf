data "aws_iam_policy_document" "ecs_task_assume_role" {

  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "snowplow-stream-enrich-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "snowplow-stream-enrich-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "task" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role = aws_iam_role.ecs_task_role.id
}

resource "aws_iam_role_policy_attachment" "execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role = aws_iam_role.ecs_execution_role.id
}

resource "aws_iam_policy" "ecs-execution" {
  name = "snowplow-stream-enrich-ecs-execution"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "ec2:DescribeVolumes",
        "ec2:DescribeTags",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:CreateLogStream",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs-task" {
  name = "snowplow-stream-enrich-ecs-task"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
    "Effect": "Allow",
      "Action": [
        "kinesis:*"
      ],
      "Resource": [
        "*"
      ]
    },{
      "Effect": "Allow",
        "Action": [
          "s3:*"
        ],
        "Resource": [
          "*"
        ]
      },{
      "Effect": "Allow",
        "Action": [
          "dynamodb:*"
        ],
        "Resource": [
          "*"
        ]
      },
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListShards"
      ],
      "Resource": [
        "${var.collector_stream_good_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "kinesis:ListStreams"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:PutRecord",
        "kinesis:PutRecords"
      ],
      "Resource": [
        "${var.enricher_stream_good_arn}",
        "${var.enricher_stream_bad_arn}",
        "${var.enricher_stream_good_pii_arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:CreateTable",
        "dynamodb:DescribeTable",
        "dynamodb:Scan",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": [
        "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${var.enricher_state_table}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task-ext" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs-task.arn
}

resource "aws_iam_role_policy_attachment" "execution-ext" {
  role = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs-execution.arn
}

resource "aws_ecs_task_definition" "task" {

  cpu = var.task_cpu
  memory = var.task_memory
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_role.arn
  family = local.name
  requires_compatibilities = [
    "EC2"]

  container_definitions = <<EOF
[
  {
    "essential": true,
    "image": "${var.image}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-create-group": "true",
        "awslogs-group": "/ecs/snowplow",
        "awslogs-region": "eu-central-1",
        "awslogs-stream-prefix": "${local.name}"
      }
    },
    "name": "${local.name}"
  }
]
EOF
}
