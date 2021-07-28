
# Introduction 

1.  Terraform 

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.
</br>
Configuration files describe to Terraform the components needed to run a single application or your entire datacenter. Terraform generates an execution plan describing what it will do to reach the desired state, and then executes it to build the described infrastructure. As the configuration changes, Terraform is able to determine what changed and create incremental execution plans which can be applied.
</br>
The infrastructure Terraform can manage includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc.

2. Amazon Web Services 

Amazon Web Services (AWS) is the world’s most comprehensive and broadly adopted cloud platform, offering over 200 fully featured services from data centers globally. Millions of customers—including the fastest-growing startups, largest enterprises, and leading government agencies—are using AWS to lower costs, become more agile, and innovate faster.

## _AWS-terraform project_

- This project demonstrates the core power of [cloud computing](https://en.wikipedia.org/wiki/Cloud_computing (wiki cloud computing)) and [infrastructure as code](https://en.wikipedia.org/wiki/Infrastructure_as_code (IAAC wiki)) , within few minutes and with just few lines you could set up a fully enterprise grade IT infra to host your `monolithic` or `microservices` applications.

- With this code you could set up a cluster of 2 [EC2](https://docs.aws.amazon.com/ec2/index.html?nc2=h_ql_doc_ec2 (Amazon EC2)) instances hosting a [nginx](https://www.nginx.com/resources/glossary/nginx/ (Nginx webserver)) [docker container](https://www.docker.com/resources/what-container (docker container)) as webserver  in differnet [Availability Zone](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/ (Amazon AZ)) in single region with one [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html (AWS ALB)) in front, distributing the backend traffic with required networking setup. With mading sure that our state files are also get backed up on AWS [S3](https://aws.amazon.com/s3/ (S3)) buckets.  "_Sounds Fun isn't it !!_"

## Prerequisite 

1. `Terraform V-1.0.1` [Download URL](https://www.terraform.io/downloads.html (Download Terraform))
2. `AWS Account with Admin access` [Console](https://aws.amazon.com/console/ (AWS console))


## Installation Process 

1. __Creation of Backend bucket__

Change directory to `remote-state` and perform below tasks.

```bash
cd remote-state
terraform init
terraform apply --auto-approve
```

1. __Terraform Init__

To work on our main config move out of `remote-state` dir.
For initiating the terraform to download the plugins as per your provider in this case `AWS` , execute below command from the directory having `main.tf` and other `.tf*` files.

```bash
cd ..
terraform init

```
 
2. __Variables__

Prepare your variable file `terraform.tfvars or *.tfvars`  accordingly as per the variables defined in the `main.tf` file.

3. __Terraform Plan__

For rendering  objects created by the terraform and as a best practice always do a `terraform plan` before applying the config. 

4. __Terraform apply__

Use command `terraform apply` to apply the config.

```bash
terraform apply
```

5. __Terraform state__

To view the list of all objects created by Terraform use `terraform state list` command.

```bash
terraform state list
```

## Uninstall/Destroy Objects

- Use `terraform destroy` command for destroying all objects mentioned in config file. If we want to remove specific object then we can use `terraform destroy -target aws_<resource_name>.<name_mentioned_maintf>`.However it is not the best practice, always try to keep your config file updated as per the infra required. 

```bash
terraform destroy 
terraform destroy -target aws_vpc.myapp_vpc ## will delete vpc only
```

## Extra Information

[x] Refer to [Terraform-AWS documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs (AWS Provider Terraform)) for extra custom configs.
[x] As for backend terraform configuration bucket should be already existing in our infra. We have created a dedicated directory `remote-state` with config for bucket provisioning.