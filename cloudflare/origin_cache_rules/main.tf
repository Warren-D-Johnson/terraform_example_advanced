provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zones" "selected" {
  filter {
    name = var.domain_name
  }
}

# set origin caching rule for all traffic coming into www.example.com  
resource "cloudflare_ruleset" "origin_cache_1" {
  zone_id     = data.cloudflare_zones.selected.zones[0].id
  name        = var.origin_cache_rule_name
  description = var.origin_cache_rule_name
  kind        = "zone"
  phase       = "http_request_cache_settings"

  rules {
    enabled    = true
    expression = "(http.host eq \"www.${var.domain_name}\") or (http.host eq \"staging.${var.domain_name}\") or (http.host eq \"beta.${var.domain_name}\")"
    action     = "set_cache_settings"

    action_parameters {
      edge_ttl {
        mode = "override_origin"
        default = 86400
      }
    }

    description = var.origin_cache_rule_name
  }
}

resource "cloudflare_tiered_cache" "example" {
  zone_id    = data.cloudflare_zones.selected.zones[0].id
  cache_type = "smart"
}