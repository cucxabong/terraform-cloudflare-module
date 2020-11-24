locals {
  normalized_firewall_rule_configs = flatten([
    for action, items in var.firewall_rule_configs : [
      for resource_name, item in items : merge(
        item,
        {
          action        = action
          resource_name = resource_name
        }
      )
    ]
  ])
}

resource "cloudflare_filter" "filters" {
  zone_id    = data.cloudflare_zones.zone.zones[0].id
  for_each   = { for item in local.normalized_firewall_rule_configs : item["resource_name"] => item }
  expression = each.value["filter_expression"]
}

resource "cloudflare_firewall_rule" "firewall_rules" {
  zone_id     = data.cloudflare_zones.zone.zones[0].id
  for_each    = { for item in local.normalized_firewall_rule_configs : item["resource_name"] => item }
  action      = each.value["action"]
  description = lookup(each.value, "description", null)
  paused      = lookup(each.value, "paused", null)
  priority    = lookup(each.value, "priority", null)
  products    = lookup(each.value, "products", null)
  filter_id   = cloudflare_filter.filters[each.key].id
}
