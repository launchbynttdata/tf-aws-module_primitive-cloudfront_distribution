// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(string)
  default     = []
}

variable "comment" {
  description = "Any comments you want to include about the distribution."
  type        = string
  default     = null
}

variable "continuous_deployment_policy_id" {
  description = "Identifier of a continuous deployment policy. This argument should only be set on a production distribution. See the aws_cloudfront_continuous_deployment_policy resource for additional details: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_continuous_deployment_policy"
  type        = string
  default     = null
}

variable "custom_error_response" {
  description = "One or more custom error response elements."
  type = list(object({
    error_caching_min_ttl = optional(number, null)
    error_code            = number
    response_code         = optional(number, null)
    response_page_path    = optional(string, null)
  }))
  default = []
}

variable "default_cache_behavior" {
  description = "Default cache behavior for this distribution."
  type = object({
    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods            = optional(list(string), ["GET", "HEAD"])
    cache_policy_id           = string
    compress                  = optional(bool, false)
    default_ttl               = optional(number, null)
    field_level_encryption_id = optional(string, null)
    lambda_function_association = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
    function_association = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
    max_ttl                    = optional(number, null)
    min_ttl                    = optional(number, null)
    origin_request_policy_id   = optional(string, null)
    realtime_log_config_arn    = optional(string, null)
    response_headers_policy_id = optional(string, null)
    smooth_streaming           = optional(bool, null)
    target_origin_id           = string
    trusted_key_groups         = optional(list(string), [])
    trusted_signers            = optional(list(string), [])
    viewer_protocol_policy     = optional(string, "redirect-to-https")
  })
}

variable "default_root_object" {
  description = "Object that you want CloudFront to return (e.g. `index.html`) when an end user requests the root URL."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content. Defaults to `true`."
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution. Defaults to `false`."
  type        = bool
  default     = false
}

variable "http_version" {
  description = "Maximum HTTP version to support on the distribution. Allowed values are `http1.1`, `http2`, `http2and3` and `http3`. The default is `http2`."
  type        = string
  default     = "http2"

  validation {
    condition     = contains(["http1.1", "http2", "http2and3", "http3"], var.http_version)
    error_message = "http_version must be one of http1.1, http2, http2and3, http3"
  }
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution."
  type = object({
    bucket          = string
    include_cookies = optional(bool, false)
    prefix          = optional(string, null)
  })
  default = null
}

variable "ordered_cache_behavior" {
  description = "Ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0."
  type = list(object({
    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods            = optional(list(string), ["GET", "HEAD"])
    cache_policy_id           = optional(string, null)
    compress                  = optional(bool, false)
    default_ttl               = optional(number, null)
    field_level_encryption_id = optional(string, null)
    lambda_function_association = optional(list(object({
      event_type   = string
      function_arn = string
      include_body = optional(bool, false)
    })), [])
    function_association = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
    max_ttl                    = optional(number, null)
    min_ttl                    = optional(number, null)
    origin_request_policy_id   = optional(string, null)
    path_pattern               = optional(string, null)
    realtime_log_config_arn    = optional(string, null)
    response_headers_policy_id = optional(string, null)
    smooth_streaming           = optional(bool, null)
    target_origin_id           = string
    trusted_key_groups         = optional(list(string), [])
    trusted_signers            = optional(list(string), [])
    viewer_protocol_policy     = optional(string, "redirect-to-https")
  }))
  default = []
}

variable "origin" {
  description = "Map of origins for this distribution."
  type = map(object({
    connection_attempts = optional(number, 3)
    connection_timeout  = optional(number, 10)
    custom_origin_config = optional(object({
      http_port              = number
      https_port             = number
      origin_protocol_policy = optional(string, "https-only")
      origin_ssl_protocols   = optional(list(string), ["TLSv1.2"])
    }), null)
    domain_name = string
    custom_header = optional(list(object({
      name  = string
      value = string
    })), [])
    origin_access_control_id = optional(string, null)
    origin_path              = optional(string, null)
    origin_shield = optional(object({
      enabled              = bool
      origin_shield_region = string
    }), null)
    s3_origin_config = optional(object({
      origin_access_identity = string
    }), null)
  }))
}

# variable "origin_group" {
#   description = "List of origin_groups for this distribution."
#   type        = list(string) # ???
# }

variable "price_class" {
  description = "Price class for this distribution. One of `PriceClass_All`, `PriceClass_100`, `PriceClass_200`. Defaults to `PriceClass_All`."
  type        = string
  default     = "PriceClass_All"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "price_class must be one of PriceClass_All, PriceClass_100, PriceClass_200"
  }
}

variable "geo_restrictions_locations" {
  description = "ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (`whitelist`) or not distribute your content (`blacklist`). If the type is specified as `none` an empty array can be used (default)."
  type        = list(string)
  default     = []
}

variable "geo_restrictions_type" {
  description = "Method that you want to use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.geo_restrictions_type)
    error_message = "geo_restrictions_type must be one of none, whitelist, blacklist"
  }
}

variable "staging" {
  description = "A Boolean that indicates whether this is a staging distribution. Defaults to `false`."
  type        = bool
  default     = false

}

variable "tags" {
  description = "Map of key-value pairs to associate with the resource."
  type        = map(string)
  default     = {}
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution. Will use the cloudfront_default_certificate unless `acm_certificate_arn` or `iam_certificate_id` are specified (pick one; do not specify both). For specifics on configuration of minimum protocol versions, see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#viewer-certificate-arguments."
  type = object({
    acm_certificate_arn      = optional(string, null)
    iam_certificate_id       = optional(string, null)
    minimum_protocol_version = optional(string, "TLSv1")
    ssl_support_method       = optional(string, "sni-only")
  })
  default = {
    acm_certificate_arn      = null
    iam_certificate_id       = null
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = null
  }
}

variable "web_acl_id" {
  description = "Unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution. To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws_wafv2_web_acl.example.arn. To specify a web ACL created using AWS WAF Classic, use the ACL ID, for example aws_waf_web_acl.example.id. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned."
  type        = string
  default     = null
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. Default: `false`."
  type        = bool
  default     = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from `InProgress` to `Deployed`. Setting this to `false` will skip the process. Default: `true`."
  type        = bool
  default     = true
}
