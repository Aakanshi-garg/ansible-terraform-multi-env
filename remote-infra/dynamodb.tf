resource "aws_dynamodb_table" "remote_dynamodb_table" {
  name           = "aakanshi-remote-backend-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name  = "aakanshi-remote-backend-table"
  }
}
