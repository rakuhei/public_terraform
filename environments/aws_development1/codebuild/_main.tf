terraform {
  backend "s3" {
    bucket = var.tfstate_bucket
    key    = "tfstates/${var.envshort}/builders.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      Service  = var.service
      Env      = var.env
      EnvShort = var.envshort
    }
  }
}

data "aws_caller_identity" "self" {
}
