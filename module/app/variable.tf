variable "instance_type" {}
variable "component" {}
variable "env" {}
variable "vpc_id" {}
variable "subnets" {}
variable "ssh_user"{}
variable "ssh_pass"{}
variable vault_token{}
variable "add_sg_app_port" {}
variable "lb_tg_group" {
  default = false
}
variable "lb_internet_type" {
  default = null
}
variable "lb_req"{
  default = false
}
variable "lb_subnets" {
  default = null
}
//variable "certificate_arn"{
//  default = null
//}
variable "app_port" {
  default = null
}
variable "bastion_nodes" {}
variable "access_sg_app_port" {
  default = []
}


