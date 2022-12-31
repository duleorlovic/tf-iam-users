# Terraform IAM users

This is a teffarom module which you can use to manage iam users

TODO: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-console.html

# Policy to assume role

Credits https://blog.container-solutions.com/how-to-create-cross-account-user-roles-for-aws-with-terraform
We are using AWS Security Token Service STS to request temporary credentials for
IAM. We need to defina a policy that defines who can assume a role on target
side (let's call it prod), as well on source side: which account can assume that
role  (let's call it utils).

Source https://github.com/charlottemach/cross-account-aws-iam-roles

You need to create two profiles in `~/.aws/credentials` and you can switch with
```
aws configure --profile duleorlovic
# this will add [profile duleorlovic] to ~/.aws/config
# and [duleorlovic] to ~/.aws/credentials
# you can use in terraform provider "aws" { profile = "duleorlovic" }
aws ec2 describe-vpcs --profile duleorlovic
```

Deploy with:

```
cd examples/assume_role_from_another_account
terraform init
terraform plan -out tfplan
terraform apply --auto-approve tfplan
```

To try you can use cli
```
aws iam list-roles --query "Roles[?RoleName == 's3-list-role'].[RoleName, Arn]" --profile duleorlovic
# save the role-arn
[
    [
        "s3-list-role",
        "arn:aws:iam::219232999684:role/s3-list-role"
    ]
]


aws sts assume-role --role-arn arn:aws:iam::219232999684:role/s3-list-role --role-session-name "some-name"
# save credentials
{
    "Credentials": {
        "AccessKeyId": "ASI...",
        "SecretAccessKey": "IVv...",
        "SessionToken": "IQoJb3Jp...",
        "Expiration": "2022-12-31T10:04:52+00:00"
    },
    "AssumedRoleUser": {
        "AssumedRoleId": "AROATGC2ODECO2Q7CFCZ2:some-name",
        "Arn": "arn:aws:sts::219232999684:assumed-role/s3-list-role/some-name"
    }
}


export AWS_ACCESS_KEY_ID=ASI...
export AWS_SECRET_ACCESS_KEY=IVv...
export AWS_SESSION_TOKEN=IQoJb3Jp...

echo $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY $AWS_SESSION_TOKEN

aws s3api list-buckets
# this should list target (duleorlovic) buckets
    "Owner": {
        "DisplayName": "duleorlovic",

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
echo $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY $AWS_SESSION_TOKEN
```

You can use web console when you log in as `random user` you can see the `@` in
top right name, you can click on `Switch role` (or you can copy the link from
role page and role name and account will be automatically populated
https://signin.aws.amazon.com/switchrole?roleName=s3-list-role&account=duleorlovic
)
