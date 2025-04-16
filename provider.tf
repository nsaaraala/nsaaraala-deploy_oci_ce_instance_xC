terraform {
   required_providers {
    oci = {
      source = "oracle/oci"
      version = "6.34.0"
    }
    volterra = {
      source = "volterraedge/volterra"
      version = "0.11.42"
    }
  }
}


provider "volterra" {
  api_p12_file     = "<path>"
  url              = "https://<tenant-name>.console.ves.volterra.io/api"
}


provider "oci" {
  tenancy_ocid      = var.tenancy_ocid
  user_ocid         = var.user_ocid
  private_key_path  = var.private_key_path
  fingerprint        = var.fingerprint
  region           = var.region
}