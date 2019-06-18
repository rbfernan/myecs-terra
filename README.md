# My ECS-Terraform Sample

This project contains [Terraform](https://www.terraform.io/) configurations to deploy [Docker](https://www.docker.com/)
images of the [nginx]() using Amazon's [EC2 Container Service (ECS)](https://aws.amazon.com/ecs/)

### Requirements
If you already have a system with Terraform installed, please skype to the Clone MyECS-Terra section.

This project provides Vagrant/Chef scripts to create the Linux virtual machine with the base requirements. Follow the links bellow to install Virtualbox and Vagrant in order to run them:

[VirtualBox download](https://www.virtualbox.org/)

[Vagrant download](https://www.vagrantup.com/downloads.html)

After the installation, please follow the steps below:

### Clone the MyECS-Terra project on your environment
Clone this project or download the zip file from github and extract it into your system.

`git clone https://github.com/rbfernan/mycluster.git`

Execute the steps bellow only if you are running the ubuntu-18.05 bionic virtualbox provided with this project.

1. Go to install directory `<your project>/vagrant` directory on your local system
2. run `vagrant up`   (This process can't take several minutes)

    In case you have any issues with the chef-solo recipes, run `vagrant provision`

**Note**: Run `vagrant destroy` in case you want to remove this VM from your system later on.

The myecs-terra test chef recipe will install  the required softwares  into the VM and create the `/myecs-terra` diretctory (linking it to `<your project>` directory in the host system ).

### Config Setup

1. `cd terraform-config`
1. Open `vars.tf`, set the environment variables specified at the top of the file, and feel free to tweak any of the
   other variables to your liking.

### Deploying into AWS

1. Configure your AWS credentials as environment variables:
   
    ```
    export AWS_ACCESS_KEY_ID=...
    export AWS_SECRET_ACCESS_KEY=...
    ```
   
1. `terraform init`

1. `terraform plan`

1. If the plan looks good, run `terraform apply` to deploy the code into your AWS account.

1. Wait a few minutes for everything to deploy. You can monitor the state of the ECS cluster using the [ECS
   Console](https://console.aws.amazon.com/ecs/home).

After `terraform apply` completes, it will output the URLs of the ELBs of the nginx cluster.

The following infrastructure should be created:

- Auto Scaling group (ecs-my-nginx) with 3 EC2 instances (across 3 availability zones) for a given region
- Load Balancer (my-nginx-elb)
- Load Balancer (my-nginx-elb) and EC2 (ecs-my-nginx) security groups
- ECS Cluster (ecs-my-nginx)
- ECS Service (my-nginx) and Task (with 3 nginx containers)

Note: For simplicity the current version is deploying against the default vpc configured for your aws account.


### Destroying the nginx cluster

Run the command bellow to visualize what elements will be destroyed:

`terraform plan -destroy`

Or for destroying it directly:

`terraform destroy`


## TO DOs
 - Configure a new vpc for the ECS cluster (instead of using the default)
 - Configure auto scaling for the ECS cluster
 - Configure auto scaling for the ECS Service Task
