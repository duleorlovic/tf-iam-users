resource "aws_iam_user" "random" {
  name = "random_user"

  tags = {
    name = "random"
  }
}

resource "aws_iam_policy" "prod_s3" {
  name        = "prod_s3"
  description = "allow assuming prod_s3 role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::${data.aws_caller_identity.prod.account_id}:role/${aws_iam_role.prod_list_s3.name}"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "prod_s3" {
  user       = aws_iam_user.random.name
  policy_arn = aws_iam_policy.prod_s3.arn
}
