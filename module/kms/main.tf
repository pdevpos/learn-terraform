resource "aws_kms_key" "kms_key" {
  description = "kms key"
}
resource "aws_kms_key_policy" "kms_key_policy" {
  key_id = aws_kms_key.kms_key.id
  policy = jsonencode({
    Id = "kms_key-id"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::aws:policy/service-role/AWSServiceRoleForAutoScaling"
        }

        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}
resource "aws_kms_alias" "my_key_alias"
{
  name = "alias/my-key"
  target_key_id = aws_kms_key.kms_key.id
}