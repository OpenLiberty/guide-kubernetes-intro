FROM open-liberty

# Copy over server zip and extract its contents.
COPY target/defaultServer.zip /tmp
RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && unzip /tmp/defaultServer.zip -d /tmp \
    && mv /tmp/wlp/usr/servers/defaultServer/* /config \
    && rm -rf /tmp/wlp /tmp/defaultServer.zip \
    && apt-get remove -y unzip

# Start defaultServer.
CMD ["/opt/ol/wlp/bin/server", "run", "defaultServer"]
