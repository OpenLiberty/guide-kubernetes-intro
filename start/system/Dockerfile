FROM icr.io/appcafe/open-liberty:kernel-slim-java25-openj9-ubi-minimal

COPY --chown=1001:0 src/main/liberty/config /config/
RUN features.sh
COPY --chown=1001:0 target/guide-kubernetes-intro-system.war /config/apps
RUN configure.sh
