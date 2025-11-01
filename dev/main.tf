


resource "azurerm_resource_group" "main" {
  location = var.location
  name     = "${var.prefix}-${var.environment}-folder"

  tags = {
    environment = var.environment
    version     = var.env_version
  }
}
