variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "env_vars" {
  type = map(map(string))
}

variable "lambda_name" {
  type = string
}

variable "lambda_role_name" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "memory_size" {
  type = number
}

variable "function_description" {
  type = string
}

variable "timeout" {
  type = number
}

variable "ddb_access_policy" {
  type = string
}