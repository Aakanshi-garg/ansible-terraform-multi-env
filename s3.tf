resource "aws_s3_bucket" "my_bucket" {
  bucket = "aakanshi-remote-backend"

  tags = {
    Name = "aakanshi-remote-backend"
  }
}