variable "env"{}
variable "component"{}
variable "vpc_id"{}
variable "bastion_nodes"{}
variable "app_port"{}
variable "add_sg_app_port"{}
variable "availability_zone"{}
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
variable "vault_token"{}