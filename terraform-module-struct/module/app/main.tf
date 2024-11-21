resource "aws_instance" "frontend" {
  ami = var.aws_ami
  instance_type = var.aws_instance_type
  vpc_security_group_ids = [data.aws_security_group.selected.id]
  tags = {
    Name = "frontend-1"
  }
}
resource "aws_instance" "backend" {
  ami = var.aws_ami
  instance_type = var.aws_instance_type
  tags = {
    Name = "backend-1"
  }
}
resource "aws_instance" "mysql" {
  ami = var.aws_ami
  instance_type = var.aws_instance_type
  tags = {
    Name = "mysql-1"
  }
}
