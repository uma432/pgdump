#!/bin/bash

# old machine must be reachable via ssh
oldPgIp=x.x.x.x
# new machine is the machine that the script is executed on
newPgIp=127.0.0.1
tablenames=`ssh -C $oldPgIp "psql -h $oldPgIp -U dbuser -d olddatabase -Aqt -c \"SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE';\""`

cnt=0
for i in ${tablenames//,/ }
do
        echo "processing input table name $i"

        if [[ $i != table*]]; then
                echo "input does not start with 'table' : $i. skipping entry."
                continue
        fi

        ssh -C $oldPgIp "pg_dump -w -h $oldPgIp -U dbuser -t $i olddatabase" | psql -U dbuser -h $newPgIp -d newdatabase

        ((cnt=cnt+1))
done

echo "$cnt"
