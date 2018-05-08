FROM open-liberty

# Copy over server zip and extract its contents.
COPY target/defaultServer.zip /tmp
RUN unzip /tmp/defaultServer.zip -d /tmp \
    && mv /tmp/wlp/usr/servers/defaultServer/* /config \
    && rm -rf /tmp/wlp /tmp/defaultServer.zip

# Start defaultServer.
CMD ["/opt/ol/wlp/bin/server", "run", "defaultServer"]
