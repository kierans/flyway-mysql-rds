import * as cdk from "aws-cdk-lib/core";
import * as iam from "aws-cdk-lib/aws-iam";

import { Construct } from "constructs";

import { GithubActionsIdentityProvider, GithubActionsRole } from "aws-cdk-github-oidc";

/*
 * Stack that creates an IAM role for GitHub Actions to assume to access AWS resources.
 *
 * It assumes that an Identity Provider for GitHub has already been created in the AWS account.
 *
 * This is because the Identity Provider is a global resource and therefore has to be referenced
 * by this stack.
 */
export class FlywayMySQLRDSGithubIdentityStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, Object.assign({}, props, {
      stackName: "FlywayMysqlRDSGithubIdentityStack",
      description: "Role for GitHub Actions to assume to access AWS resources for the flyway-mysql-rds project."
    }));

    const owner = "kierans";
    const repo = "flyway-mysql-rds";
    const filter = "ref:refs/heads/*";

    const deployAccess = `repo:${owner}/${repo}:${filter ?? "*"}`;

    const provider = GithubActionsIdentityProvider.fromAccount(
      this,
      "GithubProvider"
    );

    const policy = new iam.ManagedPolicy(this, "FlywayMySQLRDSProvisioningPolicy", {
      managedPolicyName: "FlywayMySQLRDSProvisioningPolicy",
      description: "Allows provisioning of RDS instances for flyway-mysql-rds project.",
      statements: [
        new iam.PolicyStatement({
          sid: "RDSInstanceManagement",
          effect: iam.Effect.ALLOW,
          actions: [
            "rds:CreateDBInstance",
            "rds:DeleteDBInstance",
            "rds:DescribeDBInstances"
          ],
          resources: [
            "*"
          ]
        }),
        new iam.PolicyStatement({
          sid: "RDSSubnetGroupManagement",
          effect: iam.Effect.ALLOW,
          actions: [
            "rds:CreateDBSubnetGroup",
            "rds:DescribeDBSubnetGroups",
            "rds:DeleteDBSubnetGroup"
          ],
          resources: [
            "*"
          ]
        }),
        new iam.PolicyStatement({
          sid: "EC2NetworkAccess",
          effect: iam.Effect.ALLOW,
          actions: [
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs"
          ],
          resources: [
            "*"
          ]
        })
      ]
    });

    const role = new GithubActionsRole(this, "DBManagementRole", {
      provider,
      owner,
      repo,
      filter,
      managedPolicies: [
        policy
      ]
    });

    new cdk.CfnOutput(this, "GithubActionsRoleARN", {
      value: role.roleArn,
      description: `ARN for AWS IAM role with GitHub OIDC auth for ${deployAccess}`,
      exportName: "FlywayMySQLRDSGithubIdentityARN",
    })
  }
}
