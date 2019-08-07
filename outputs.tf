
output "skcc_dev_helloapp_label_tags" {
  value = module.webserver_cluster.default_label_tags
  description = " tags of skcc dev helloapp label"
}

output "clb_dns_name" {
  value       = module.webserver_cluster.clb_dns_name
  description = "The domain name of the load balancer"

}