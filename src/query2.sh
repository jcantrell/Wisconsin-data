#!/bin/bash

# query 1: table, lowerValue
queryStr="
create table temp as
select * from "$1"
where unique2 between "$2" and $(($2+999));
"
# Trim empty first and last lines
queryStr=$(echo "$queryStr" | head -n -1 | tail -n +2 )

echo "$queryStr"
