# flyway-mysql-rds

Docker image for running Flyway against a MySQL DB in RDS

## Usage

`docker run --rm -e RDS_HOST=db.aws.com kierans777/flyway-mysql-rds:1.0.0 --help`

## SSL

As per [MySQL Security guidelines](https://dev.mysql.com/doc/refman/8.0/en/security-guidelines.html) you should never transmit data over an unecrypted connection. This image tries to verify the `RDS_HOST` certificate against the RDS CA (included in the image)

If you wish to change the `sslMode` used, the `SSL_MODE` env var is available.
