# Developing Flyway MySQL RDS

The repo uses different branches for different versions of [Flyway][1].

Currently supported branches:
- `flyway6`

## Updating flyway version

If needing to update the Flyway version, checkout the branch and make necessary changes.

To test the image locally via Docker run

```shell
$ docker compose build
$ docker compose up
```

This will start a MySQL server and run the sample migrations against it.

Commit and push the changes to the branch. The CI workflow is configured to test the build via
Docker on a push.

### Finding base Flyway versions

Use the `scripts/fetch-tags.sh` script to fetch all Docker tags from Docker Hub.
Use the `find-latest-version.sh` script to find the latest version for a given major version.

## Updating RDS certificates

If RDS CA certificates change, add the new certs to `/opt/rds.jks` on main. Once validated,
merge main into each feature branch, test, and release.

## Testing against RDS

The migrations can be tested against RDS by using the following workflows in GitHub Actions
 - `Create new RDS Instance`
 - `Test Migrations via RDS`
 - `Destroy RDS instance`

In order to create/destroy an RDS instance, the AWS CDK is used. See that `cdk/README.md` for
more details on how to provision the target AWS account so that a GitHub runner can manipulate
RDS resources.

## Releasing

A new version can be released either by using the `Release Single Version` workflow or the
`Release Multiple Versions` workflow.

The single release workflow is for when a change is made to a single branch, for example,
updating the base Flyway version.

The multiple release workflow is for when a change is made to multiple branches, for example,
updating the RDS certificates across multiple branches.

### Updating README

Once a new version has been released, update the README version support table on `master` to
reflect the new version.

## Adding a new branch

If adding a new branch:
1. Branch from `master`
2. Update Flyway base image and other source files.
3. Test.
4. From `master`, create another branch and update
   - `DEVELOPING.md`
   - `multi-release.yaml`
   - `single-release.yaml`

[1]: https://www.red-gate.com/products/flyway/
