
resource "aws_kms_alias" "my_key_alias" {
  name = "alias/test"
  target_key_id = aws_kms_key.kms_key.id
}
resource "aws_kms_key" "kms_key" {
  description = "KMS key for Auto Scaling service role"
  key_usage   = "ENCRYPT_DECRYPT"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "autoscaling.amazonaws.com"
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      }
    ]
  })
}


