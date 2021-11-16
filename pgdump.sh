#!/bin/sh

# Author: Ulrich Mann

while getopts t: flag
do
    case "${flag}" in
        t) tables=${OPTARG};;
    esac
done
echo "Dumping tables: $tables";

if [[ $# -eq 0 || -z "$tables" ]]; then
    echo "Usage: sh pgdump.sh -t _t1,_t2,_t3,..."
    exit 0
fi

backupDir=dumps/
echo "Storing backups in $backupDir"

#exit 0

for i in ${tables//,/ }
do
    echo "processing input table name $i"

    if [[ $i != table* ]]; then
       echo "input does not start 'with table' : $i. skipping entry."
    fi

    # dump table and optionally _diff table, if it exists
    pg_dump dbname -h host -p port -U user -w -f $backupDir$i.dump -t $i -t "$i"_diff
    if [[ -f $backupDir$i.dump ]]; then
        gzip -f $backupDir$i.dump
    fi

done
