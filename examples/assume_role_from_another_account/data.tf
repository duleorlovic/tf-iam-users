# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
# Access .account_id .arn and .user_id in which terraform is authorized
data "aws_caller_identity" "utils" {}

data "aws_caller_identity" "prod" {
  provider = aws.prod
}

