# module "frontend" {
#   depends_on = [module.backend]
#   source = "./module/app"
#   instance_type = var.instance_type
#   component = "frontend"
#   env = var.env
#   vpc_id = module.vpc.vpc_id
#   subnets = module.vpc.frontend_subnets
#   lb_tg_group  = true
#   lb_internet_type = "public"
#   lb_req = true
#   lb_subnets = module.vpc.public_subnets
#   app_port = 80
#   ssh_user = var.ssh_user
#   ssh_pass = var.ssh_pass
#   bastion_nodes = var.bastion_nodes
#   add_sg_app_port = var.public-subnets
#   access_sg_app_port = ["0.0.0.0/0"]
#   vault_token = var.vault_token
#
# }
# module "backend" {
#   depends_on = [module.rds]
#   source = "./module/app"
#   instance_type = var.instance_type
#   component = "backend"
#   ssh_user = var.ssh_user
#   ssh_pass = var.ssh_pass
#   vault_token = var.vault_token
#   env = var.env
#   vpc_id = module.vpc.vpc_id
#   subnets = module.vpc.backend_subnets
#   lb_tg_group = true
#   lb_internet_type = "private"
#   lb_req = true
#   lb_subnets = module.vpc.backend_subnets
#   app_port = 8080
#   bastion_nodes = var.bastion_nodes
#   add_sg_app_port = concat(var.frontend-subnets,var.backend-subnets)
#   access_sg_app_port = var.frontend-subnets
#   }
module "backend"{
  source = "./module/asg"
  add_sg_app_port   = var.backend-subnets
  app_port          = 8080
  availability_zone = var.availability_zone
  bastion_nodes     = var.bastion_nodes
  component         = "backend-${var.env}-asg"
  env               = var.env
  vpc_id            = module.vpc.vpc_id
  vault_token       = var.vault_token
}
# module "rds"{
#   source = "./module/rds"
#   env = var.env
#   subnet_ids = module.vpc.db_subnets
#   engine = "mysql"
#   engine_version = "8.0.36"
#   component = "rds"
#   allocated_storage = 20
#   family = "mysql8.0"
#   instance_class = "db.t3.micro"
#   storage_type = "gp3"
#   vpc_id = module.vpc.vpc_id
#   access_sg_app_port = var.backend-subnets
#   skip_final_snapshot = true
#   kms_key_id = var.kms_key_id
# }
# module "mysql" {
#   source = "./module/app"
#   instance_type = var.instance_type
#   component = "mysql"
#   env = var.env
#   vpc_id = module.vpc.vpc_id
#   subnets = module.vpc.db_subnets
#   ssh_user = var.ssh_user
#   ssh_pass = var.ssh_pass
#   app_port = 3306
#   bastion_nodes = var.bastion_nodes
#   add_sg_app_port = var.backend-subnets
#   vault_token = var.vault_token
# }
module "vpc" {
  source = "./module/vpc"
  env = var.env
  vpc_cidr_block = var.vpc_cidr_block
  availability_zone = var.availability_zone
  frontend-subnets = var.frontend-subnets
  backend-subnets = var.backend-subnets
  db-subnets =  var.db-subnets
  default_vpc_id = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  default_route-table_id = var.default_route-table_id
  public-subnets = var.public-subnets

}
module "ags"{
source = "./module/asg"
  add_sg_app_port = var.access_sg_app_port
  app_port = 8080
  availability_zone = var.availability_zone
  bastion_nodes = var.bastion_nodes
  component = "backend-dev"
  env = var.env
  vpc_id = module.vpc.vpc_id
  vault_token = var.vault_token
}