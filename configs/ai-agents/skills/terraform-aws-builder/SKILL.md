---
name: terraform-aws-builder
description: 'Generate Terraform modules for AWS infrastructure including VPC, EKS, RDS, S3, Lambda, CloudFront, IAM roles with least-privilege, remote state, and cost optimization'
---

# Purpose

Create production-ready Terraform infrastructure-as-code following AWS Well-Architected Framework principles with security, reliability, and cost optimization.

## When to Use

Use this skill when the task involves:

- Provisioning AWS resources with Terraform
- Creating reusable Terraform modules
- Setting up VPCs, EKS clusters, RDS, or serverless resources
- Defining IAM roles and policies
- Configuring remote state and state locking
- Estimating or optimizing infrastructure costs

## Constraints

- Use **Terraform 1.5+** syntax with modern features
- Apply **least-privilege IAM** — no `*` actions or resources without justification
- Configure **remote state** with S3 + DynamoDB locking
- Use **data sources** to reference existing resources
- Tag all resources with **environment, project, owner**
- Include **cost comments** for expensive resources
- Use **locals** for computed values to avoid repetition

## Execution Steps

1. **Define requirements** — Identify resources, sizing, availability needs
2. **Structure modules** — Create reusable modules with clear interfaces
3. **Configure providers** — Set up AWS provider with region and assume_role
4. **Implement resources** — Create resources with proper dependencies
5. **Add IAM** — Define roles and policies with least-privilege
6. **Configure outputs** — Export values needed by other modules/consumers
7. **Document costs** — Add comments with estimated monthly costs

## Examples

### Input

> Create a Terraform module for an S3 bucket with versioning and encryption

### Output

```hcl
# modules/s3-bucket/main.tf

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

# Cost: ~$0.023/GB/month for S3 Standard
```

## Related Skills

- `docker-k8s-optimizer` — Deploy containers to EKS
- `system-planning-assistant` — High-level architecture decisions
