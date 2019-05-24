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
createDouble() { # tableName
queryStr="
create table $1
(
  unique1 integer NOT NULL,
  unique2 integer NOT NULL,
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
  string4   char(52) NOT NULL,
  unique1_2 integer NOT NULL,
  unique2_2 integer NOT NULL,
  two_2     integer NOT NULL,
  four_2    integer NOT NULL,
  ten_2     integer NOT NULL,
  twenty_2  integer NOT NULL,
  onePercent_2 integer NOT NULL,
  tenPercent_2 integer NOT NULL,
  twentyPercent_2  integer NOT NULL,
  fiftyPercent_2 integer NOT NULL,
  unique3_2 integer NOT NULL,
  evenOnePercent_2 integer NOT NULL,
  oddOnePercent_2 integer NOT NULL,
  stringu1_2  char(52) NOT NULL,
  stringu2_2  char(52) NOT NULL,
  string4_2   char(52) NOT NULL
);
"
  trim "$queryStr"
}
createTriple() { # tableName
queryStr="
create table $1
(
  unique1 integer NOT NULL,
  unique2 integer NOT NULL,
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
  string4   char(52) NOT NULL,
  unique1_2 integer NOT NULL,
  unique2_2 integer NOT NULL,
  two_2     integer NOT NULL,
  four_2    integer NOT NULL,
  ten_2     integer NOT NULL,
  twenty_2  integer NOT NULL,
  onePercent_2 integer NOT NULL,
  tenPercent_2 integer NOT NULL,
  twentyPercent_2  integer NOT NULL,
  fiftyPercent_2 integer NOT NULL,
  unique3_2 integer NOT NULL,
  evenOnePercent_2 integer NOT NULL,
  oddOnePercent_2 integer NOT NULL,
  stringu1_2  char(52) NOT NULL,
  stringu2_2  char(52) NOT NULL,
  string4_2   char(52) NOT NULL,
  unique1_3 integer NOT NULL,
  unique2_3 integer NOT NULL,
  two_3     integer NOT NULL,
  four_3    integer NOT NULL,
  ten_3     integer NOT NULL,
  twenty_3  integer NOT NULL,
  onePercent_3 integer NOT NULL,
  tenPercent_3 integer NOT NULL,
  twentyPercent_3  integer NOT NULL,
  fiftyPercent_3 integer NOT NULL,
  unique3_3 integer NOT NULL,
  evenOnePercent_3 integer NOT NULL,
  oddOnePercent_3 integer NOT NULL,
  stringu1_3  char(52) NOT NULL,
  stringu2_3  char(52) NOT NULL,
  string4_3   char(52) NOT NULL
);
"
  trim "$queryStr"
}
loadTable() {
queryStr="
LOAD DATA LOCAL INFILE '$2'
INTO TABLE $1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 0 ROWS;
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

query1() { # query 1: table, lowerValue
queryStr="
insert into $2
select * from $1
where unique2 between $3 and $(($3+99));
"
  trim "$queryStr"
}

query2() { # query 2: source, destination, lowerValue
queryStr="
insert into $2
select * from $1
where unique2 between $3 and $(($3+999));
"
  trim "$queryStr"
}

query5() { # query 5: source, dest, lowerValue
queryStr="
insert into $2
select * from $1
where unique1 between $3 and $(($3+99));
"
  trim "$queryStr"
}
query6() { # query 6: source, dest, lowerValue
queryStr="
insert into $2
select * from $1
where unique1 between $3 and $(($3+999));
"
  trim "$queryStr"
}
query7() { # query 7: source
queryStr="
select * from $1
where unique2 = 2001;
"
  trim "$queryStr"
}
query8() { # query 8: source, lowerValue
queryStr="
select * from $1
where unique2 between $2 and $(($2+99));
"
  trim "$queryStr"
}
query9() { # query 9: dest
queryStr="
insert into $1
select * from tenktup1, tenktup2
where (tenktup1.unique2 = tenktup2.unique2)
and (tenktup2.unique2 < 1000); 
"
  trim "$queryStr"
}
bprime() { 
queryStr="
insert into bprime
select * from tenktup2
where tenktup2.unique2 < 1000;
"
  trim "$queryStr"
}
query10() { 
queryStr="
insert into $1
select * from tenktup1, bprime
where (tenktup1.unique2 = bprime.unique2);
"
  trim "$queryStr"
}
query11() {
queryStr="
insert into $1
select * from onektup, tenktup1, tenktup2
where (onektup.unique2 = tenktup1.unique2)
and (tenktup1.unique2 = tenktup2.unique2)
and (tenktup1.unique2 < 1000);
"
  trim "$queryStr"
}
query15() {
queryStr="
insert into $1
select * from tenktup1, tenktup2
where (tenktup1.unique1 = tenktup2.unique1)
and (tenktup1.unique2 < 1000);
"
  trim "$queryStr"
}
query16() {
queryStr="
insert into $1
select * from tenktup1, bprime
where (tenktup1.unique1 = bprime.unique1);
"
  trim "$queryStr"
}

query17() {
# query 17
queryStr="
insert into $1
select * from onektup, tenktup1, tenktup2
where (onektup.unique1 = tenktup1.unique1)
and (tenktup1.unique1 = tenktup2.unique1)
and (tenktup1.unique1 < 1000);
"
  trim "$queryStr"
}

query18() {
# query 18
queryStr="
insert into $1
select distinct two, four, ten, twenty, onePercent, string4
from tenktup1;
"
  trim "$queryStr"
}

query19maketemp() {
queryStr="
create table $1
(
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
query19() {
# query 19
queryStr="
insert into $1
select distinct two, four, ten, twenty, onePercent,
tenPercent, twentyPercent, fiftyPercent, unique3,
evenOnePercent, oddOnePercent, stringu1, stringu2, string4
from tenktup1;
"
  trim "$queryStr"
}

query20maketemp() {
queryStr="
create table temp20
(
  val integer NOT NULL
);
"
  trim "$queryStr"
}
query20() {
# query 20 & query 23
queryStr="
insert into $1
select min(tenktup1.unique2) from tenktup1;
"
  trim "$queryStr"
}

query21() {
# query 21 & query 24
queryStr="
insert into $1
select min(tenktup1.unique3) from tenktup1
group by tenktup1.onePercent;
"
  trim "$queryStr"
}

query22() {
# query 22 & query 25
queryStr="
insert into $1
select sum (tenktup1.unique3) from tenktup1
group by tenktup1.onePercent;
"
  trim "$queryStr"
}

query26() {
# query 26 & query 29
queryStr="
insert into tenktup1 values(10001,74,0, 2,0,10,50,688,
1950,4950,9950,1,100,
'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
"
  trim "$queryStr"
}

query27() {
# query 27 & query 30
queryStr="
delete from tenktup1 where unique1=10001;
"
  trim "$queryStr"
}

query28() {
# query 28 & query 31
queryStr="
update tenktup1
set unique2 = 10001 where unique2 = 1491;
"
  trim "$queryStr"
}

query32() {
# query 32
queryStr="
update tenktup1
set unique1 = 10001 where unique1 = 1491;
insert into tmp
select * from tenktup1
where unique1 between 792 and 1791;
"
  trim "$queryStr"
}

case "$1" in
  1)
    query1 tenktup1 temp1 17
    ;;
  2)
    query2 tenktup1 temp2 98
    ;;
  5) 
    query5 tenktup1 temp5 100
    ;;
  6)
    query6 tenktup1 temp6 792
    ;;
  7)
    query7 tenktup1
    ;;
  8)
    query8 tenktup1 0
    ;;
  9)
    query9 temp9
    ;;
  bprime)
    bprime
    ;;
  10)
    query10 temp10
    ;;
  11)
    query11 temp11
    ;;
  15)
    query15 temp15
    ;;
  16)
    query16 temp16
    ;;
  17)
    query17 temp17
    ;;
  18)
    echo "create table temp18
(
  two     integer NOT NULL,
  four    integer NOT NULL,
  ten     integer NOT NULL,
  twenty  integer NOT NULL,
  onePercent integer NOT NULL,
  string4   char(52) NOT NULL
);"
    query18 temp18
    echo "drop table temp18;"
    ;;
  19)
    query19 temp19
    ;;
  19temp)
    query19maketemp "$2"
    ;;
  20)
    query20 temp20
    ;;
  20temp)
    query20maketemp "$2"
    ;;
  21)
    query21 temp21
    ;;
  22)
    query22
    ;;
  26)
    query26
    ;;
  27)
    query27
    ;;
  28)
    query28
    ;;
  32)
    query32
    ;;
  clean)
    clean
    ;;
  create)
    createTable "$2"
    ;;
  double)
    createDouble "$2"
    ;;
  triple)
    createTriple "$2"
    ;;
  load)
    loadTable "$2" "$3"
    ;;
  *)
    echo "No such query"
    exit 1
esac
