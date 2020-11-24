data "cloudflare_zones" "zone" {
  filter {
    name   = var.zone_name
    status = "active"
    paused = false
  }
}
