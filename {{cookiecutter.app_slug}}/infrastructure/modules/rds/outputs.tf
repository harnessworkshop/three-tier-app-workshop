output "db_instance_endpoint" {
  description = "The database instance endpoint without port"
  value       = aws_db_instance.main.address
}

output "db_instance_id" {
  value = aws_db_instance.main.id
}

output "db_name" {
  description = "The name of the database"
  value       = aws_db_instance.main.db_name
} 