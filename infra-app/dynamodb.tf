resource "aws_dynamodb_table" "remote_dynamodb_table" {
  name           = "${var.env}-${var.table_name}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  tags = {
    Name  = "${var.env}-${var.table_name}"
    Environment = var.env
  }
}