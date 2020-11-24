# Cloudflare Resources Terraform module
Terraform module for provisioning cloudflare resources from configuration block(s) (using Terraform collection types as map/list). It follows DRY principle, eliminate repetitive configurations you write into `*.tf` files

## Supported Resources
* [Access Rule](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/access_rule)
* [Firewall Rule](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/firewall_rule)
* [Firewall Rule Filter](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/filter)
* [Page Rule](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/page_rule)
* [Record](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record)

## Terraform versions

Terraform 0.12 or newer (to use `for` and `for_each`)

## Usage
### Configure Cloudflare Access Rules

* `cloudflare_access_rule` only support /16 and /24 with `ip_range` target (Dont know why ?)

```hcl
locals {
  access_rule_configs = {
    block : {
      alibaba : {
        target = "asn"
        value  = "AS37963"
        notes  = "Block Hangzhou Alibaba Advertising"
      }
    },
    whitelist : {
      Vietnam : {
        target = "country"
        value  = "VN"
        notes  = "Allow access from Vietnam"
      }
    },
    js_challenge : {
      Bad_guys_set_1 : {
        target = "ip_range"
        value  = "10.10.0.0/16"
      }
    },
    challenge : {
      Bad_guys_set_2 : {
        target = "ip_range"
        value  = "172.16.1.0/24"
      }
    }
  }
}

module "cloudflare" {
  source    = "./cloudflare"
  zone_name = "abc.com"
  access_rule_configs = local.access_rule_configs
}
```
### Configure Cloudflare Firewall Rules
```hcl
locals {
  firewall_rule_configs = {
    block : {
      Block_CN : {
        description : "Block CN"
        filter_expression : "(ip.geoip.country eq \"CN\")"
        priority : "2000"
      }
    }
    challenge : {
      Challenge_PW_Attack : {
        description : "Challenge PW Attack"
        filter_expression : "(http.request.uri.path eq \"/v1/login/\" and http.host eq \"api.abc.com\")"
        priority : "1800"
      }
    }
  }
}

module "cloudflare" {
  source    = "./cloudflare"
  zone_name = "abc.com"
  firewall_rule_configs = local.firewall_rule_configs
}
```

### Configure Cloudflare Page Rules

* The order of page_rule in the configuration will be the same as the order you see Cloudflare's UI
* When adding/removing/re-ordering, this module will re-calculate new priority/order automatically.

```hcl
locals {
  page_rule_configs = [
    {
      target   = "https://m.abc.com/*"
      status   = "disabled"
      actions = {
        forwarding_url = [{
          status_code = "301"
          url         = "https://abc.com"
        }]
      }
    },
    {
      target   = "http://abc.com/*"
      actions = {
        always_use_https = "true"
      }
    }
  ]
}

module "cloudflare" {
  source    = "./cloudflare"
  zone_name = "abc.com"
  page_rule_configs = local.page_rule_configs
}
```
### Configure Cloudflare Records
```hcl
locals {
  record_configs = {
    TXT : [],
    A : [
      {
        name : "jenkins-demo"
        value : "10.10.20.70"
      },
      {
        name : "vault-lab"
        value : "10.10.20.70"
      },
      {
        name : "wg-vpn"
        value : "10.10.20.70"
      }
    ],
    CNAME : [
      {
        name : "search"
        value : "google.com"
      }
    ],
    MX : [
      {
        name : "abc.com"
        priority : 5
        value : "alt1.aspmx.l.google.com"
        resource_name : "MX_1"
      },
      {
        name : "abc.com"
        priority : 10
        value : "aspmx2.googlemail.com"
        resource_name : "MX_2"
      },
      {
        name : "abc.com"
        priority : 5
        value : "alt2.aspmx.l.google.com"
        resource_name : "MX_3"
      }
    ],
  }
}
```
