# PROJECT1-AZURE-UDACITY:  Azure Infrastructure Operations

#Overview

My team has created an application that they deployed to Azure. The application is self-contained, but they need the infrastructure to deploy it in a customizable way based on specifications provided at build time, with an eye toward scaling the application for use in a CI/CD pipeline.

Although We’d like to use Azure App Service, management has told us that the cost is too high for a PaaS like that and wants us to deploy it as pure IaaS so I can control cost. Since they expect this to be a popular service, it should be deployed across multiple virtual machines.

To support this need and minimize future work, we will use Packer to create a server image, and Terraform to create a template for deploying a scalable cluster of servers—with a load balancer to manage the incoming traffic. We’ll also need to adhere to security practices and ensure that our infrastructure is secure.

The project will consist of the following main steps:  

* Creating a Packer template  
* Creating a Terraform template  
* Deploying the infrastructure  

# Deploy Policy 

Use the portal to deploy and apply the policy definition   
Reference link: https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-portal

# Create Image Packer for Virtual machine
* packer_template.json: use this template file to create image packer for virtual machine    

Use command to create image for virtual machine
```
packer build packer_template.json 
```
# Deploy the resources with terraform
* terraform/main.tf: declare the resouces that you use to create  
* terraform/variables.tf: declare variable  

Use this command to get started  
```
terraform init
```
This command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times  

```
terraform plan [option]
```
The terraform plan command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure  
If you are using Terraform directly in an interactive terminal and you expect to apply the changes Terraform proposes, you can alternatively run terraform apply directly. By default, the "apply" command automatically generates a new plan and prompts for you to approve it.  
You can use the optional -out=FILE option to save the generated plan to a file on disk, which you can later execute by passing the file to terraform apply as an extra argument. This two-step workflow is primarily intended for when running Terraform in automation. 
If you run terraform plan without the -out=FILE option then it will create a speculative plan, which is a description of the effect of the plan but without any intent to actually apply it. 

For example:  
To save the plan file use this command
```
terraform plan -out solutions.plan
```
To deploy terraform infrastructure
```
terraform apply main.tf
```

# How to customize variables.tf file
For example: If you want to deploy more VM you need to modify the value of default in variables files.  
variable "numberVM" {
  description = "number of resources VM"
  default = <type_your_number_of_VM_you_want>
}
