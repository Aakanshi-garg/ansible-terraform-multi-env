resource "aws_key_pair" "shared_key" {
  key_name   = "infra-key"
  public_key = file("infra-key.pub")
}

module "dev-infra"{
    source = "./infra-app" 
    env = "dev"
    bucket_name = "bucket-developer-aakanshi"
    instance_name = "infra-instance"
    instance_count = 1
    instance_type = "t2.micro"
    instance_ami_id = "ami-0d1b5a8c13042c939"
    key_name = "infra-key"
    table_name = "terraform-table-developer"
    hash_key = "LockId"
}

module "prod-infra"{
    source = "./infra-app"
    env = "prod"
    bucket_name = "bucket-production-aakanshi"
    instance_name = "infra-instance"
    instance_count = 2
    instance_type = "t2.medium"
    instance_ami_id = "ami-0d1b5a8c13042c939"
    key_name = "infra-key"
    table_name = "terraform-table-production"
    hash_key = "LockId"
}

module "staging-infra"{
    source = "./infra-app"
    env = "staging"
    bucket_name = "bucket-stage-aakanshi"
    instance_name = "infra-instance"
    instance_count = 1
    instance_type = "t2.small"
    instance_ami_id = "ami-0d1b5a8c13042c939"
    key_name = "infra-key"
    table_name = "terraform-table-stage"
    hash_key = "LockId"
}

