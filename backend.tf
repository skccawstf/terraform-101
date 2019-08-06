terraform {
  backend "s3" {
    bucket         = "skcc-dev-tfstate"
    key            = "helloapp-asg/tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "skcc-dev-tfstate-lock"
    acl            = "bucket-owner-full-control"
  }
}