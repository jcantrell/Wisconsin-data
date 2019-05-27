#!/bin/bash
TIMEFORMAT=%R

executeQuery() { # queryStr
  echo "executing: $1"
  echo "$1" | ./mysql_connect.sh
}

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
loadTableMysql() {
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

selectQuery() { # from-table, to-table, attribute, lowerValue, upperValue
queryStr="
insert into $2
select * from $1
where $3 between $4 and $5;
"
  trim "$queryStr"
}

# generate a (uniformly distributed) random number 
# between low and high, inclusive
randomInclusive() {
  low="$1"
  high="$2"

  range=32768 # range of numbers given by $RANDOM
  r=-1

  while (( $r < $low || $r > $high )); do 
    r=0
    iterRange=$(($high - $low + 1))
    while (($iterRange > 0)); do
      r=$(($range*$r+$RANDOM))
      iterRange=$(($iterRange - $range))
    done
  done
  echo "$r"
}

query1() { # query 1: source1, source2, numTuples
  source1="$1"
  source2="$2"
  dst="temp1"
  src="$source1"
  numTuples="$3"
  for i in {1..10}; do
    executeQuery "$(createTable "temp1")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $(($numTuples-99)))
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique1" "$rand" "$(($rand+99))")" ) 2>>../data/times/1
    executeQuery "drop table temp1;"
  done
}

query2() { # query 2: source1, source2, numTuples
  source1="$1"
  source2="$2"
  dst="temp2"
  src="$source1"
  numTuples="$3"
  for i in {1..10}; do
    executeQuery "$(createTable "temp2")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $(($numTuples-999)))
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique1" "$rand" "$(($rand+999))")" ) 2>>../data/times/2
    executeQuery "drop table temp2;"
  done
  #selectQuery $1 $2 "unique1" $3 $(($3+999)) 
}

query3() { # query 3: source1, source2, numTuples
  source1="$1"
  source2="$2"
  dst="temp3"
  src="$source1"
  numTuples="$3"
  for i in {1..10}; do
    executeQuery "$(createTable "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $(($numTuples-99)))
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique2" "$rand" "$(($rand+99))")" ) 2>>../data/times/3
    executeQuery "drop table $dst;"
  done
  #selectQuery $1 $2 "unique2" $3 $(($3+99)) 
}

query4() { # 
  source1="$1"
  source2="$2"
  dst="temp4"
  src="$source1"
  numTuples="$3"
  for i in {1..10}; do
    executeQuery "$(createTable "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $(($numTuples-999)))
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique2" "$rand" "$(($rand+999))")" ) 2>>../data/times/4
    executeQuery "drop table $dst;"
  done
  #selectQuery $1 $2 "unique2" $3 $(($3+999)) 
}

query5() { # query 5: source, dest, lowerValue
  source1="$1"
  source2="$2"
  dst="temp5"
  src="$source1"
  numTuples="$3"
  for i in {1..10}; do
    executeQuery "$(createTable "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $(($numTuples-99)))
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique1" "$rand" "$(($rand+99))")" ) 2>>../data/times/5
    executeQuery "drop table $dst;"
  done
  #selectQuery $1 $2 "unique1" $3 $(($3+99))
}
query6() { # query 6: source, dest, lowerValue
  source1="$1"
  source2="$2"
  dst="temp6"
  src="$source1"
  numTuples="$3"
  for i in {1..10}; do
    executeQuery "$(createTable "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $(($numTuples-999)))
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique1" "$rand" "$(($rand+999))")" ) 2>>../data/times/6
    executeQuery "drop table $dst;"
  done
  #selectQuery $1 $2 "unique1" $3 $(($3+999))
}
query7() { # query 7: source1, source2, numTuples
  source1="$1"
  source2="$2"
  src="$source1"
  numTuples="$3"
#queryStr="
#select * from $1
#where unique2 = 2001;
#"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $numTuples)
    qStr="select * from $src where unique2 = $rand;"
    ( time executeQuery "$qStr" ) 2>>../data/times/7
  done
  #trim "$queryStr"
}
query8() { # query 8: source1, source2, numTuples
  source1="$1"
  source2="$2"
  src="$source1"
  numTuples="$3"
#queryStr="
#select * from $1
#where unique2 between $2 and $(($2+99));
#"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $numTuples)
    qStr="select * from $src where unique2 between $rand and $(($rand+99));"
    ( time executeQuery "$qStr" ) 2>>../data/times/8
  done
  #trim "$queryStr"
}
query9() { # query 9: dest
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp9"
  attr="unique1"
#queryStr="
#insert into $1
#select * from tenktup1, tenktup2
#where (tenktup1.unique2 = tenktup2.unique2)
#and (tenktup2.unique2 < 1000); 
#"
#  trim "$queryStr"
  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $numTuples)
qStr="
insert into $dst 
select * from $source1, $source2 
where ($source1.$attr = $source2.$attr) 
and ( $src.$attr < 1000);
"
    ( time executeQuery "$qStr" ) 2>>../data/times/9
    executeQuery "drop table $dst;"
  done
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
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp10"
  attr="unique1"
#queryStr="
#insert into $1
#select * from tenktup1, bprime
#where (tenktup1.unique2 = bprime.unique2);
#"
#  trim "$queryStr"
  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $numTuples)
qStr="
insert into $dst
select * from $src, bprime 
where ($src.$attr = bprime.$attr) 
and ( $src.$attr < 1000);
"
    trim "$queryStr"
    ( time executeQuery "$qStr" ) 2>>../data/times/10
    executeQuery "drop table $dst;"
  done
}
query11() {
  source1="$1"
  source2="$2"
  source3="$3"
  numTuples="$4"
  dst="temp11"
  attr="unique1"
  
  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $numTuples)
    #qStr="insert into $dst select * from $src, bprime where ($src.unique2 = bprime.unique2) and ( $src.unique2 < 1000);"
qStr="
insert into $dst
select * from $source3, $source1, $source2
where ($source3.$attr = $source1.$attr)
and ($source1.$attr = $source2.$attr)
and ($source1.$attr < 1000);
"
#queryStr="
#insert into $1
#select * from onektup, tenktup1, tenktup2
#where (onektup.unique2 = tenktup1.unique2)
#and (tenktup1.unique2 = tenktup2.unique2)
#and (tenktup1.unique2 < 1000);
#"
    trim "$queryStr"

    ( time executeQuery "$qStr" ) 2>>../data/times/11
    executeQuery "drop table $dst;"
  done
}
query12() { # query 9: dest
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp12"
  attr="unique2"
#queryStr="
#insert into $1
#select * from tenktup1, tenktup2
#where (tenktup1.unique2 = tenktup2.unique2)
#and (tenktup2.unique2 < 1000); 
#"
#  trim "$queryStr"
  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $numTuples)
qStr="
insert into $dst 
select * from $source1, $source2 
where ($source1.$attr = $source2.$attr) 
and ( $src.$attr < 1000);
"
    ( time executeQuery "$qStr" ) 2>>../data/times/9
    executeQuery "drop table $dst;"
  done
}
query13() { 
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp13"
  attr="unique2"
#queryStr="
#insert into $1
#select * from tenktup1, bprime
#where (tenktup1.unique2 = bprime.unique2);
#"
#  trim "$queryStr"
  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $numTuples)
qStr="
insert into $dst
select * from $src, bprime 
where ($src.$attr = bprime.$attr);
"
    trim "$queryStr"
    ( time executeQuery "$qStr" ) 2>>../data/times/10
    executeQuery "drop table $dst;"
  done
}
query14() {
  source1="$1"
  source2="$2"
  source3="$3"
  numTuples="$4"
  dst="temp14"
  attr="unique2"
  
  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    rand=$(randomInclusive 1 $numTuples)
    #qStr="insert into $dst select * from $src, bprime where ($src.unique2 = bprime.unique2) and ( $src.unique2 < 1000);"
qStr="
insert into $dst
select * from $source3, $src
where ($source3.$attr = $src.$attr)
and ($src.$attr = $source2.$attr)
and ($src.$attr < 1000);
"
#queryStr="
#insert into $1
#select * from onektup, tenktup1, tenktup2
#where (onektup.unique2 = tenktup1.unique2)
#and (tenktup1.unique2 = tenktup2.unique2)
#and (tenktup1.unique2 < 1000);
#"
    trim "$queryStr"

    ( time executeQuery "$qStr" ) 2>>../data/times/11
    executeQuery "drop table $dst;"
  done
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

createTableSingleInt() {
queryStr="
create table $1
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
select sum(tenktup1.unique3) from tenktup1
group by tenktup1.onePercent;
"
  trim "$queryStr"
}

query26() {
# query 26 & query 29
#queryStr="
#insert into tenktup1 values(10001,74,0, 2,0,10,50,688,
#1950,4950,9950,1,100,
#'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
#'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
#'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
#"
#  trim "$queryStr"
queryStr="
insert into tenktup1 values(74,10001,0, 2,0,10,50,688,
1950,4950,9950,1,100,
'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
"
  trim "$queryStr"
}

query27() {
# query 27 & query 30
#queryStr="
#delete from tenktup1 where unique1=10001;
#"
queryStr="
delete from tenktup1 where unique2=10001;
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
"
  trim "$queryStr"
}

longq() {
  executeQuery "$(createTable "temp2")"
  time executeQuery "$(query2 tenktup1 temp2 98)"
  executeQuery "drop table temp2;"
}

case "$1" in
  1)
    query1 tenktup1 tenktup2 10000
    ;;
  2)
    query2 tenktup1 tenktup2 10000
    ;;
  3)
    query3 tenktup1 tenktup2 10000
    ;;
  4)
    query4 tenktup1 tenktup2 10000
    ;;
  5) 
    query5 tenktup1 tenktup2 10000
    ;;
  6)
    query6 tenktup1 tenktup2 10000
    ;;
  7)
    query7 tenktup1 tenktup2 10000
    ;;
  8)
    query8 tenktup1 tenktup2 10000
    ;;
  9)
    query9 tenktup1 tenktup2 10000
    ;;
  bprime)
    bprime
    ;;
  10)
    query10 tenktup1 tenktup2 10000
    ;;
  11)
    query11 tenktup1 tenktup2 onektup 10000
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
    createTableSingleInt "$2"
    ;;
  21)
    query21 temp21
    ;;
  22)
    query22 temp22
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
  loadMysql)
    loadTableMysql "$2" "$3"
    ;;
  longq)
    longq
    ;;
  *)
    echo "No such query"
    exit 1
esac
