#!/usr/bin/env bash

# Wrapper script around executing Flyway with the correct parameters.
#
# As per https://flywaydb.org/documentation/commandline/#overriding-order most configuration
# can be specified via env vars to make the container portable between environments.
#
# Defaults are specified in the flyway conf file.

set -e

if [[ "${RDS_HOST}" = "" ]] ; then
	echo "Error: \$RDS_HOST not set; exiting."
	exit 1
fi

# https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-reference-jdbc-url-format.html
# https://dev.mysql.com/doc/connector-j/8.0/en/connector-j-reference-configuration-properties.html
URL="jdbc:mysql://${RDS_HOST}:3306?sslMode=${SSL_MODE:-VERIFY_CA}&enabledTLSProtocols=TLSv1.2"

set -x

/flyway/flyway -url="$URL" "$@"
