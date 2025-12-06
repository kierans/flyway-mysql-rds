# Flyway MySQL RDS AWS

This CDK project provides Stacks to assist in testing the Flyway MySQL RDS AWS integration.
While Docker is sufficient for testing some changes, for testing SSL certificate validation,
a real RDS instance is required.

This CDK project provides two stacks:

- `FlywayMySQLRDSGithubIdentityStack` - This stack creates an IAM role that can be assumed by
GitHub Action runners to create and destroy RDS instances. It uses [OIDC to authenticate][1] a 
runner. Because it creates an IAM role needed by the GitHub Action runners, it must be
deployed manually. Either via the CLI using a user's AWS credentials, or another GitHub Actions
workflow that deploys the stack.

- `FlywayMySQLRDSStack` - Creates an RDS instance for testing.

## Usage

```shell
$ cdk deploy <stack-name>
```

### Notes

Because the `FlywayMySQLRDSGithubIdentityStack` is assumed by the runner to deploy or destroy
another Stack (`FlywayMySQLRDSStack`) it has a permission to assume the CDK roles that are
created when [bootstrapping the CDK][2] into the target AWS account. Because those roles have
permissions to manipulate other AWS resources, a user may wish to further restrict what 
resources the `FlywayMySQLRDSGithubIdentityStack` role can access.

[1]: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
[2]: https://docs.aws.amazon.com/cdk/v2/guide/bootstrapping-env.html#bootstrapping-env-default
