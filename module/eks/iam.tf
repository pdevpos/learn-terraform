# resource "aws_iam_role" "eks_cluster_role"
# {
#  name = "${var.env}-eks-role"
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#     {
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "eks.amazonaws.com"
#    }
#    },
#    ]
#  })
#  tags = {
#   Name = "${var.env}-eks-role"
#  }
# }
# resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.eks_cluster_role.name
# }
# resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#  role       = aws_iam_role.eks_cluster_role.name
# }
#
# resource "aws_iam_role" "eks_node_role" {
#   name = "${var.env}-eks-node-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "eks.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }
#
# resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }
#
# resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
# }
#
# resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
#   role       = aws_iam_role.eks_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }