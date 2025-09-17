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
  name = "foursale-prod"
  tags = {
    Environment = "prod"
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

  instance_types = ["m5.large"]
  desired_size   = 3
  max_size       = 10
  min_size       = 2

  tags = local.tags
}

module "rds" {
  source = "../../modules/rds"

  name               = local.name
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security.rds_security_group_id

  instance_class          = "db.r5.large"
  multi_az               = true
  allocated_storage      = 100
  max_allocated_storage  = 1000
  backup_retention_period = 30
  tags                   = local.tags
}