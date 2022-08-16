# PROJECT1-AZURE-UDACITY:  Azure Infrastructure Operations

# Deploy Policy 

## Use the portal to deploy and apply the policy definition
## Reference link: https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-portal

# Create Image Packer for Virtual machine
* packer_template.json: use this template file to create image packer for virtual machine
Use command to create image for virtual machine
```
packer build packer_template.json 
```
# Deploy the resources with terraform
terraform/main.tf: declare the resouces that you use to create
terraform/variables.tf: declare variable 

Use this command to get started
```
terraform init
```
To save the plan file use this command
```
terraform plan -out solutions.plan
```
To deploy terraform infrastructure
```
terraform apply main.tf
```
