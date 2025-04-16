##locals

locals {
  disable_ha = var.num_nodes == 1
  enable_ha  = var.num_nodes == 3
}


## Cretae secure mesh site version2

resource "volterra_securemesh_site_v2" "example" {
  name      = var.cluster_name
  namespace = "system"
  block_all_services = true
  logs_streaming_disabled = true
  disable_ha             = local.disable_ha
  enable_ha              = local.enable_ha

  re_select {
    geo_proximity = true
  }

  oci {
    not_managed {}
    }
  lifecycle {
    ignore_changes = [ labels ]
  }
}



## Cretae site token 
resource "volterra_token" "smsv2-token" {
  name      = "${volterra_securemesh_site_v2.example.name}-token"
  namespace = "system"
  type      = 1
  site_name = volterra_securemesh_site_v2.example.name

  depends_on = [volterra_securemesh_site_v2.example]
}




resource "oci_core_security_list" "example_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id        = var.vcn_id
  display_name  = var.security-list

  # Ingress Rules
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 65500
      max = 65500
    }
  }

  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Egress Rule (Allow all outbound traffic)
  egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
  }
}



resource "oci_core_image" "smsv2_oci_image" {
  compartment_id = var.compartment_ocid
  
  display_name   = "smsv2-oci-image"
  launch_mode    = "PARAVIRTUALIZED"
  image_source_details {
    operating_system = "RHEL"
  operating_system_version = "8" # Change based on your requirement
  source_type    = "objectStorageTuple"
  namespace_name = var.namespace
  bucket_name    = "bucket-20250415-1257"
  object_name    = var.qcow2_image_name
  source_image_type = "QCOW2"
  
    
  }
  
  
}

output "region_in_use" {
  value = var.region
}


## Create Instance


resource "oci_core_instance" "example" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard3.Flex"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 32  
  }

  create_vnic_details {
    subnet_id        = var.subnet_ocid
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = oci_core_image.smsv2_oci_image.id  # Use the custom image created above
    boot_volume_size_in_gbs = 80
    instance_source_image_filter_details {
      compartment_id = var.compartment_ocid
    }
  }
  
  metadata = {
    ssh_authorized_keys = var.ssh_public_key

    user_data = base64encode(<<EOF
#cloud-config
write_files:
- path: /etc/vpm/user_data
  content: |
    token: ${volterra_token.smsv2-token.id}
  owner: root
  permissions: '0644'
EOF
    )
  }

  launch_options {
    network_type = "PARAVIRTUALIZED"
  }

  display_name = "core-instance"
  depends_on = [oci_core_image.smsv2_oci_image, volterra_token.smsv2-token]
}




#### Get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}




