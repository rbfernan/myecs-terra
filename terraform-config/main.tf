terraform {
  required_version = "> 0.9.0"
}

provider "aws" {
  region = "${var.region}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "ecs_cluster" {
  source = "./ecs-cluster"

  name = "ecs-my-nginx"
  size = 3
  instance_type = "t2.micro"
  key_pair_name = "${var.key_pair_name}"

  vpc_id = "${data.aws_vpc.default.id}"
  subnet_ids = "${data.aws_subnet.default.*.id}"

  # To keep the example simple to test, we allow SSH access from anywhere. In real-world use cases, you should lock 
  # this down just to trusted IP addresses.
  allow_ssh_from_cidr_blocks = ["0.0.0.0/0"]

  # Here, we allow the EC2 Instances in the ECS Cluster to recieve requests on the ports used by the my-nginx
  # To keep the example simple to test, we allow these requests from any IP, but in real-world
  # use cases, you should lock this down to just the IP addresses of the ELB and other trusted parties.
  allow_inbound_ports_and_cidr_blocks = "${map(
    var.my_nginx_port, "0.0.0.0/0"
  )}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE MY NGINX AND AN ELB FOR IT
# ---------------------------------------------------------------------------------------------------------------------

module "my_nginx" {
  source = "./ecs-service"

  name = "my-nginx"
  ecs_cluster_id = "${module.ecs_cluster.ecs_cluster_id}"

  image = "${var.my_nginx_image}"
  image_version = "${var.my_nginx_version}"
  cpu = 256
  memory = 512
  desired_count = 2

  container_port = "${var.my_nginx_port}"
  host_port = "${var.my_nginx_port}"
  elb_name = "${module.my_nginx_elb.elb_name}"
}

module "my_nginx_elb" {
  source = "./elb"

  name = "my-nginx-elb"

  vpc_id = "${data.aws_vpc.default.id}"
  subnet_ids = "${data.aws_subnet.default.*.id}"

  instance_port = "${var.my_nginx_port}"
  health_check_path = "index.html"
}


# FOR SIMPLICITY DEPLOY THIS EXAMPLE IN THE DEFAULT SUBNETS OF THE DEFAULT VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {}

# Look up the default subnets in the AZs available to this account (up to a max of 3)
data "aws_subnet" "default" {
  count = "${min(length(data.aws_availability_zones.available.names), 3)}"
  default_for_az = true
  vpc_id = "${data.aws_vpc.default.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
}
