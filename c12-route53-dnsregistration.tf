# DNS Registration 
resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.mynewdomain.zone_id
  name    = "apps.travel360withhemanth.in"
  type    = "A"
  alias {
    name                   = module.app-alb.lb_dns_name
    zone_id                = module.app-alb.lb_zone_id
    evaluate_target_health = true
  }
}