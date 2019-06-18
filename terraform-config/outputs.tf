output "my_nginx_url" {
  value = "http://${module.my_nginx_elb.elb_dns_name}"
}