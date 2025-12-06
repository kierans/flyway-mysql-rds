FROM flyway/flyway:9.22.3-alpine

# So migrations on RDS can trust RDS
# This isn't sensitive as it's RDS's public cert.
# We just need to put it into a JKS file for Java.
# Password is "changeit"
COPY /opt/rds/rds.jks /etc/ssl/certs/java/

# So Flyway will trust RDS.
ENV JAVA_ARGS="-Djavax.net.ssl.trustStore=/etc/ssl/certs/java/rds.jks -Djavax.net.ssl.trustStorePassword=changeit"

COPY bin/flyway.sh /usr/local/bin/
COPY etc/flyway.conf /flyway/conf/

ENTRYPOINT [ "/usr/local/bin/flyway.sh" ]
