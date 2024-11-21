variable "ami" {}
variable "instance_type" {}
variable "component-f" {}
variable "component-b" {}
variable "component-m" {}
variable "component"{
  default = {
    frontend={
      instance_type=""
    }
    backend={
      instance_type=""
    }
    mysql={
      instance_type=""
    }
  }
}

