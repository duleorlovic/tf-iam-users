# Utils account containing users
provider "aws" {
  profile = "2022trk"
}

# Prod account, use as: aws.prod
provider "aws" {
  profile = "duleorlovic"
  alias   = "prod"
}
