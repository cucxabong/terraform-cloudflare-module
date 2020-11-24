
locals {
  normalized_record_configs = flatten([
    for type, items in var.record_configs : [
      for item in items : merge(
        item,
        {
          type          = type
          resource_name = lookup(item, "resource_name", format("%s-%s", item["name"], type))
      })
    ]
  ])
}

resource "cloudflare_record" "records" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  for_each = {
    for item in local.normalized_record_configs : item["resource_name"] => item
  }
  name     = each.value["name"]
  type     = each.value["type"]
  priority = lookup(each.value, "priority", null)
  proxied  = lookup(each.value, "proxied", null)
  ttl      = lookup(each.value, "ttl", null)
  data     = lookup(each.value, "data", null)
  value    = lookup(each.value, "value", null)
}
