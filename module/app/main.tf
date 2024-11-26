resource "aws_security_group" "security" {
  name        = "security-${var.component}-${var.env}"
  description = "security-${var.component}-${var.env}"
  vpc_id      = var.vpc_id
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = var.bastion_nodes
  }
  ingress {
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "TCP"
    cidr_blocks      = var.add_sg_app_port
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-${var.component}"
  }
}
resource "aws_security_group" "lb_security" {
  count       = var.lb_req ? 1 : 0
  name        = "security-${var.component}-${var.env}-lb"
  description = "security-${var.component}-${var.env}-lb"
  vpc_id      = var.vpc_id
   ingress {
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "TCP"
    cidr_blocks      = var.access_sg_app_port
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-${var.component}-lb"
  }
}

resource "aws_instance" "component" {
  ami = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.security.id]
  subnet_id = var.subnets[0]
     instance_market_options {
      market_type = "spot"
      spot_options {
        instance_interruption_behavior = "stop"
        spot_instance_type             = "persistent"
      }
    }
    tags = {
    Name = var.component
    monitor= "yes"
  }
  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}
resource "null_resource" "provisioner" {
  provisioner "remote-exec" {
    connection {
      type         = "ssh"
      user         =  jsondecode(data.vault_generic_secret.vault-secrets.data_json).ansible_user
      password     =  jsondecode(data.vault_generic_secret.vault-secrets.data_json).ansible_password
      host         = aws_instance.component.private_ip
      port         = 22
    }
    inline = [
      "sudo pip3.11 install ansible",
      "ansible-pull -i localhost. -U https://github.com/pdevpos/learn-ansible get_secrets_vault.yml -e env=${var.env} -e component_nam=${var.component} -e vault_token=${var.vault_token}",
       "ansible-pull -i localhost, -U https://github.com/pdevpos/learn-ansible expense.yml -e env=${var.env} -e component_name=${var.component} -e @~/secrets.json"
#       "ansible-pull -i localhost, -U https://github.com/pdevpos/learn-ansible expense.yml -e env=${var.env} -e component_name=${var.component} -e @secrets.json -e app.json"

    ]
  }
}
resource "aws_route53_record" "route" {
  name               = "${var.component}-${var.env}.pdevops72.online"
  type               = "A"
  zone_id            = "Z09583601MY3QCL7AJKBT"
  records            = [aws_instance.component.private_ip]
  ttl                = 30
}
resource "aws_route53_record" "route-lb-dns" {
  count              = var.lb_req ? 1 : 0
  name               = "lb-${var.component}-${var.env}.pdevops72.online"
  type               = "CNAME"
  zone_id            = "Z09583601MY3QCL7AJKBT"
  records            = [aws_lb.lb[0].dns_name]
  ttl                = 30
}
resource "aws_lb_target_group" "target" {
  count                = var.lb_tg_group ? 1 : 0
  name                 = "${var.env}-${var.component}-tg"
  port                 = var.app_port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 2
  health_check {
     healthy_threshold   = 2
      interval           = 5
      path               = "/health"
      port               = var.app_port
     unhealthy_threshold = 2
     timeout             = 4
  }
  tags = {
    Name = "${var.env}-${var.component}-tg"
  }
}
resource "aws_lb_target_group_attachment" "tg-attachment" {
  count              =  var.lb_tg_group ? 1 : 0
  target_group_arn   =  aws_lb_target_group.target[0].arn
  target_id          =  aws_instance.component.id
  port               =  var.app_port
}
resource "aws_lb" "lb" {
  count              = var.lb_req ? 1 : 0
  name               = "${var.env}-${var.component}-lb"
  internal           = var.lb_internet_type == "public" ? false : true
  load_balancer_type = "application"
  subnets            = var.lb_subnets
  security_groups    = [aws_security_group.lb_security[0].id]
  tags = {
    Environment      = "${var.env}-${var.component}-lb"
  }
}
resource "aws_lb_listener" "listener" {
  count                   =  var.lb_req ? 1 : 0
  load_balancer_arn       =  aws_lb.lb[0].arn
  port                    =  var.app_port
  protocol                =  "HTTP"
    default_action {
    type                  =  "forward"
    target_group_arn      =   aws_lb_target_group.target[0].arn
  }
}
//resource "aws_lb_listener" "frontend-http" {
//  count                   =  var.lb_req ? 1 : 0
//  load_balancer_arn       =  aws_lb.lb[0].arn
//  port                    =  var.app_port
//  protocol                =  "HTTP"
//  default_action {
//    type = "redirect"
//    redirect {
//      port        = "443"
//      protocol    = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
//}
//resource "aws_lb_listener" "frontend-https" {
//  count                   =  var.lb_req ? 1 : 0
//  load_balancer_arn       =  aws_lb.lb[0].arn
//  port                    =  "443"
//  protocol                =  "HTTPs"
//  default_action {
//    type                  =  "forward"
//    target_group_arn      =   aws_lb_target_group.target[0].arn
//  }
//}
//
//









