module "expense" {
  source = "./module/app"
  aws_ami = var.ami
  aws_instance_type = var.instance_type

}

//pass this input values of the variables to module(directory)