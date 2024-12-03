# to create aws eks cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.env}-${var.component}-cluster"
  role_arn = aws_iam_role.eks_iam_role.arn

 vpc_config {
   subnet_ids = var.eks_subnets
   security_group_ids = [aws_security_group.security.id]
 }
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = "arn:aws:kms:us-east-1:041445559784:key/01c408a9-ea33-4d92-b183-a144056b8276"
    }
  }

tags = {
  Name = "${var.env}-${var.component}-cluster"
}
}
# to create iam role for eks
resource "aws_iam_role" "eks_iam_role" {
  name               = "eks-cluster-example"
  assume_role_policy = data.aws_iam_policy_document.iam_policy.json
}
# provides necessary permissions
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_iam_role.name
}
# to manage network interfaces and their private IP addresses
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_iam_role.name
}

# to create nodegroup
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.env}-${var.component}-node"
  node_role_arn   = aws_iam_role.iam_node_role.arn
  subnet_ids      = var.eks_subnets
  capacity_type   = "SPOT"
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  launch_template {
    version = "$Latest"
  }
  tags = {
    Name = "${var.env}-${var.component}-eks-node"
  }
}
resource "aws_iam_role" "iam_node_role" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iam_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iam_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iam_node_role.name
}
//create a security group
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
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-${var.component}-eks"
  }
}
resource "aws_launch_template" "launch_template" {
  name          = "${var.env}-${var.component}-lauch-tmplt"
  image_id      = data.aws_ami.ami.id
  instance_type = "t2.micro"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }
}
# ASG is trying to use a KMS service, here there is no permission to access KMS service by ASG.
#KMS service need to add to ASG config
#KMS is mandatory