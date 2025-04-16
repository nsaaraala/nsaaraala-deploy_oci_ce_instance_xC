
#####################################################
#  XC Volterra variables
#####################################################

variable "cluster_name" {
  type = string
}

variable "num_nodes" {
  description = "Number of nodes created 1 or 3 "
  type        = number
  default     = "1"  # give the value "1" for single node and "3" for HA node
  
  }


#####################################################
#  OCI variables
#####################################################
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "vcn_id" {}
variable "namespace" {}
variable "qcow2_image_name" {}
variable "subnet_ocid" {}
variable "ssh_public_key" {}
variable "security-list" {}


