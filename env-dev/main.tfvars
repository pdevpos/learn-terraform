env = "dev"
instance_type = "t3.micro"
vpc_cidr_block = "10.10.0.0/24"
frontend-subnets = ["10.10.0.0/27","10.10.0.32/27"]
backend-subnets = ["10.10.0.64/27","10.10.0.96/27"]
db-subnets = ["10.10.0.128/27","10.10.0.160/27"]
public-subnets = ["10.10.0.192/27","10.10.0.224/27"]
availability_zone = ["us-east-1a","us-east-1b"]
default_vpc_id = "vpc-02a94ee8944923438"
default_vpc_cidr = "172.31.0.0/16"
default_route-table_id = "rtb-0a2e9ff93585c96fd"
ssh_user = "ec2-user"
ssh_pass = "DevOps321"
bastion_nodes = ["172.31.39.175/32"]
vault_token = "hvs.fMGVYmkvteLqprw3itd1iXUe"
kms_key_id = "arn:aws:kms:us-east-1:041445559784:key/01c408a9-ea33-4d92-b183-a144056b8276"
access_sg_app_port = ["0.0.0.0/0"]
# eks-subnets = ["10.10.0.64/27"]



