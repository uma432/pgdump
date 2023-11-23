#!/bin/sh

########
# Author: Ulrich u.mann@narimo.de
# Use at your own responsibility.
########

DOCKER_SERVICE=$(./service-name.sh)
echo $DOCKER_SERVICE

# local machine
oldPgIp=127.0.0.1
oldPgUser=postgres
oldPgDb=db
oldPgPort=5432

# remote machine is the machine where the table should be copied to
newPgIp=127.0.0.1
newLocalPgIP=127.0.0.1
newPgUser=postgres
newPgDb=db_new
newPgPort=5432

pgschema=public
tableName=mytable

DOCKER_SERVICE_REMOTE=$(./db-service-name-remote.sh)
echo $DOCKER_SERVICE_REMOTE 

CONNECTION_URI_OLD=postgresql://$oldPgUser:$passwd@$oldPgIp:$oldPgPort/$oldPgDb
CONNECTION_URI_NEW=postgresql://$newPgUser:$passwd@$newLocalPgIp:$newPgPort/$newPgDb

tableExistsSql="SELECT table_name FROM information_schema.tables WHERE table_schema='$pgschema' AND table_type='BASE TABLE' AND table_name='$tableName'";

checkedTable=`docker exec -i $DOCKER_SERVICE psql --dbname "$CONNECTION_URI_OLD" -Aqt -c "$tableExistsSql"`

echo 'hello '$checkedTable

if [ -z "$checkedTable" ]; then
        echo "Table $tableName does not exist in original database. Please correct input."
else
        echo "Table $tableName exists in original database, proceeding with copy...."
        docker exec -i $DOCKER_SERVICE pg_dump -t $checkedTable "$CONNECTION_URI_OLD" | ssh -C $newPgIp "docker exec -i $DOCKER_SERVICE_REMOTE psql \"$CONNECTION_URI_NEW\""
fi
