FROM debian:stretch

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests wget gnupg apt-transport-https ca-certificates && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/postgres.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-client-10 && \
    rm -rf /var/apt/lists/*

ADD docker-entrypoint.sh /

ENTRYPOINT /docker-entrypoint.sh

