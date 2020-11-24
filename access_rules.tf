locals {
  normalized_access_rule_configs = flatten([
    for mode, items in var.access_rule_configs : [
      for resource_name, item in items : merge(
        item,
        {
          mode          = mode
          resource_name = resource_name
        }
      )
    ]
  ])
}

resource "cloudflare_access_rule" "access_rule" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  for_each = {
    for item in local.normalized_access_rule_configs : item["resource_name"] => item
  }
  mode = each.value["mode"]
  configuration = {
    target = each.value["target"]
    value  = each.value["value"]
  }
  notes = lookup(each.value, "notes", null)
}
