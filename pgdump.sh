#!/bin/sh

# Author: Ulrich Mann

tables=(
table1
table2
)

for i in "${tables[@]}"
do
    echo "processing input table name $i"

    if [[ $i != table* ]]; then
       echo "input does not start 'with table' : $i. skipping entry."
    fi

    # dump table and optionally _diff table, if it exists
    pg_dump dbname -h host -p port -U user -w -f $i.dump -t $i -t "$i"_diff
    if [[ -f $i.dump ]]; then
        gzip -f $i.dump
    fi

done
