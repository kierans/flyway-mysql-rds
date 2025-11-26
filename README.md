# flyway-mysql-rds

Docker image for running [Flyway][6] against a MySQL DB in RDS

## Usage

`docker run --rm -e RDS_HOST=db.aws.com kierans777/flyway-mysql-rds:<version> --help`

(`<version>` is the numerical string of the tagged release eg: `1.1.0`)

## SSL

As per [MySQL Security guidelines](https://dev.mysql.com/doc/refman/8.0/en/security-guidelines.html) you should never transmit data over an unecrypted connection. This image tries to verify the `RDS_HOST` certificate against the RDS CA (included in the image)

If you wish to change the `sslMode` used, the `SSL_MODE` env var is available. Values must be compliant with the [MySQL JDBC sslMode options](https://dev.mysql.com/doc/connector-j/8.1/en/connector-j-connp-props-security.html)

## Version support table

The project supports multiple versions of Flyway, MySQL and the RDS CA. The versioning 
scheme uses the major number for the flyway major version, the minor version for when the 
base image or RDS CA is updated, and the patch version for updates to flyway configuration, 
scripts, etc.

The following table shows the versions of the image and what that image supports.

| **Version** | **Flyway Version** | **RDS CA Version** | **My SQL LTS Version** |
|-------------|--------------------|--------------------|------------------------|
| [v1.0.x][4] | [6.0.3-alpine][1]  | [2015][2]          | 8.0                    |
| [v1.1.x][5] | [6.0.3-alpine][1]  | [2019][3]          | 8.0                    |

[1]: https://hub.docker.com/layers/flyway/flyway/6.0.3-alpine/images/sha256-1d607a7d04b483a7dfd2c1f27490bc5ffebf69063340a14d74262ee7711b46f4
[2]: https://s3.amazonaws.com/rds-downloads/rds-ca-2015-root.pem
[3]: https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem
[4]: https://hub.docker.com/layers/kierans777/flyway-mysql-rds/1.0.0/images/sha256-789880e38f406eb8f72a6971abf3a35c6ee50b45838fbc5ffe22727aa2422aaa
[5]: https://hub.docker.com/layers/kierans777/flyway-mysql-rds/1.1.0/images/sha256-e80e676a1e1f886560dad4b6302427d0c89229a728c5b8ab17f8479fab5b6b44
[6]: https://www.red-gate.com/products/flyway/
