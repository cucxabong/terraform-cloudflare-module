data "cloudflare_zones" "zone" {
  count = length(var.zone_name) > 0 ? 1 : 0
  filter {
    name   = var.zone_name
    status = "active"
    paused = false
  }
}
