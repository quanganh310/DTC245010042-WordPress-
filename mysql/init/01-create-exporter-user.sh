#!/bin/bash
set -e

case "${MYSQL_EXPORTER_USER}" in
  *[!a-zA-Z0-9_]*)
    echo "MYSQL_EXPORTER_USER may contain only letters, numbers, and underscores." >&2
    exit 1
    ;;
esac

case "${MYSQL_EXPORTER_PASSWORD}" in
  *[!a-zA-Z0-9_-]*)
    echo "MYSQL_EXPORTER_PASSWORD may contain only letters, numbers, underscores, and hyphens." >&2
    exit 1
    ;;
esac

mysql --protocol=socket -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
CREATE USER IF NOT EXISTS '${MYSQL_EXPORTER_USER}'@'%' IDENTIFIED BY '${MYSQL_EXPORTER_PASSWORD}' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO '${MYSQL_EXPORTER_USER}'@'%';
SQL
