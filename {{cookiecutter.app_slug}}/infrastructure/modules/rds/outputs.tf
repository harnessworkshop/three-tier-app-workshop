output "db_instance_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_instance_id" {
  value = aws_db_instance.main.id
}

output "db_name" {
  description = "The name of the database"
  value       = aws_db_instance.main.db_name
} 