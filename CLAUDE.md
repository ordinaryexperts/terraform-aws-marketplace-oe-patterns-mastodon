# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Terraform module that wraps the Ordinary Experts AWS Marketplace Pattern for Mastodon. The module provisions Mastodon infrastructure on AWS by deploying a CloudFormation stack from a pre-built template URL.

**Important:** Users must subscribe to the AWS Marketplace product before using this module:
https://aws.amazon.com/marketplace/pp/prodview-fnphbgo3yktrg

## Architecture

The module is a CloudFormation stack wrapper (`main.tf:11`) that:
- Creates a CloudFormation stack using a fixed template URL hosted in S3
- Passes Terraform variables as CloudFormation parameters
- Provisions a complete Mastodon deployment including VPC, RDS, Redis, OpenSearch, ALB, and Auto Scaling Group
- Supports both creating new infrastructure or using existing VPC/subnets

The infrastructure is defined in the CloudFormation template (not in this repo), but this module provides a Terraform interface to it.

## Common Commands

### Initialize Terraform
```bash
terraform init
```

### Validate and Format
```bash
terraform fmt        # Format code
terraform fmt -check # Check formatting without changes
terraform validate   # Validate configuration
```

### Testing
```bash
terraform test       # Run all tests (uses tests/mastodon.tftest.hcl)
```

Tests use Terraform's native test framework with two phases:
1. `setup_tests` - Creates a random prefix for resource naming (tests/setup/main.tf)
2. `provision_mastodon` - Deploys the stack with test configuration and validates outputs

### Deploy/Manage
```bash
terraform plan       # Preview changes
terraform apply      # Apply changes
terraform destroy    # Destroy infrastructure
```

## Key Configuration Notes

### Required Variables
- `alb_certificate_arn` - ACM certificate ARN for HTTPS (required)
- `alb_ingress_cidr` - CIDR block to restrict ALB access (required)

### VPC Configuration
The module supports two modes:
1. **Create new VPC:** Leave `vpc_id` empty, configure CIDR blocks via `vpc_*_cidr` variables
2. **Use existing VPC:** Set `vpc_id` and `vpc_*_subnet*_id` variables

### CloudFormation Integration
- Stack timeout: 120 minutes (`main.tf:19-22`)
- Requires `CAPABILITY_NAMED_IAM` capability (`main.tf:16`)
- All Terraform variables map directly to CloudFormation parameters (`main.tf:24-60`)

### Test Account Specifics
The test configuration (`tests/mastodon.tftest.hcl`) includes:
- Test domain: `test.patterns.ordinaryexperts.com`
- `open_search_service_create_service_linked_role = false` - role already exists
- `ses_create_domain_identity = false` - identity already exists

## CI/CD

GitHub Actions workflow (`.github/workflows/main.yml`) runs on:
- Push to main
- Pull requests to main
- Weekly schedule (Mondays at 10:15 UTC)

Workflow steps: init → fmt check → validate → test
