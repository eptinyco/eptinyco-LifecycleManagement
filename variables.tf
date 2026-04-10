# Define the Terraform global variables to pull the API Client ID and Keys

variable "ARM_CLIENT_ID" {
  type = string
  default = ""
}

variable "ARM_CLIENT_SECRET" {
  type = string
  default = ""
}

variable "ARM_TENANT_ID" {
  type = string
  default = ""
}

variable "ARM_SUBSCRIPTION_ID" {
  type = string
  default = ""
}