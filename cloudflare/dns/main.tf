provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zones" "selected" {
  filter {
    name = var.domain_name
  }
}

resource "cloudflare_record" "apex_cname" {   # cloudflare uses cname flattening to get a CNAME record at apex
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.apex_cname_name
  value   = var.apex_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

resource "cloudflare_record" "api_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.api_cname_name
  value   = var.api_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

# Production
resource "cloudflare_record" "cms_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.cms_cname_name
  value   = var.cms_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

resource "cloudflare_record" "www_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.www_cname_name
  value   = var.api_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

resource "cloudflare_record" "assets01_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.assets01_cname_name
  value   = var.assets01_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

# Beta
resource "cloudflare_record" "cmsbeta_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.cmsbeta_cname_name
  value   = var.cmsbeta_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

resource "cloudflare_record" "wwwbeta_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.wwwbeta_cname_name
  value   = var.wwwbeta_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

resource "cloudflare_record" "assets01beta_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.assets01beta_cname_name
  value   = var.assets01beta_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

# Staging
resource "cloudflare_record" "cmsstaging_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.cmsstaging_cname_name
  value   = var.cmsstaging_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

resource "cloudflare_record" "wwwstaging_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.wwwstaging_cname_name
  value   = var.wwwstaging_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}

resource "cloudflare_record" "assets01staging_cname" {
  zone_id = data.cloudflare_zones.selected.zones[0].id
  name    = var.assets01staging_cname_name
  value   = var.assets01staging_cname_value
  type    = "CNAME"
  proxied = true  # Set to true to enable Cloudflare's proxy
}
