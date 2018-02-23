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

## Setting up the topic
Now its time to really get down to business. There is already a topic called `workshop` in the namespace which we need to import. 

To import you must first setup the resource in your configuration. Paste (or type if you are into that sort of thing) the following snippet into the dev environments main.tf

```
module "topic_workshop" {
  source              = "../../modules/asb_topic"
  topic_name          = "workshop"
  resource_group_name = "${module.resourceGroup_workshop.resource_group_name}"
  asb_namespace       = "${module.namespace_workshop.asb_namespace}"
}
```

Take a closer look at asb_topic module and you find 
- Variables - Used to configure and re-use a resource
- The resource - Transformed into an api call by terraform
- Output - Used to share variables and configuration between modules

The eagle eyed of you will also notice that the topic configuration takes dependencies from both the resource group and namespace modules. This allows terraform to create an execution plan based on the dependencies

```powershell
terraform init #required to initialize the previously unused module
terraform plan
```

The plan now shows that there is one new topic resource to add. This is still not correct as we know that the topic already exists and must be imported

## Terraform import
To import the topic you need to map the configured modules address to the resource id which can be found in azure `terraform import ADDRESS ID`

```powershell
terraform import module.topic_workshop.azurerm_servicebus_topic.topic /subscriptions/d6f20e81-c8f9-4d3e-91ee-4ccf290b8e2b/resourceGroups/RG-Terraform-Workshop/providers/Microsoft.ServiceBus/namespaces/Terraform-Workshop/topics/workshop
```

Run the plan again and there are no changes as infrastructure is up-to-date

```powershell
terraform plan
```

## Create a subscription
Paste the following subscription resource into main.tf to configure a subscription. `Replace any reference of YOURNAME with your own`

```
module "subscription_YOURNAME" {
  source              = "../../modules/asb_subscription"
  subscription_name   = "YOURNAME"
  resource_group_name = "${module.resourceGroup_workshop.resource_group_name}"
  asb_namespace       = "${module.namespace_workshop.asb_namespace}"
  topic_name          = "${module.topic_workshop.topic_name}"
}
```

```powershell
terraform init #required to initialize the previously unused module
terraform plan
```

The plan will show there is a new resource to add. This time we want to apply the change.

## Terraform apply
Terraform apply will commit any changes detailed in the plan. Terraform will do whatever you tell it so be very careful and double check the changes you are about to apply.

Additions are represented with a green +, changes a yellow ~ and deletions with a red -

```powershell
terraform apply
```

The apply will give you another final chance to check the changes. To confirm enter yes.

If successful you will get this message `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`

Running `terraform plan` again will confirm there are no changes and the plan was applied

Modify the subscription - see how terraform applies incremental change
Publish messages to the topic, whoever has the most wins
Create a blueprint
 -mv
Bonus - Create and delete a subscription
For users not able to access our secrets and service principle