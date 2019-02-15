######
# ELB
######
module "elb" {
  source = "./modules/elb"

  name = "${var.name}"

  subnets         = ["${var.subnets}"]
  #security_groups = ["${var.security_groups}"]
  internal        = true

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = false
  connection_draining_timeout = 300
  
  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "8080"
      instance_protocol = "HTTP"
      lb_port           = "8080"
      lb_protocol       = "HTTP"
    },
]
  access_logs  = []
  health_check = [
    {
      target              = "HTTP:80/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

  tags = {
    Owner       = "Consumer"
    Environment = "development"
}
}

#################
# ELB attachment
#################
module "elb_attachment" {
  source = "./modules/elb_attachment"

  number_of_instances = "${var.number_of_instances}"

  elb       = "${module.elb.this_elb_id}"
  instances = "${var.instances}"
}
