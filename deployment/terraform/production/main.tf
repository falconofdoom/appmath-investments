terraform {
  backend "s3" {
    bucket = "appmath-investments"
    key    = "us-east-1/appmath-investments-app-frontend/production.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Name    = "appmath-investments-app-${local.environment}"
      app     = "appmath-investments-app-frontend"
      env     = "${local.environment}"
      project = "appmath-investments"
      repo    = "https://github.com/falconofdoom/appmath-investments"
    }
  }
}


data "aws_route53_zone" "appmath_hosted_zone" {
  name = "${local.domain}"
}

resource "aws_route53_record" "appmath_investments_frontend_cname" {
  zone_id = data.aws_route53_zone.appmath_hosted_zone.zone_id
  name = "investments.${local.domain}"
  type = "CNAME"
  ttl = 1800

  records = [
    "falconofdoom.github.io"
  ]
}


locals {
  domain = "farrabs.com"
  environment = "production"
}