output "clb_dns_name" {
  value       = aws_elb.example.dns_name
  description = "The domain name of the load balancer"
}

output "default_label_id" {
  value       = module.default_label.id
  description = " The id of skcc dev helloapp label"
}

output "default_label_tags" {
  value = module.default_label.tags
  description = " tags of skcc dev helloapp label"
}