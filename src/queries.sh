#!/bin/bash

trim() {
  # Trim empty first and last lines
  echo "$1" | head -n -1 | tail -n +2
}

createTable() { # createTable tableName
queryStr="
create table $1
(
  unique1 integer NOT NULL,
  unique2 integer NOT NULL PRIMARY KEY,
  two     integer NOT NULL,
  four    integer NOT NULL,
  ten     integer NOT NULL,
  twenty  integer NOT NULL,
  onePercent integer NOT NULL,
  tenPercent integer NOT NULL,
  twentyPercent  integer NOT NULL,
  fiftyPercent integer NOT NULL,
  unique3 integer NOT NULL,
  evenOnePercent integer NOT NULL,
  oddOnePercent integer NOT NULL,
  stringu1  char(52) NOT NULL,
  stringu2  char(52) NOT NULL,
  string4   char(52) NOT NULL
);
"
  trim "$queryStr"
}

query1() { # query 1: table, lowerValue
queryStr="
create table $2 as
select * from $1
where unique2 between $3 and $(($3+99));
"
  trim "$queryStr"
}

query2() { # query 2: source, destination, lowerValue
queryStr="
create table $2 as
select * from "$1"
where unique2 between "$3" and $(($3+999));
"
  trim "$queryStr"
}

clean() {
  while read table; do
    echo "drop table if exists $table;"
  done <<-EOF
temp1
temp2
EOF
}

case "$1" in
  1)
    query1 tenktup1 temp1 17
    ;;
  2)
    query2 tenktup1 temp2 98
    ;;
  clean)
    clean
    ;;
  create)
    createTable "$1"
    ;;
  *)
    echo "No such query"
    exit 1
esac
