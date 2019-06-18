# Define these secrets as environment variables
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# OPTIONAL MODULE PARAMETERS
variable "region" {
  description = "The region where to deploy this code (e.g. us-east-2)."
  default = "us-east-2"
}

variable "key_pair_name" {
  description = "The name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster. Leave blank to not include a Key Pair."
  default = ""
}

variable "my_nginx_image" {
  description = "The name of the Docker image to deploy for the My Nginx (e.g. nginx:alpine)"
  default = "nginx:alpine"
}

variable "my_nginx_version" {
  description = "The version (i.e. tag) of the Docker container to deploy for the My Nginx (e.g. latest, 12345)"
  default = "latest"
}

variable "my_nginx_port" {
  description = "The port the My Nginx Docker container listens on for HTTP requests (e.g. 80)"
  default = "80"
}
