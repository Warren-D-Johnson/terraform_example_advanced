provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zones" "selected" {
  filter {
    name = var.domain_name
  }
}

resource "cloudflare_page_rule" "assets01_ssl_flexible" {
  zone_id  = data.cloudflare_zones.selected.zones[0].id
  target = "assets01*${var.domain_name}/*"
  priority = 4

  actions {
    ssl = "flexible"
  }
}

resource "cloudflare_page_rule" "cache_everything" {
  zone_id  = data.cloudflare_zones.selected.zones[0].id
  target   = "www.${var.domain_name}/*"
  priority = 3

  actions {
    cache_level = "cache_everything"
  }
}


resource "cloudflare_page_rule" "cms_to_admin" {
  zone_id  = data.cloudflare_zones.selected.zones[0].id
  target   = "https://cms.example.com/"
  priority = 2

  actions {
    forwarding_url {
      url         = "https://cms.${var.domain_name}/admin"
      status_code = 301
    }
  }
}


resource "cloudflare_page_rule" "apex_redirect" {
  zone_id  = data.cloudflare_zones.selected.zones[0].id
  target   = "${var.domain_name}/*"
  priority = 1

  actions {
    forwarding_url {
      url         = "https://www.${var.domain_name}"
      status_code = 301
    }
  }
}


