terraform {
  cloud {
    organization = "bashaus"

    workspaces {
      project = "bashkim-cms"
      name    = "production"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0"
    }
  }
}
