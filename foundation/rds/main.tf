locals {

  common_tags = {
    Name = var.name
  }
}

resource "aws_db_instance" "postgres" {
  identifier        = var.name
  allocated_storage = "10"
  engine            = "postgres"
  engine_version    = 12.2
  instance_class    = var.instance_class
  name              = var.db_name
  username          = var.db_user
  password          = var.db_pass

  vpc_security_group_ids = [
    aws_security_group.security.id,
  ]
  publicly_accessible = var.publicly_accessible

  db_subnet_group_name = aws_db_subnet_group.this.id
  deletion_protection  = false
  skip_final_snapshot  = true

  tags = local.common_tags
}

resource "aws_security_group" "security" {
  name        = "${var.name}-postgres-instance"
  description = "Controls traffic between nowtilus and postgres"
  vpc_id      = var.vpc_id

  tags = local.common_tags

  # TODO fix rules
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = var.subnet_ids
}
