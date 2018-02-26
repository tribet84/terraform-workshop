# Introduction to Terraform
Welcome to the introduction to `Terraform` workshop where we will be introducing some basic concepts and provisioning an azure service bus subscription.

![terraformlogo](https://user-images.githubusercontent.com/15745924/36605763-9be4edd0-18b9-11e8-9508-789f416412aa.PNG)

Brought to you by [Jon Povey](https://github.com/jpovey)
 ![jon](https://avatars0.githubusercontent.com/u/15745924?s=76&v=4) and [Roberto Rabasco](https://github.com/tribet84) 
 ![roberto](https://avatars2.githubusercontent.com/u/10653977?s=76&v=4)
 
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
The entry point into each system to be provisioned can be found in the environments folder. Here you will find that this _dev_ environment has already been partially configured with a provider and two modules.

A terraform `Provider` is responsible for communicating with cloud providers APIs e.g. Azure, AWS, Google etc.

`Modules` are configurable packages used to create resources with your provider.

_To communicate with the environment we have set up, you will need to replace the secret for the provider. We have created an Azure Service Principle to achieve this._

## Terraform init
To start making changes to the environment you will first need to run the `terraform init` command. This will setup your working directory based on the environments configuration.

```powershell
cd .\environments\dev\
terraform init
```
After running these commands you should notice that each module is initialized in the terminal.

## Terraform plan
The `terraform plan` command is used to create execution plans to determine what actions, if any, are required to achieve desired state

```powershell
terraform plan
```
Run the plan and you should see that the local state is refreshed and that there are `No changes. Infrastructure is up-to-date`

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

Take a closer look at the asb_topic module and you will find 
- Variables - Values passed into the module to configure a resource
- The resource - Transformed into an api call by terraform
- Output - Used to share variables and configuration between modules

The eagle eyed of you will also notice that the topic configuration takes dependencies from both the resource group and namespace modules. This allows terraform to create an execution plan based on the dependencies.

```powershell
terraform init #required to initialize the previously unused topic module
terraform plan
```

The plan should now show that there is one new topic resource to add. This is still not correct as we know that the topic already exists and must be imported.

## Terraform import
To import the topic you need to map the configured modules address to the resource id which can be found in azure `terraform import ADDRESS RESOURCEID`.

```powershell
terraform import module.topic_workshop.azurerm_servicebus_topic.topic /subscriptions/d6f20e81-c8f9-4d3e-91ee-4ccf290b8e2b/resourceGroups/RG-Terraform-Workshop/providers/Microsoft.ServiceBus/namespaces/Terraform-Workshop/topics/workshop
```

Run the plan again and you should see that there are no changes pending as infrastructure is up-to-date.

```powershell
terraform plan
```

## Creating a subscription
A subscription is required under the `workshop` topic. Create a subscription using the existing asb_subscription with your name as the subscription name.

Remember to use the outputs from other modules to setup the dependencies correctly. Once the configuration is complete run the following commands.

```powershell
terraform init #required to initialize the previously unused module
terraform plan
```

The plan should show there is a new subscription resource to add.

## Terraform apply
This time we want to apply the change as we know the subscription is a new resource. `Terraform apply` will commit any changes detailed in the plan. Terraform will do whatever you tell it so be very careful and always double check the changes you are about to apply before running the command.

Additions are represented with a green +, changes a yellow ~ and deletions with a red -

```powershell
terraform apply
```

The apply will give you another final chance to check the changes. To confirm enter yes.

If successful you will get this message `Apply complete! Resources: 1 added, 0 changed, 0 destroyed.`

Running `terraform plan` again will confirm there are no changes and the plan was applied.

## Making changes
Navigate to the asb_subscription module and amend the max_delivery_count

Run `terraform plan` again and you will see that a change is planned.

Run `terraform apply` and it will modify the subscription without deleting the current resource.

## Destructive changes
Change the subscription name to _yourname_date_ in the dev plan.

Run `terraform plan` again and you will see that a change is planned. But this time one resource will be destroyed and one created because this particular change forces a new resource.

Run `terraform apply` and it will recreate the subscription.

## Deleting a resource
Te remove a resource simply delete it from the configuration. _For this workshop only delete what you have created_

Run `terraform plan` again and you will see that there is one resource to destroy.

Run `terraform apply` and it will delete the subscription.

## Bonus - Adding a new module
A late requirement has come in and a new queue using your name is also required (why are these product managers always changing their minds?).

Create a new module for a queue and then add the resource configuration to the plan. Once you are ready plan and apply your changes.

The terraform azure provider [documentation](https://www.terraform.io/docs/providers/azurerm/r/servicebus_queue.html) will probably come in handy here. 

# Running this outside of Asos Order Intake workshop
To run this tutorial outside of the Asos Order Intake workshop you will be required to create the resource group and namespace from scratch

To do this:
- Delete the terraform.tfstate file
- [Setup an azure service principle](https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html)
- Update the dev main.tf file with your credentials
- Run `terraform apply` and it will create both the resource group and namespace
