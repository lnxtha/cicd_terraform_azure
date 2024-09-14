# cicd_terraform_azure

# Azure Resources with Terraform

## Objective

The main objective of this code is to create a CSV file in storage account and run ADF taking that CSV file as a source and copy the content and output to another CSV file within Azure blob storage all using terraform in azure.

First I executed `az login` to sign into my Azure credentials. In main.tf I have written 
```
provider "azurerm" {
  features  {}
}
```
which is responsible for handling my Microsoft Azure login credentials.

In this repository, I have created two Terraform modules: 
   a. Storage Account Module
   b. Azure Data Factory
   
I have updated `main.tf`, `variables.tf` files, and after executing the code, it will create the following resources in Microsoft Azure. 

### Resources Created

- **Resource Group**

### Storage Account Module

#### Variables:
1. `storage_account_name`
2. `resource_group_name`
3. `location`
4. `source_folder_name`
5. `destination_folder_name`
6. `container_access_type`

### ADF (Azure Data Factory) Module

#### Variables:
1. `ADF_Name`
2. `resource_group_name`
3. `location`
4. `storage_account_name`



We can define variables in a separate file and pass them while running `terraform apply -var-file=variables.tfvars` to use the variables in the following modules.


## Steps to Execute

1. **Initialize Terraform**

   ```bash
   terraform init
   ```
2. **Validate Terraform**

   ```bash
   terraform validate
   ```
3. **Plan Terraform**

   ```bash
   terraform plan -var-file=variables.tfvars
   ```
4. **Apply the Changes**

   ```bash
   terraform apply -var-file=variables.tfvars
   ```
