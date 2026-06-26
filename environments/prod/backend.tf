terraform {

  backend "s3" {

    bucket         = "arka-prod-tf-state-987654321012"

    key            = "networking/terraform.tfstate"

    region         = "ap-south-1"

    # dynamodb_table = "terraform-state-locks"
    use_lockfile = true

    encrypt = true
  }
}