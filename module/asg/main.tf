resource "aws_launch_template" "launch_template" {
  name                 = "${var.env}-${var.component}"
  ami                  = data.aws_ami.ami.arn
  instance_type        = "t3.small"

block_device_mappings {
    device_name = "/dev/sda1"


    ebs {
      volume_size             = 20
      volume_type             = "gp3"
      delete_on_termination   = true
      encrypted               = "Not Encrypted"
    }
  }
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    component   = var.component
    env         = var.env
    vault_token = var.vault_token
  }))

}


resource "aws_autoscaling_group" "ags" {
  availability_zones = var.availability_zone
    name               = "${var.component}-${var.env}-ags"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_template {
      id      = aws_launch_template.launch_template.id
      version = "$Latest"
    }
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
resource "aws_lb" "lb" {
  name               = "${var.env}-${var.component}-lb"
  internal           = var.lb_internet_type == "public" ? false : true
  load_balancer_type = "application"
  subnets            = var.lb_subnets
  security_groups    = [aws_security_group.security[0].id]
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
resource "aws_autoscaling_policy" "scaling_policy" {
  autoscaling_group_name = "${var.env}-${var.component}-asg"
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 10
  }
  name = "${var.env}-${var.component}-asg"
}
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
