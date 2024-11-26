resource "aws_db_instance" "db_instance" {
  identifier             = "${var.component}-${var.env}"
  db_name                = "mydb"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  username               = jsondecode(data.vault_generic_secret.vault-secrets.data_json).rds_username
  password               = jsondecode(data.vault_generic_secret.vault-secrets.data_json).rds_password
  parameter_group_name   = aws_db_parameter_group.parameter_group.name
  skip_final_snapshot    = var.skip_final_snapshot
  multi_az               = false
  storage_type           = var.storage_type
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  storage_encrypted      = true
  kms_key_id             = var.kms_key_id
  vpc_security_group_ids = [aws_security_group.aws_security.id]                      =
}
resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.component}-${var.env}-pg"
  family = var.family
}
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.component}-${var.env}-sg"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}

resource "aws_security_group" "aws_security" {
  name        = "security-${var.component}-${var.env}-lb"
  description = "security-${var.component}-${var.env}-lb"
  vpc_id      = var.vpc_id
  ingress {
    from_port        = 3306
    to_port          = 3306
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




