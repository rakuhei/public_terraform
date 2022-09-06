data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.tfstate_bucket
    key    = "tfstates/iam.tfstate"
    region = "ap-northeast-1"
  }
}
