terraform {
  backend "s3" {
    bucket = "san-tf-state-ss"
    key= "global/s3/terraform-nextjs.tfstate"
    region = "ap-south-1"
    dynamodb_table = "s3-locking-tf-table"
    
  }
}