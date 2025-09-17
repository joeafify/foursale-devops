terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  name = "foursale-dev"
  tags = {
    Environment = "dev"
    Project     = "foursale"
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name = local.name
  tags = local.tags
}

module "security" {
  source = "../../modules/security"

  name   = local.name
  vpc_id = module.vpc.vpc_id
  tags   = local.tags
}

module "eks" {
  source = "../../modules/eks"

  name                      = local.name
  public_subnet_ids         = module.vpc.public_subnet_ids
  private_subnet_ids        = module.vpc.private_subnet_ids
  cluster_security_group_id = module.security.eks_cluster_security_group_id

  instance_types = ["t3.medium"]
  desired_size   = 2
  max_size       = 4
  min_size       = 1

  tags = local.tags
}

module "rds" {
  source = "../../modules/rds"

  name               = local.name
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security.rds_security_group_id

  instance_class = "db.t3.micro"
  multi_az       = false
  tags           = local.tags
}