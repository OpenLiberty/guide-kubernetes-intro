FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi

COPY --chown=1001:0 src/main/liberty/config /config/
COPY --chown=1001:0 target/guide-kubernetes-intro-system.war /config/apps
RUN configure.sh
