# Terraform_Azure_Keyvault_Module
Using this techhub template we can create a keyvault with private endpoint and dynamic network ACLs.

## Prerequisites

Before you can use this Terraform module, you will need to have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) - v1.0.5 or later
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) - v2.26.0 or later
- Resource Group
- Virtual Network and subnet

## Usage

To use this Terraform module, follow these steps:

From your local, generate and Set up SSH key pair for Github.

Clone this Git repo to your local machine.

```bash
git clone git@github.com:NashTech-Labs/Terraform_Azure_Keyvault_Module.git
```

Change into the directory containing the module.

```bash
cd Terraform_Azure_Keyvault_Module

```

Create a new file named `key-vault.tfvars` in the same directory as your `.tf` files.

```bash
touch key-vault.tfvars
```

Open the file in your preferred text editor.

```bash
nano key-vault.tfvars
```

Add your desired inputs to the file in the following format:

```ruby
create_rg = false
resource_group_name = ""
subnet_name = ""
vnet_name = ""
vnet_rg_name = ""
name = ""
location = ""
.............

```
Review the changes that Terraform will make to your Azure resources.


Initialize Terraform in the directory.

```bash
terraform init
```
```bash
terraform plan 
```
```bash
terraform apply --auto-approve
