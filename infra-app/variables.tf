variable "env" {
    description = "This is the environment for the infrastructure dev/staging/prod"
    type = string
}

variable "bucket_name" {
    description = "This is the bucket name for the infrastructure"
    type = string
}

variable "key_name" {
    description = "This is the key-pair for the infrastructure"
    type = string
}

variable "instance_count" {
    description = "Number of instances in the infrastructure"
    type = number
}

variable "instance_ami_id" {
    description = "This is the AMI ID for EC2 instance" 
    type = string
}

variable "instance_name" {
    description = "name of the instance "
    type =  string
}

variable "instance_type" {
    type = string
}

variable "table_name" {
    description = "name of te dynamodb table"
    type = string
}

variable "hash_key" {
    type = string
}