module "terraform_repository" {
  source      = "../../../modules_aws/resources/codecommit"
  name        = "terraform_repository" 
  description = "cicd terraform test"
}

# output "test_repository" {
#   value = {
#     id                   = module.test_repository.id
#     arn                  = module.test_repository.arn
#     clone_url_http       = module.test_repository.clone_url_http
#     clone_url_ssh        = module.test_repository.clone_url_ssh
#   }
# }

