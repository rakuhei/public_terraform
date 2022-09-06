module "deploy_terraform_codebuild" {
  source      = "../../../modules_aws/resources/codebuild/codebuild_github"

  name        = "deploy_terraform_codebuild" 
  description = "terraform deploy codebuild"
  service_role  = data.terraform_remote_state.iam.outputs.iam_role_build_deploy.arn
  build_timeout = "30"

  # artifacts
  artifacts_type = "NO_ARTIFACTS"

  #cache
  cache_type  = "LOCAL"
  cache_modes = ["LOCAL_DOCKER_LAYER_CACHE"]

  # environment
  compute_type = var.compute_type
  environment_dockerimage = var.environment_dockerimage
  environment_dockerimage_type = var.environment_dockerimage_type
  image_pull_credentials_type = var.image_pull_credentials_type

  environment_variables = [
    {
      name = "ENV"
      value = var.env
    },
    {
      name = "DEPLOYDIR"
      value = "codebuild"
    },
  ]
  
  # vpc_config
  vpc_id = ""
  subnets = []
  security_group_ids = []

  # logs_config
  cloudwatchlogs_groupname = data.terraform_remote_state.cloudwatchlogs.outputs.codebuild_terraform_build.name
  cloudwatchlogs_stream_name = "deploy_codebuild"

  # source
  source_type = "GITHUB"
  source_location = "${var.github_url}/rakuhei/terraform.git"
  git_clone_depth = "1"
  fetch_submodules = false
  source_version = "develop"


  tags = {
    Name = "${var.common_name}-${var.env}-deploy"
    Env = var.env
    System = var.common_name
  }
}

# output "deploy_terraform_codebuild" {
#   value = {
#     id              = module.deploy_terraform_codebuild.id
#     arn             = module.deploy_terraform_codebuild.arn
#   }
# }

module "deploy_terraform_codebuild_trigger" {
  source      = "../../../modules_aws/resources/codebuild_webhook"
  project_name = module.deploy_terraform_codebuild.arn
  build_type = "BUILD"

  filter = [
    {
      type = "EVENT"
      pattern = "PUSH"
    },
    {
      type    = "HEAD_REF"
      pattern = "develop"
    }
  ]

}
