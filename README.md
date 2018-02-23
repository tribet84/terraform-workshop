## Intro

...


# Get down and dirty

The easiest way to start using **Terraform** is by installing it with choco using this command:
```
choco install terraform
```
Navigate to your desired environment in the project to setup your local terraform solution. This will pull the latest tfstate from the bakend storage to ensure your enviornment is up to date
```
terraform init
```
Build an execution plan to compare any changes you make to the current infrasture. 
```
terraform plan
```
Build and deploy infrastructure as outlined in the plan:
```
terraform apply
```