# Secure Mesh Site v2 Deployment on OCI with Terraform

This Terraform project sets up a Secure Mesh Site v2 using Volterra (F5 Distributed Cloud) on Oracle Cloud Infrastructure (OCI).

## Prerequisites
- Oracle Cloud Infrastructure (OCI) account
- F5 Distributed Cloud account
- Terraform installed
- QCOW2 image already uploaded to OCI Object Storage bucket
- VCN and Subnet(s) are already created and available

## Provider Configuration

This project uses the following Terraform providers:

### OCI Authentication
Refer to the OCI documentation to gather the necessary authentication details such as `tenancy_ocid`, `user_ocid`, `fingerprint`, and your `private_key_path`.

### F5 Distributed Cloud (Volterra) Authentication
Refer to the F5 Distributed Cloud documentation to retrieve API credentials and connection details including your `api_p12_file`, `api_url`.

## Files Included
- **main.tf** – Resources for Volterra Secure Mesh Site v2, OCI custom image, instance, and networking.
- **provider.tf** – Provider configurations for OCI and Volterra.
- **variable.tf** – Variables used across the configuration.
- **terraform.tfvars** – Example variable values.

## Example terraform.tfvars

### Important Variables

| Name                | Description                                 
|---------------------|----------------------------------------------
| `region`            | OCI region                                   
| `compartment_ocid`  | OCID of the compartment                      
| `namespace`         | OCI Object Storage namespace                 
| `qcow2_image_name`  | Name of the QCOW2 image file in the bucket   
| `bucket_name`       | Name of the Object Storage bucket           
| `subnet_ocid`       | Public Subnet to deploy instance              
| `vcn_id`            | VCN for security list                        
| `ssh_public_key`    | SSH key to access instance                  
| `cluster_name`      | Name of the Secure Mesh Site                 
| `num_nodes`         | Number of nodes (1 or 3)     

## Assumptions
- VCN and Subnets are already created.
- Custom image (QCOW2 format) is already uploaded to the specified OCI Object Storage bucket.

## Steps to Deploy

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>

2.Initialize Terraform:

   terraform init

3.Plan the deployment:

   terraform plan

4.Apply the configuration:

   terraform apply

5. To remove all resources:

    terraform destroy

Note: Need to add a newly created security list to the existing public subnet.
