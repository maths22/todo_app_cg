provider "aws" {
  version = "~> 1.43.0"
  region  = "${var.cg_region}"
}

data "aws_caller_identity" "current" {}

variable "cg_environment" {
  type = "string"
}

variable "cg_region" {
  type = "string"
}

variable "cg_app_name" {
  type = "string"
}

data "aws_cloudformation_stack" "compute-v2" {
  name = "${var.cg_app_name}-${var.cg_environment}-compute-v2"
}

data "aws_route53_zone" "inseng" {
  name         = "inseng.net."
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.inseng.zone_id}"
  name    = "jburroughs-todoapp.inseng.net"
  type    = "CNAME"
  ttl     = "300"
  records = ["${data.aws_cloudformation_stack.compute-v2.outputs["LoadBalancerwebEndpoint"]}"]
}