resource "aws_instance" "frontend" {
  ami = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "frontend-1"
  }
}
resource "aws_instance" "backend" {
  ami = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "backend-1"
  }
}
resource "aws_instance" "mysql" {
  ami = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "mysql-1"
  }
}
resource "aws_route53_record" "route" {
  name = "${var.component-f}-dev.pdevops72.online"
  type = "A"
  zone_id = "Z09583601MY3QCL7AJKBT"
  records = [aws_instance.frontend.private_ip]
}
//loop the resource
//create a resource one time and create a required instances
resource "aws_instance" "mysql" {
  for_each = var.component
  ami = var.ami["ami"]
  instance_type = var.instance_type["instance_type"]
  tags = {
    Name = each.key
  }
}
//through count
resource "aws_instance" "mysql" {
 count = 2
  ami = ""
  instance_type = ""
  tags = {
    Name = "each.key"
  }
}

