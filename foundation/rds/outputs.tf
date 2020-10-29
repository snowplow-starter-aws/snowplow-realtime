output "host" {
  value = aws_db_instance.postgres.address
}

output "port" {
  value = aws_db_instance.postgres.port
}

output "instance_id" {
  value = aws_db_instance.postgres.name
}

output "password" {
  value = aws_db_instance.postgres.password
}

output "endpoint" {
  value = aws_db_instance.postgres.endpoint
}