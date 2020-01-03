terraform {
  backend "azurerm" {
    storage_account_name = "diag1ef03152fcbd8d78"
    container_name       = "terraform"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "sH15P583UU/hckpUd8L69sgL8WidonGQJY4Tg28nPDpdMFPBWEnasWns2KI4/lpKvUzB1E8xec77zqyuA8xT4g=="
  }
}