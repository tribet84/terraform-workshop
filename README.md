# Introduction to Terraform
Welcome to the introduction to `Terraform` workshop where we will be introducing some basic concepts and provisioning an azure service bus subscription.

![alt text](https://avatars3.githubusercontent.com/u/29154831?s=280&v=4 "Terraform")

Brought to you by Jon Povey and Roberto Rabasco

# Pre-reqs

Install terraform

```powershell
# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install terraform
choco install terraform
```

To enhance your experience it helps to have vscode along with a few terraform extensions installed too
```powershell
choco install visualstudiocode
code --install-extension mauve.terraform
code --install-extension mindginative.terraform-snippets
```

# Lets do this
## Setting the scene
We start this journey with a requirement from the business for a new `Subscription` under an existing `Topic` in Azure Service Bus. The resource group, namespace and topic already exist.

Follow the steps below and run the commands to change the way you provision infrastructure forever.

## Environments
The entry point into each system to be provisioned can be found in environments. Here you will find that this 'dev' environment has already been partially configured with a provider and two modules.

A terraform `Provider` is responsible for communicating with cloud provider APIs e.g. Azure, AWS, Google etc.

`Modules` are configurable packages used to create resources with your provider.

```
To communicate with the environment we have set up, you will need to replace the secret for the provider. We have created an Azure Service Principle to achieve this.
```

## Terraform init
To start making changes to the environment you will first need to run the `terraform init` command. This will setup your working directory based on the environments configuration.

```powershell
cd .\environments\dev\
terraform init
```
After running these commands you will see each module is initialized in the terminal.

## Terraform plan
The terraform plan command is used to create execution plans to determine what actions, if any, are required to achieve desired state

```powershell
terraform plan
```
Run the plan and you will see notice that the local state is refreshed and that there are `No changes. Infrastructure is up-to-date`

## Tfstate
State is used by terraform to map real world resources to your configuration. In a production like environment this state would be stored remotely in a backend such as a blob container to allow for cross team collaboration.

But for now this workshop is stored locally in the `terraform.tfstate` file. _We have included a tfstate with the initial check in to help setup the initial state but this is not good practice to share state this way._

## But wait...where is the topic?
Existing infrastructure **must** be imported into your tfstate to ensure that your modules and real world environment are consistent and up to date. 

Not importing existing resources is dangerous and could cause unexpected behavior or even deletion of that resource!

## Terraform import


But where is the topic?
Import the topic
Run plan again and see there are still no chanes to apply
Create the subscription with your name
Run the plan - notice a new resource
Run the apply - adds new sub
Run the plan - no changes
Modify the subscription - see how terraform applies incremental change
Publish messages to the topic, whoever has the most wins
Bonus - Create and delete a subscription
For users not able to access our secrets and service principle