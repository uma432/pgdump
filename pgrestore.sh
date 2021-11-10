#!/bin/sh

# Author: Ulrich Mann

# Usage: change table name in gunzip statement and execute

# Restores a pg_dump transactional, that is, it rolls back all changes on error.
# Database to restore into, already needs to exist. Any indices or constraints of the resources to restore
# may not yet exist in the database.

exit 0

# -w  use password from ~/.pgpass
# --single-transaction consistent transactional execution, completion or rollback
# --set ON_ERROR_STOP=on do not continue execution on error
gunzip -c table1234.dump.gz | psql --set ON_ERROR_STOP=on --single-transaction dbname -h host -p port -U user -w
