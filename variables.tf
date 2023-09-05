variable "stack_name" {
  description = "Name of the CloudFormation stack"
  default     = "oe_patterns_mastodon"
}

variable "VpcId" {
  description = "Optional: Specify the VPC ID. If not specified, a VPC will be created."
  default     = ""
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Optional: VPC IPv4 CIDR block if no VPC provided."
}

variable "vpc_nat_gateway_per_subnet" {
  type        = string
  default     = "false"
  description = "Optional: Set to 'true' to provision a NAT Gateway in each public subnet for AZ HA."
  validation {
    condition     = contains(["true", "false"], var.vpc_nat_gateway_per_subnet)
    error_message = "Allowed values are 'true' or 'false'."
  }
}

variable "vpc_private_subnet1_id" {
  type        = string
  default     = ""
  description = "Optional: Specify Subnet ID for private subnet 1."
}

variable "vpc_private_subnet1_cidr" {
  type        = string
  default     = "10.0.128.0/18"
  description = "Optional: VPC IPv4 CIDR block of private subnet 1 if no VPC provided."
}

variable "vpc_private_subnet2_id" {
  type        = string
  default     = ""
  description = "Optional: Specify Subnet ID for private subnet 2."
}

variable "vpc_private_subnet2_cidr" {
  type        = string
  default     = "10.0.192.0/18"
  description = "Optional: VPC IPv4 CIDR block of private subnet 2 if no VPC provided."
}

variable "vpc_public_subnet1_id" {
  type        = string
  default     = ""
  description = "Optional: Specify Subnet ID for public subnet 1."
}

variable "vpc_public_subnet1_cidr" {
  type        = string
  default     = "10.0.0.0/18"
  description = "Optional: VPC IPv4 CIDR block of public subnet 1 if no VPC provided."
}

variable "vpc_public_subnet2_id" {
  type        = string
  default     = ""
  description = "Optional: Specify Subnet ID for public subnet 2."
}

variable "vpc_public_subnet2_cidr" {
  type        = string
  default     = "10.0.64.0/18"
  description = "Optional: VPC IPv4 CIDR block of public subnet 2 if no VPC provided."
}

variable "name" {
  type        = string
  default     = "Mastodon"
  description = "The name of this Mastodon site."
}

variable "dns_route53_hosted_zone_name" {
  type        = string
  default     = ""
  description = "Optional: Route 53 Hosted Zone name. Must already exist and match the domain part of the Hostname parameter, without trailing dot."
}

variable "dns_hostname" {
  type        = string
  default     = ""
  description = "Optional: The hostname to access the service."
  validation {
    condition     = can(regex("^(?!.*/).*$", var.dns_hostname))
    error_message = "Hostname should not have any forward slashes."
  }
}

variable "assets_bucket_name" {
  type        = string
  default     = ""
  description = "Optional: Name of the S3 bucket to store uploaded assets. If not specified, a bucket will be created."
}

variable "ses_create_domain_identity" {
  type        = string
  default     = "true"
  description = "Optional: If 'true', a SES Domain Identity will be created from the hosted zone."
  validation {
    condition     = contains(["true", "false"], var.ses_create_domain_identity)
    error_message = "Allowed values: true, false."
  }
}

variable "db_secret_arn" {
  type        = string
  default     = ""
  description = "Optional: SecretsManager secret ARN for database credentials. If not specified, a secret will be created."
}
variable "redis_cluster_cache_node_type" {
  type        = string
  default     = "cache.t3.micro"
  description = "Required: Instance type for the cluster nodes."
}

variable "redis_cluster_num_cache_nodes" {
  type        = number
  default     = 1
  description = "Required: The number of cache nodes in the cluster."
  validation {
    condition     = var.redis_cluster_num_cache_nodes >= 1 && var.redis_cluster_num_cache_nodes <= 20
    error_message = "Value must be between 1 and 20."
  }
}

variable "open_search_service_ebs_volume_size" {
  type        = number
  default     = 10
  description = "Required: The size of the EBS volume for the OpenSearch node."
}

variable "open_search_service_node_type" {
  type        = string
  default     = "t3.small.search"
  description = "Required: Instance type for the OpenSearch Service nodes."
}

variable "open_search_service_create_service_linked_role" {
  type        = string
  default     = "true"
  description = "Whether or not to create a Service Linked Role for OpenSearch VPC access."
  validation {
    condition     = contains(["true", "false"], var.open_search_service_create_service_linked_role)
    error_message = "Allowed values: true, false."
  }
}

variable "asg_instance_type" {
  description = "Required: The EC2 instance type for the application Auto Scaling Group."
  type        = string
  default     = "t3.small"
}

variable "asg_reprovision_string" {
  description = "Optional: Changes to this parameter will force instance reprovision on the next CloudFormation update."
  type        = string
  default     = ""
}

variable "asg_desired_capacity" {
  description = "Required: The desired capacity of the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Required: The maximum size of the Auto Scaling Group."
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "Required: The minimum size of the Auto Scaling Group."
  type        = number
  default     = 1
}

variable "alb_certificate_arn" {
  description = "Required: Specify the ARN of a ACM Certificate to configure HTTPS."
  type        = string
}

variable "alb_ingress_cidr" {
  description = "Required: VPC IPv4 CIDR block to restrict access to ALB."
  type        = string
}

variable "db_backup_retention_period" {
  description = "Required: The number of days to retain automated db backups."
  type        = number
  default     = 7
}

variable "db_instance_class" {
  description = "Required: The class profile for memory and compute capacity for the database instance."
  type        = string
  default     = "db.t4g.medium"
}

variable "db_snapshot_identifier" {
  description = "Optional: RDS snapshot ARN from which to restore."
  type        = string
  default     = ""
}
