# Get DNS information from AWS Route53
data "aws_route53_zone" "mynewdomain" {
  name = "travel360withhemanth.in" #provide the zone name that is present in the AWS R53
}
# Output MyDomain Zone ID
output "mydoma_zoneID" {
  description = "This is my domain zone ID"
  value       = data.aws_route53_zone.mynewdomain.zone_id
}

# Output MyDomain name
output "mydomain_name" {
  description = " The Hosted Zone name of the desired Hosted Zone."
  value       = data.aws_route53_zone.mynewdomain.name
}
