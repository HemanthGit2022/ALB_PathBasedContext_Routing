# Terraform AWS Application Load Balancer (ALB)
module "app-alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${local.name}-alb"
  #locad balancer type
  load_balancer_type = "application"
  #from which vpc
  vpc_id          = module.vpc.vpc_id
  subnets         = [module.vpc.public_subnets[0], module.vpc.private_subnets[1]]
  security_groups = [module.loadbalancer_sg.security_group_id]

  #this is the list of listeners too, can be added wtih one more
  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
  # App1 TG's 
  target_groups = [
    {
      name_prefix                       = "app1-"
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      health_check = {
        enabled  = true
        interval = 30
        #this is the path check for health of instances
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      #app1 target groups - using the both private EC2 instances
      targets = {
        my_app1_vm1 = {
          target_id = module.ec2_private_app1.id[0] #change is [] then id to be used
          port      = 80
        },
        my_app1_vm2 = {
          target_id = module.ec2_private_app1.id[1]
          port      = 80
        }
      }
      tags = local.common_tags #target group tags  - app1
    },

    # App2 TG's

    {
      name_prefix                       = "app2-"
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      health_check = {
        enabled  = true
        interval = 30
        #this is the path check for health of instances
        path                = "/app2/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      #app2 target groups - using the both private EC2 instances
      targets = {
        my_app2_vm1 = {
          target_id = module.ec2_private_app2.id[0] #change is [] then id to be used
          port      = 80
        },
        my_app2_vm2 = {
          target_id = module.ec2_private_app2.id[1]
          port      = 80
        }
      }
      tags = local.common_tags #target group tags - app2
    }

  ]
  #This is the https listeners - index zero for port 443
  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn
      action_type     = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed static message root context"
        status_code  = "200"
      }
    }
  ]

  #https listener rules - TARGET GROUPS - APP1 EC2 instance of /app1*

  https_listener_rules = [
    {
      https_listener_index = 0 #( as we have this one https listeners so we have 0 index as default)

      actions = [
        {
          type               = "forward"
          target_group_index = 0

        }
      ]

      conditions = [{
        path_patterns = ["/app1*"]
      }]
    },

    #Rule 2 - /app2* should go to app2 instances
    {
      https_listener_index = 0 #( as we have this one https listeners so we have 0 index as default)

      actions = [
        {
          type               = "forward"
          target_group_index = 1

        }
      ]

      conditions = [{
        path_patterns = ["/app2*"]
      }]
    }
  ]


  tags = local.common_tags #ALB tags
}



