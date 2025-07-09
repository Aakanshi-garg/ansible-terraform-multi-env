# vpc and security groups
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "my_security" {
  name   = "${var.env}-automate-sg"
  vpc_id = aws_default_vpc.default.id #string interpolation

  #inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


}

# ec2 instance
resource "aws_instance" "my_instance" {

    user_data = <<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh
    echo "${file("infra-key.pub")}" > /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/authorized_keys
  EOF
  
  count = var.instance_count
  depends_on = [ aws_security_group.my_security ]
  security_groups = [aws_security_group.my_security.name]
  instance_type   = var.instance_type
  ami             = var.instance_ami_id
  key_name = var.key_name

  root_block_device {
    volume_size = var.env == "prod" ? 20 : 10
    volume_type = "gp3"
  }


  tags = {
    Name = "${var.env}-${var.instance_name}"
    Environment = var.env
  }
}



