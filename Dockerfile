FROM eclipse-temurin:17

COPY entrypoint.sh /entrypoint.sh

# Install packages.
RUN apt-get update && \
    apt-get install -y jq && \
    apt-get install -y git

ENTRYPOINT ["/entrypoint.sh"]