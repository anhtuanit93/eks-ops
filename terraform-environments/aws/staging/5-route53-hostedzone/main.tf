locals {
  aws_region  = "us-east-1"
  domain_name = "k8s.staging.tuantrandevops.com"
  tags = {
    ops_env              = "staging"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/staging/5-route53-hostedzone",
    ops_owners           = "devops",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "remote" {
    # Update to your Terraform Cloud organization
    organization = "aws_deepdive"

    workspaces {
      name = "kubernetes-ops-staging-5-route53-hostedzone"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#
# Route53 Hosted Zone
#
module "route53-hostedzone" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/route53/hosted-zone?ref=v1.0.30"

  domain_name = local.domain_name
  tags        = local.tags
}
