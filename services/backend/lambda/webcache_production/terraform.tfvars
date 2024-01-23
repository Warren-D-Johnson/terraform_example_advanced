environment = "production"

env_vars = {
  "staging" = {
    RUNNING_ENV = "STAGING"
  }
  "beta" = {
    RUNNING_ENV = "BETA"
  }
  "production" = {
    RUNNING_ENV = "PRODUCTION"
  }
}

lambda_name          = "es_webcache"
lambda_role_name     = "lambda_role_webcache_production"
handler              = "index.handler"
runtime              = "nodejs18.x"
memory_size          = 512
timeout              = 5
function_description = "Production web cache"
ddb_access_policy    = "DDB_CACHE_TABLES"