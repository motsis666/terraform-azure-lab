terraform {
  backend "azurerm" {
    storage_account_name = "diag1ef03152fcbd8d78"
    container_name       = "terraform"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "kf8oqn1Byg9Rj9RIXYejV6WTasf2eqAu6bq4KACRVnTFrHftsD/wo2SGDSo5L1Ii3vJGNCmYQ/El7DKxHkH03w=="
  }
}