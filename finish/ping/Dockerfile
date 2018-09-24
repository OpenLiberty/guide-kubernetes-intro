FROM open-liberty

COPY target/liberty/wlp/usr/servers/defaultServer/bootstrap.properties /config
COPY target/liberty/wlp/usr/servers/defaultServer/server.env /config
COPY src/main/liberty/config/server.xml /config
COPY target/*.war /config/apps/ping.war
