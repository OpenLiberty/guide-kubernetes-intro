FROM open-liberty

COPY --chown=1001:0 target/liberty/wlp/usr/servers/defaultServer/bootstrap.properties /config
COPY --chown=1001:0 target/liberty/wlp/usr/servers/defaultServer/server.env /config
COPY --chown=1001:0 src/main/liberty/config/server.xml /config
COPY --chown=1001:0 target/*.war /config/apps/system.war
