module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name    = "flask-vpc"
  cidr    = var.vpc_cidr
  azs     = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
}