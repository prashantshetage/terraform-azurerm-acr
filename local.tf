// Local Values
locals {
  timeout_duration = "1h"
  acr_name         = var.acr_name
  ip_range = [for ip in var.ip_range : {
    action   = "Allow",
    ip_range = ip
    }
  ]
  subnet_id = [for id in var.subnet_id : {
    action    = "Allow",
    subnet_id = id
    }
  ]
}