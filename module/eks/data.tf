# data "aws_iam_policy_document" "eks_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     effect = "allow"
#
#     principals {
#       type        = "Service"
#       identifiers = ["eks.amazonaws.com"]
#     }
#   }
# }
# data "aws_ami" "ami" {
#   most_recent      = true
#   name_regex       = "RHEL-9-DevOps-Practice"
#   owners           = [973714476881]
# }