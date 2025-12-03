import * as cdk from "aws-cdk-lib/core";
import * as ec2 from "aws-cdk-lib/aws-ec2";
import * as rds from "aws-cdk-lib/aws-rds";

import { Construct } from "constructs";

/*
 * Stack that creates an RDS MySQL instance.
 */
export class FlywayMySQLRDSStack extends cdk.Stack {
	constructor(scope: Construct, id: string, props?: cdk.StackProps) {
		super(scope, id, Object.assign({}, props, {
			stackName: "FlywayMySQLRDSTestStack",
			description: "RDS instance for testing flyway-mysql-rds project.",
			env: {
				account: process.env.CDK_DEFAULT_ACCOUNT,
				region: process.env.CDK_DEFAULT_REGION,
			}
		}));

		const vpc = ec2.Vpc.fromLookup(this, "DefaultVPC", {
			isDefault: true,
		});

		const version = rds.MysqlEngineVersion.of("8.0.43", "8.0");

		const instance = new rds.DatabaseInstance(this, "FlywayMySQLRDSTestInstance", {
			engine: rds.DatabaseInstanceEngine.mysql({
				version
			}),

			instanceIdentifier: "flyway-mysql-rds-test",

			credentials: rds.Credentials.fromPassword(
				"root",
				cdk.SecretValue.unsafePlainText("Welcome123")
			),

			instanceType: ec2.InstanceType.of(
				ec2.InstanceClass.T3,
				ec2.InstanceSize.MICRO
			),

			// 20 GB minimum for RDS
			allocatedStorage: 20,
			storageType: rds.StorageType.GP2,

			// Disables autoscaling
			maxAllocatedStorage: undefined,

			vpc,

			vpcSubnets: {
				subnetType: ec2.SubnetType.PUBLIC,
			},

			// No backups to save cost
			backupRetention: cdk.Duration.days(0),
			deleteAutomatedBackups: true,

			// Single AZ (not multi-AZ for cost)
			multiAz: false,

			// No availability zone preference
			availabilityZone: undefined,

			removalPolicy: cdk.RemovalPolicy.DESTROY,
			deletionProtection: false,

			// Allow public access
			publiclyAccessible: true,

			// Disable enhanced monitoring
			enablePerformanceInsights: false,
			monitoringInterval: cdk.Duration.seconds(0),

			// Disable CloudWatch logs
			cloudwatchLogsExports: [],

			// Allow automatic minor version upgrades
			autoMinorVersionUpgrade: false,
		});

		instance.connections.allowDefaultPortFromAnyIpv4("Open to the world");

		new cdk.CfnOutput(this, "DBEndpoint", {
			value: instance.dbInstanceEndpointAddress,
			description: "Database endpoint address",
			exportName: `${this.stackName}-DBEndpoint`,
		});
	}
}
