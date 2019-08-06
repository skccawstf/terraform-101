

# S3 for remote backend
module "s3_bucket" {
  source              = "git::https://github.com/skccawstf/terraform-aws-s3-bucket.git?ref=0.5.0"
  versioning_enabled  = true
  name                = "tfstate"
  stage               = "dev"
  namespace           = "skcc"
  region              = "ap-northeast-2"

}

# DynamoDB Table for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  hash_key        = "LockID"
  name            = "skcc-dev-tfstate-lock"
  write_capacity  = 1
  read_capacity   = 1
  attribute {
    name = "LockID"
    type = "S"
  }

  depends_on = ["module.s3_bucket"]
}