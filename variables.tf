variable "zone_name" {
  description = "Cloudflare Zone Name (Domain Name)"
  type        = string
  default     = ""
}

variable "access_rule_configs" {
  description = "Cloudflare access rule configuration map"
  default     = {}
}

variable "page_rule_configs" {
  description = "Cloudflare page rule configuration list"
  default     = []
}

variable "record_configs" {
  description = "Cloudflare record configuration map"
  default     = {}
}

variable "firewall_rule_configs" {
  description = "Cloudflare firewall rule configuration map"
  default     = {}
}
