# Introduction to Terraform
Welcome to the introduction to Terraform workshop where we will be provisioning an azure service bus subscription

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