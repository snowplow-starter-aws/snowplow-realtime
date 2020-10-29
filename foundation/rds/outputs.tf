output "host" {
  value = aws_db_instance.postgres.address
}

output "port" {
  value = aws_db_instance.postgres.port
}

output "instance_id" {
  value = aws_db_instance.postgres.name
}


output "username" {
  value = aws_db_instance.postgres.username
}

output "password" {
  value = aws_db_instance.postgres.password
}

output "endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "safe-access-security-group-id" {
  value = aws_security_group.safe-access.id
}

output "safe-access-security-group-name" {
  value = aws_security_group.safe-access.name
}