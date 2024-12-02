
resource "aws_kms_alias" "my_key_alias" {
  name = "alias/test"
  target_key_id = aws_kms_key.kms_key.id
}
resource "aws_kms_key" "kms_key" {
  description = "KMS key for Auto Scaling service role"
  key_usage   = "ENCRYPT_DECRYPT"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "key-consolepolicy-3",
    "Statement": [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::041445559784:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      },
      {
        "Sid": "Allow use of the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::041445559784:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      },
      {
        "Sid": "Allow attachment of persistent resources",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::041445559784:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        "Action": [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        "Resource": "*",
        "Condition": {
          "Bool": {
            "kms:GrantIsForAWSResource": "true"
          }
        }
      }
    ]
  })
}




