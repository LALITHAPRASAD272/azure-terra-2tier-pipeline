terraform {
  backend "azurerm" {
    resource_group_name  = "prasad_rgg"
    storage_account_name = "prasadtfstateaccount434"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
