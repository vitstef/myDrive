<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_account_public_access_block.s3_account_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_bucket_server_side_encryption_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [google_cloud_run_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service) | resource |
| [google_cloud_run_service_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_compute_backend_service.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_forwarding_rule.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_region_network_endpoint_group.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group) | resource |
| [google_compute_target_https_proxy.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| [google_dns_record_set.https-A](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_compute_ssl_certificate.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_ssl_certificate) | data source |
| [google_dns_managed_zone.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone) | data source |
| [google_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"prod"` | no |
| <a name="input_gcr-network-endpoint-group-region"></a> [gcr-network-endpoint-group-region](#input\_gcr-network-endpoint-group-region) | n/a | `string` | n/a | yes |
| <a name="input_gcr-service-location"></a> [gcr-service-location](#input\_gcr-service-location) | n/a | `string` | n/a | yes |
| <a name="input_google-project"></a> [google-project](#input\_google-project) | n/a | `string` | n/a | yes |
| <a name="input_image-repo"></a> [image-repo](#input\_image-repo) | n/a | `string` | n/a | yes |
| <a name="input_key"></a> [key](#input\_key) | n/a | `string` | `"1234567890"` | no |
| <a name="input_limit-switch"></a> [limit-switch](#input\_limit-switch) | n/a | `map` | <pre>{<br>  "": 0,<br>  "large": 3,<br>  "medium": 2,<br>  "small": 1<br>}</pre> | no |
| <a name="input_limits"></a> [limits](#input\_limits) | n/a | <pre>list(object({<br>      cpu = number,<br>      memory = string       <br>  }))</pre> | <pre>[<br>  {<br>    "cpu": null,<br>    "memory": null<br>  },<br>  {<br>    "cpu": 1,<br>    "memory": "1Gi"<br>  },<br>  {<br>    "cpu": 2,<br>    "memory": "2Gi"<br>  },<br>  {<br>    "cpu": 4,<br>    "memory": "4Gi"<br>  }<br>]</pre> | no |
| <a name="input_mongodb-ip"></a> [mongodb-ip](#input\_mongodb-ip) | n/a | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | n/a | `string` | `"1234567890"` | no |
| <a name="input_password-access"></a> [password-access](#input\_password-access) | n/a | `string` | `"1234567890"` | no |
| <a name="input_password-cookie"></a> [password-cookie](#input\_password-cookie) | n/a | `string` | `"1234567890"` | no |
| <a name="input_password-refresh"></a> [password-refresh](#input\_password-refresh) | n/a | `string` | `"1234567890"` | no |
| <a name="input_remote-url"></a> [remote-url](#input\_remote-url) | n/a | `string` | `"http://localhost:3000"` | no |
| <a name="input_s3-id"></a> [s3-id](#input\_s3-id) | n/a | `string` | n/a | yes |
| <a name="input_s3-key"></a> [s3-key](#input\_s3-key) | n/a | `string` | n/a | yes |
| <a name="input_vm-size"></a> [vm-size](#input\_vm-size) | n/a | `string` | `""` | no |
| <a name="input_vpc-access-connector"></a> [vpc-access-connector](#input\_vpc-access-connector) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->