##########################
# Resource
##########################
resource "aws_codecommit_repository" "this" {
  repository_name = var.name
  description     = var.description
}

##########################
# Outputs
##########################
output "id" {
  value       = aws_codecommit_repository.this.repository_id
}

output "arn" {
  value       = aws_codecommit_repository.this.arn
}

output "clone_url_http" {
  value       = aws_codecommit_repository.this.clone_url_http
}

output "clone_url_ssh" {
  value       = aws_codecommit_repository.this.clone_url_ssh
}
