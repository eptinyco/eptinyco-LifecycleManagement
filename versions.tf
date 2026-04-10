terraform {
    required_version = "1.14.8"

  cloud {
    
    organization = "eptinyco"

    workspaces {
      name = "UserManagement"
    }
  }
  required_providers {
    microsoft365wp = {
      source  = "terraprovider/microsoft365wp"
      version = "0.18.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "3.8.0"
    }
  }
}

# Configure the Workplace Provider
provider "microsoft365wp" {
  client_id = var.ARM_CLIENT_ID
  client_secret = var.ARM_CLIENT_SECRET
  tenant_id = var.ARM_TENANT_ID
}

provider "azuread" {
  client_id = var.ARM_CLIENT_ID
  client_secret = var.ARM_CLIENT_SECRET
  tenant_id = var.ARM_TENANT_ID

}