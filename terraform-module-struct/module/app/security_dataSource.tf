data "aws_security_group" "selected" {
  name = "allow"
}
output "security_group" {
  value = data.aws_security_group.selected
}