#!/usr/bin/env node

import * as cdk from "aws-cdk-lib/core";

import { FlywayMySQLRDSGithubIdentityStack } from "../lib/flyway-mysql-rds-github-identity-stack";
import { FlywayMySQLRDSStack } from "../lib/flyway-mysql-rds-stack";

const app = new cdk.App();

new FlywayMySQLRDSGithubIdentityStack(app, "FlywayMysqlRRDSGithubIdentityStack");
new FlywayMySQLRDSStack(app, "FlywayMySQLRDSStack");
