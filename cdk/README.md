# Flyway MySQL RDS AWS

This CDK project provides Stacks to assist in testing the Flyway MySQL RDS AWS integration.
While Docker is sufficient for testing some changes, for testing SSL certificate validation,
a real RDS instance is required.

This CDK project provides two stacks:

- `FlywayMySQLRDSGithubIdentityStack` - This stack creates an IAM role that can be assumed by
GitHub Action runners to create and destroy RDS instances. It uses [OIDC to authenticate][1] a 
runner. Because it creates an IAM role needed by the GitHub Action runners, it must be
deployed manually. Either via the CLI using a user's AWS credentials, or another GitHub Actions
workflow that authenticates via OIDC and assumes a role that can create IAM roles.

- `FlywayMySQLRDSStack` - Creates an RDS instance for testing.

## Usage

```shell
$ cdk deploy <stack-name>
```

[1]: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
