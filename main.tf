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

resource "aws_cloudfront_distribution" "cloudfront_distribution" {

  enabled                         = var.enabled
  aliases                         = var.aliases
  comment                         = var.comment
  continuous_deployment_policy_id = var.continuous_deployment_policy_id
  default_root_object             = var.default_root_object
  is_ipv6_enabled                 = var.is_ipv6_enabled
  staging                         = var.staging
  web_acl_id                      = var.web_acl_id
  retain_on_delete                = var.retain_on_delete
  wait_for_deployment             = var.wait_for_deployment

  tags = var.tags

  default_cache_behavior {
    cache_policy_id          = var.default_cache_behavior.cache_policy_id
    origin_request_policy_id = var.default_cache_behavior.origin_request_policy_id
    target_origin_id         = var.default_cache_behavior.target_origin_id

    allowed_methods = var.default_cache_behavior.allowed_methods
    cached_methods  = var.default_cache_behavior.cached_methods
    compress        = var.default_cache_behavior.compress
    min_ttl         = var.default_cache_behavior.min_ttl
    default_ttl     = var.default_cache_behavior.default_ttl
    max_ttl         = var.default_cache_behavior.max_ttl

    field_level_encryption_id  = var.default_cache_behavior.field_level_encryption_id
    realtime_log_config_arn    = var.default_cache_behavior.realtime_log_config_arn
    response_headers_policy_id = var.default_cache_behavior.response_headers_policy_id
    smooth_streaming           = var.default_cache_behavior.smooth_streaming
    trusted_key_groups         = var.default_cache_behavior.trusted_key_groups
    trusted_signers            = var.default_cache_behavior.trusted_signers
    viewer_protocol_policy     = var.default_cache_behavior.viewer_protocol_policy

    dynamic "lambda_function_association" {
      for_each = var.default_cache_behavior.lambda_function_association

      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }

    dynamic "function_association" {
      for_each = var.default_cache_behavior.function_association

      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.lambda_arn
      }
    }

  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response

    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [1] : []

    content {
      bucket          = var.logging_config.bucket
      prefix          = var.logging_config.prefix
      include_cookies = var.logging_config.include_cookies
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior

    content {
      path_pattern     = ordered_cache_behavior.value.path_pattern
      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id
      min_ttl          = ordered_cache_behavior.value.min_ttl
      default_ttl      = ordered_cache_behavior.value.default_ttl
      max_ttl          = ordered_cache_behavior.value.max_ttl
      compress         = ordered_cache_behavior.value.compress

      field_level_encryption_id  = ordered_cache_behavior.value.field_level_encryption_id
      realtime_log_config_arn    = ordered_cache_behavior.value.realtime_log_config_arn
      response_headers_policy_id = ordered_cache_behavior.value.response_headers_policy_id
      smooth_streaming           = ordered_cache_behavior.value.smooth_streaming
      trusted_key_groups         = ordered_cache_behavior.value.trusted_key_groups
      trusted_signers            = ordered_cache_behavior.value.trusted_signers

      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy

      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_association

        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lambda_function_association.value.include_body
        }
      }

      dynamic "function_association" {
        for_each = ordered_cache_behavior.value.function_association

        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.lambda_arn
        }
      }
    }
  }

  dynamic "origin" {
    for_each = var.origin

    content {
      origin_id = origin.key

      connection_attempts      = origin.value.connection_attempts
      connection_timeout       = origin.value.connection_timeout
      domain_name              = origin.value.domain_name
      origin_access_control_id = origin.value.origin_access_control_id
      origin_path              = origin.value.origin_path

      dynamic "custom_header" {
        for_each = origin.value.custom_header

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [1] : []

        content {
          http_port              = origin.value.custom_origin_config.http_port
          https_port             = origin.value.custom_origin_config.https_port
          origin_protocol_policy = origin.value.custom_origin_config.origin_protocol_policy
          origin_ssl_protocols   = origin.value.custom_origin_config.origin_ssl_protocols
        }
      }

      dynamic "origin_shield" {
        for_each = origin.value.origin_shield != null ? [1] : []

        content {
          enabled              = origin.value.origin_shield.enabled
          origin_shield_region = origin.value.origin_shield.origin_shield_region
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.s3_origin_config != null ? [1] : []

        content {
          origin_access_identity = origin.value.origin_shield.s3_origin_config.origin_access_identity
        }
      }
    }
  }


  restrictions {
    geo_restriction {
      restriction_type = var.geo_restrictions_type
      locations        = var.geo_restrictions_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.viewer_certificate.acm_certificate_arn == null && var.viewer_certificate.iam_certificate_id == null ? true : false
    acm_certificate_arn            = var.viewer_certificate.acm_certificate_arn
    iam_certificate_id             = var.viewer_certificate.iam_certificate_id
    ssl_support_method             = var.viewer_certificate.acm_certificate_arn == null && var.viewer_certificate.iam_certificate_id == null ? var.viewer_certificate.ssl_support_method : null
    minimum_protocol_version       = var.viewer_certificate.minimum_protocol_version
  }

}
