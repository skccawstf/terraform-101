output "clb_dns_name" {
  value       = aws_elb.example.dns_name
  description = "The domain name of the load balancer"
}

output "skcc_dev_helloapp_label" {
  value       = module.skcc_dev_helloapp_label.id
  description = " The id of skcc dev helloapp label"
}