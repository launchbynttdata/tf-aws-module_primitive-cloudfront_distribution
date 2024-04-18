# tf-aws-module_primitive-wafv2_web_acl_regional

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

Provides a Regional Web ACL for a WAFv2 Resource. To obtain a non-regional (CloudFront) Web ACL, use the global variant, [found here](https://github.com/launchbynttdata/tf-aws-module_primitive-wafv2_web_acl_global).

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.45.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Extra CNAMEs (alternate domain names), if any, for this distribution. | `list(string)` | `[]` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Any comments you want to include about the distribution. | `string` | `null` | no |
| <a name="input_continuous_deployment_policy_id"></a> [continuous\_deployment\_policy\_id](#input\_continuous\_deployment\_policy\_id) | Identifier of a continuous deployment policy. This argument should only be set on a production distribution. See the aws\_cloudfront\_continuous\_deployment\_policy resource for additional details: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_continuous_deployment_policy | `string` | `null` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | One or more custom error response elements. | <pre>list(object({<br>    error_caching_min_ttl = optional(number, null)<br>    error_code            = number<br>    response_code         = optional(number, null)<br>    response_page_path    = optional(string, null)<br>  }))</pre> | `[]` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | Default cache behavior for this distribution. | <pre>object({<br>    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br>    cached_methods            = optional(list(string), ["GET", "HEAD"])<br>    cache_policy_id           = string<br>    compress                  = optional(bool, false)<br>    default_ttl               = optional(number, null)<br>    field_level_encryption_id = optional(string, null)<br>    lambda_function_association = optional(list(object({<br>      event_type   = string<br>      function_arn = string<br>    })), [])<br>    function_association = optional(list(object({<br>      event_type   = string<br>      function_arn = string<br>    })), [])<br>    max_ttl                    = optional(number, null)<br>    min_ttl                    = optional(number, null)<br>    origin_request_policy_id   = optional(string, null)<br>    realtime_log_config_arn    = optional(string, null)<br>    response_headers_policy_id = optional(string, null)<br>    smooth_streaming           = optional(bool, null)<br>    target_origin_id           = string<br>    trusted_key_groups         = optional(list(string), [])<br>    trusted_signers            = optional(list(string), [])<br>    viewer_protocol_policy     = optional(string, "redirect-to-https")<br>  })</pre> | n/a | yes |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Object that you want CloudFront to return (e.g. `index.html`) when an end user requests the root URL. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the distribution is enabled to accept end user requests for content. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | Whether the IPv6 is enabled for the distribution. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | Maximum HTTP version to support on the distribution. Allowed values are `http1.1`, `http2`, `http2and3` and `http3`. The default is `http2`. | `string` | `"http2"` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | The logging configuration that controls how logs are written to your distribution. | <pre>object({<br>    bucket          = string<br>    include_cookies = optional(bool, false)<br>    prefix          = optional(string, null)<br>  })</pre> | `null` | no |
| <a name="input_ordered_cache_behavior"></a> [ordered\_cache\_behavior](#input\_ordered\_cache\_behavior) | Ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0. | <pre>list(object({<br>    allowed_methods           = optional(list(string), ["GET", "HEAD", "OPTIONS"])<br>    cached_methods            = optional(list(string), ["GET", "HEAD"])<br>    cache_policy_id           = optional(string, null)<br>    compress                  = optional(bool, false)<br>    default_ttl               = optional(number, null)<br>    field_level_encryption_id = optional(string, null)<br>    lambda_function_association = optional(list(object({<br>      event_type   = string<br>      function_arn = string<br>      include_body = optional(bool, false)<br>    })), [])<br>    function_association = optional(list(object({<br>      event_type   = string<br>      function_arn = string<br>    })), [])<br>    max_ttl                    = optional(number, null)<br>    min_ttl                    = optional(number, null)<br>    origin_request_policy_id   = optional(string, null)<br>    path_pattern               = optional(string, null)<br>    realtime_log_config_arn    = optional(string, null)<br>    response_headers_policy_id = optional(string, null)<br>    smooth_streaming           = optional(bool, null)<br>    target_origin_id           = string<br>    trusted_key_groups         = optional(list(string), [])<br>    trusted_signers            = optional(list(string), [])<br>    viewer_protocol_policy     = optional(string, "redirect-to-https")<br>  }))</pre> | `[]` | no |
| <a name="input_origin"></a> [origin](#input\_origin) | Map of origins for this distribution. | <pre>map(object({<br>    connection_attempts = optional(number, 3)<br>    connection_timeout  = optional(number, 10)<br>    custom_origin_config = optional(object({<br>      http_port              = number<br>      https_port             = number<br>      origin_protocol_policy = optional(string, "https-only")<br>      origin_ssl_protocols   = optional(list(string), ["TLSv1.2"])<br>    }), null)<br>    domain_name = string<br>    custom_header = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>    origin_access_control_id = optional(string, null)<br>    origin_path              = optional(string, null)<br>    origin_shield = optional(object({<br>      enabled              = bool<br>      origin_shield_region = string<br>    }), null)<br>    s3_origin_config = optional(object({<br>      origin_access_identity = string<br>    }), null)<br>  }))</pre> | n/a | yes |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | Price class for this distribution. One of `PriceClass_All`, `PriceClass_100`, `PriceClass_200`. Defaults to `PriceClass_All`. | `string` | `"PriceClass_All"` | no |
| <a name="input_geo_restrictions_locations"></a> [geo\_restrictions\_locations](#input\_geo\_restrictions\_locations) | ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (`whitelist`) or not distribute your content (`blacklist`). If the type is specified as `none` an empty array can be used (default). | `list(string)` | `[]` | no |
| <a name="input_geo_restrictions_type"></a> [geo\_restrictions\_type](#input\_geo\_restrictions\_type) | Method that you want to use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`. | `string` | `"none"` | no |
| <a name="input_staging"></a> [staging](#input\_staging) | A Boolean that indicates whether this is a staging distribution. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of key-value pairs to associate with the resource. | `map(string)` | `{}` | no |
| <a name="input_viewer_certificate"></a> [viewer\_certificate](#input\_viewer\_certificate) | The SSL configuration for this distribution. Will use the cloudfront\_default\_certificate unless `acm_certificate_arn` or `iam_certificate_id` are specified (pick one; do not specify both). For specifics on configuration of minimum protocol versions, see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#viewer-certificate-arguments. | <pre>object({<br>    acm_certificate_arn      = optional(string, null)<br>    iam_certificate_id       = optional(string, null)<br>    minimum_protocol_version = optional(string, "TLSv1")<br>    ssl_support_method       = optional(string, "sni-only")<br>  })</pre> | <pre>{<br>  "acm_certificate_arn": null,<br>  "iam_certificate_id": null,<br>  "minimum_protocol_version": "TLSv1",<br>  "ssl_support_method": null<br>}</pre> | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | Unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution. To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws\_wafv2\_web\_acl.example.arn. To specify a web ACL created using AWS WAF Classic, use the ACL ID, for example aws\_waf\_web\_acl.example.id. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. | `string` | `null` | no |
| <a name="input_retain_on_delete"></a> [retain\_on\_delete](#input\_retain\_on\_delete) | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. Default: `false`. | `bool` | `false` | no |
| <a name="input_wait_for_deployment"></a> [wait\_for\_deployment](#input\_wait\_for\_deployment) | If enabled, the resource will wait for the distribution status to change from `InProgress` to `Deployed`. Setting this to `false` will skip the process. Default: `true`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront Distribution. |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN of the CloudFront Distribution. |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront\_distribution\_status](#output\_cloudfront\_distribution\_status) | The deployment status of the CloudFront Distribution. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The Domain Name of the CloudFront Distribution. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
