# # create eks cluster
# resource "aws_eks_cluster" "eks_cluster" {
#   name     = "example"
#   role_arn = aws_iam_role.eks_cluster_role.arn
#
#   vpc_config {
#     subnet_ids = var.subnet_ids
#   }
# }
# # create eks node group
# resource "aws_eks_node_group" "eks_node_group" {
#   cluster_name    = aws_eks_cluster.eks_cluster.name
#   node_group_name = "example-node-group"
#   node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids      =var.subnet_ids
#   capacity_type = "SPOT"
#
#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }
#
#   instance_types = ["t3.large"]
#
#   tags = {
#     Name = "${var.env}-node-group"
#   }
# }


