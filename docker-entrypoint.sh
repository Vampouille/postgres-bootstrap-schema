#!/bin/bash

set -x
# Store password
echo "$DB_HOSTNAME:$DB_PORT:$DB_NAME:$DB_USERNAME:$DB_PASSWORD" > ~/.pgpass
chmod 0600 ~/.pgpass

# Wait for DB to be ready
while true; do
  echo -n "Trying to connect to $DB_HOSTNAME..."
  pg_isready -q --host=$DB_HOSTNAME --port=$DB_PORT --dbname=$DB_NAME --username=$DB_USERNAME --timeout=10
  if [ $? -eq 0 ]; then
    echo "OK"
    break
  else
    echo "FAILED"
  fi
  sleep 1
done

# Check if schema already exists
psql -w --host $DB_HOSTNAME --port=$DB_PORT --username=$DB_USERNAME -c "\dn" -q --tuples-only $DB_NAME | grep $DB_SCHEMA > /dev/null
if [ $? -ne 0 ]; then
  # Schema does not exists, bootstrap DB
  wget --quiet -O - $DB_BOOTSTRAP_URL | psql -w --host $DB_HOSTNAME --port=$DB_PORT --username=$DB_USERNAME $DB_NAME
  echo "Schema $DB_SCHEMA created"
else
  echo "Schema $DB_SCHEMA already exists"
fi

