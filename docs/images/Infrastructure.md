# Infrastructure

## Required software
- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)

All of the follow instructions assume that you have downloaded/installed the above software.
For the Azure CLI, this will also assume that you have properly authenticated using `az login` as well as set the appropriate subscription using `az account set --subscription <subscription>`.

## Pre-Setup
Terraform requires a location to [store its state](https://www.terraform.io/docs/language/state/index.html). Because we want a cetralized location for this, we will store it inside of a storage account in Azure. This storage account must be created manually, before runnig the terraform scripts.
To do this run the following commands (adjusting values as neccisary):
- Create the a resource group: `az group create --location westus --resource-group "Demo-TF"`
- Create a storage account (NB: storage account names must be globally unique): `az storage account create -n k8sdemoterraform -g Demo-TF -l westus --sku Standard_LRS`
- Create container `az storage container create --account-name k8sdemoterraform --name terraform-backend`
- Update the providers.tf with your values for the backend storage.
- For the GitHub Action to run, it will require a service principle create. This command only authorizes this service principle for the dev environment. It will either need a second service principle created for prod, or an additional scope added here. 
`az ad sp create-for-rbac --name "TF-DEV-SP" --role contributor --sdk-auth --scopes /subscriptions/{subscription-id}/resourceGroups/Demo-TF /subscriptions/{subscription-id}/resourceGroups/Demo-Dev`
The output from this command should be stored in a [GitHub secret](https://docs.github.com/en/actions/security-guides/encrypted-secrets) named AZURE_CREDENTIALS. For this sample we are storing them as an environment secret with the assumption there is a second service principle for prod. This follows the directions [here](https://github.com/marketplace/actions/azure-cli-action#configure-azure-credentials-as-github-secret)

## Creating the infrastructure
- Navigate to the environment folder to create. This will be under the `Infrastructure\env` directory.
- If this is your first run, or there are changes to the terraform providers, you will need to run `terraform init`. After the initial run, you can skip this step.
- Run `terraform apply`
- Review the created plan.
- Enter "yes" to proceed with creating the infrastructure

## Destroying the infrastructure
- Navigate to the environment folder to create. This will be under the `Infrastructure\env` directory.
- Run `terraform destroy`
- Review the created plan.
- Enter "yes" to proceed with destroying the infrastructure