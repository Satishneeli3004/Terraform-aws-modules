locals {

  base_tags = {
    Environment = var.environment
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
    ManagedBy   = "Terraform"
  }

  uat_tags = {
    Client  = var.client_name
    Project = var.project_name
  }

  prod_tags = {
    Client    = var.client_name
    Project   = var.project_name
    CreatedBy = "Satish"
  }

  common_tags = (
    var.environment == "dev" ?
    local.base_tags :

    var.environment == "uat" ?
    merge(local.base_tags, local.uat_tags) :

    var.environment == "prod" ?
    merge(local.base_tags, local.prod_tags) :

    local.base_tags
  )
}