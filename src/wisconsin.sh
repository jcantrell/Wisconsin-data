#!/bin/bash
TIMEFORMAT=%R

generateData() {
  go run Wisconsin.go 1000      > ../data/onektuples.csv
  go run Wisconsin.go 10000     > ../data/tenktuples.csv
  go run Wisconsin.go 100000    > ../data/hundredktuples.csv
  go run Wisconsin.go 1000000   > ../data/onemtuples.csv
  go run Wisconsin.go 10000000  > ../data/tenmtuples.csv
  go run Wisconsin.go 100000000 > ../data/hundredmtuples.csv 
}



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
loadTableMysql() { # tableName, fileName
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
    #echo "drop table if exists $table;"
    executeQuery "drop table if exists $table;"
  done <<-EOF
temp1
temp2
tenktup1
tenktup2
bprime
onektup
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
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique1" "$rand" "$(($rand+99))")" ) 2>>../data/times/"$numTuples"/1
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
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique1" "$rand" "$(($rand+999))")" ) 2>>../data/times/"$numTuples"/2
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
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique2" "$rand" "$(($rand+99))")" ) 2>>../data/times/"$numTuples"/3
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
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique2" "$rand" "$(($rand+999))")" ) 2>>../data/times/"$numTuples"/4
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
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique1" "$rand" "$(($rand+99))")" ) 2>>../data/times/"$numTuples"/5
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
    ( time executeQuery "$(selectQuery "$src" "$dst" "unique1" "$rand" "$(($rand+999))")" ) 2>>../data/times/"$numTuples"/6
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
    ( time executeQuery "$qStr" ) 2>>../data/times/"$numTuples"/7
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
    ( time executeQuery "$qStr" ) 2>>../data/times/"$numTuples"/8
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
    [[ $(($i%2)) = 0 ]] && { 
      src1="$source1" && src2="$source2"; 
    } || { 
      src1="$source2" && src2="$source1"; 
    }
    rand=$(randomInclusive 1 $numTuples)
qStr="
insert into $dst 
select * from $src1, $src2 
where ($src1.$attr = $src2.$attr) 
and ( $src2.$attr < 1000);
"
    ( time executeQuery "$qStr" ) 2>>../data/times/"$numTuples"/9
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
where ($src.$attr = bprime.$attr) ;
"
    trim "$queryStr"
    ( time executeQuery "$qStr" ) 2>>../data/times/"$numTuples"/10
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
    #[[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    [[ $(($i%2)) = 0 ]] && { 
      src1="$source1" && src2="$source2"; 
    } || { 
      src1="$source2" && src2="$source1"; 
    }
 
    rand=$(randomInclusive 1 $numTuples)
    #qStr="insert into $dst select * from $src, bprime where ($src.unique2 = bprime.unique2) and ( $src.unique2 < 1000);"
qStr="
insert into $dst
select * from $src1, $src2, $source3
where ($source3.$attr = $src1.$attr)
and ($src1.$attr = $src2.$attr)
and ($src1.$attr < 1000);
"
#queryStr="
#insert into $1
#select * from onektup, tenktup1, tenktup2
#where (onektup.unique2 = tenktup1.unique2)
#and (tenktup1.unique2 = tenktup2.unique2)
#and (tenktup1.unique2 < 1000);
#"
    trim "$qStr"

    ( time executeQuery "$qStr" ) 2>>../data/times/"$numTuples"/11
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
#    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    [[ $(($i%2)) = 0 ]] && { 
      src1="$source1" && src2="$source2"; 
    } || { 
      src1="$source2" && src2="$source1"; 
    }
 
    rand=$(randomInclusive 1 $numTuples)
qStr="
insert into $dst 
select * from $src1, $src2 
where ($src1.$attr = $src2.$attr) 
and ( $src2.$attr < 1000);
"
    ( time executeQuery "$qStr" ) 2>>../data/times/"$numTumples"/12
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
    ( time executeQuery "$qStr" ) 2>>../data/times/"$numTuples"/13
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
    # [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
    [[ $(($i%2)) = 0 ]] && { 
      src1="$source1" && src2="$source2"; 
    } || { 
      src1="$source2" && src2="$source1"; 
    }
    rand=$(randomInclusive 1 $numTuples)
    #qStr="insert into $dst select * from $src, bprime where ($src.unique2 = bprime.unique2) and ( $src.unique2 < 1000);"
qStr="
insert into $dst
select * from $source3, $src1, $src2
where ($source3.$attr = $src1.$attr)
and ($src1.$attr = $src2.$attr)
and ($src1.$attr < 1000);
"
#queryStr="
#insert into $1
#select * from onektup, tenktup1, tenktup2
#where (onektup.unique2 = tenktup1.unique2)
#and (tenktup1.unique2 = tenktup2.unique2)
#and (tenktup1.unique2 < 1000);
#"
    queryStr="$(trim "$queryStr")"

    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/14
    executeQuery "drop table $dst;"
  done
}
query15() {
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp15"

  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && { 
      src1="$source1" && src2="$source2"; 
    } || { 
      src1="$source2" && src2="$source1"; 
    }
queryStr="
insert into $dst
select * from $src1, $src2
where ($src1.unique1 = $src2.unique1)
and ($src1.unique2 < 1000);
"
#queryStr="
#insert into $1
#select * from tenktup1, tenktup2
#where (tenktup1.unique1 = tenktup2.unique1)
#and (tenktup1.unique2 < 1000);
#"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/15
    executeQuery "drop table $dst;"
  done
}
query16() {
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp16"

  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"

queryStr="
insert into $dst
select * from $src, bprime
where ($src.unique1 = bprime.unique1);
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/16
    executeQuery "drop table $dst;"
  done
}

query17() {
  source1="$1"
  source2="$2"
  source3="$3"
  numTuples="$4"
  dst="temp17"

  for i in {1..4}; do
    executeQuery "$(createDouble "$dst")"
    [[ $(($i%2)) = 0 ]] && { 
      src1="$source1" && src2="$source2"; 
    } || { 
      src1="$source2" && src2="$source1"; 
    }

queryStr="
insert into $dst
select * from $source3, $src1, $src2
where ($source3.unique1 = $src1.unique1)
and ($src1.unique1 = $src2.unique1)
and ($src1.unique1 < 1000);
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/17
    executeQuery "drop table $dst;"
  done
}

query18() {
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp18"
  createStr="create table $dst
(
  two     integer NOT NULL,
  four    integer NOT NULL,
  ten     integer NOT NULL,
  twenty  integer NOT NULL,
  onePercent integer NOT NULL,
  string4   char(52) NOT NULL
);"
  for i in {1..4}; do
    executeQuery "$createStr"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
qStr="
insert into $dst
select distinct two, four, ten, twenty, onePercent, string4
from $src;
"
    qstr="$(trim "$qStr")"
    ( time executeQuery "$qStr" ) 2>>../data/times/"$numTuples"/18
    executeQuery "drop table $dst;"
  done
}

query19() { # query 19
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp19"
createStr="
create table $dst
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
  createStr="$(trim "$createStr")"
  for i in {1..4}; do
    executeQuery "$createStr"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $dst
select distinct two, four, ten, twenty, onePercent,
tenPercent, twentyPercent, fiftyPercent, unique3,
evenOnePercent, oddOnePercent, stringu1, stringu2, string4
from $src;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/19
    executeQuery "drop table $dst;"
  done
}

createTableSingleInt() {
queryStr="create table $1 ( val integer NOT NULL); "
}

query20() {
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp19"
  for i in {1..4}; do
    createStr="create table $dst ( val integer NOT NULL); "
    executeQuery "$createStr"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $dst
select min($src.unique1) from $src;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/20
    executeQuery "drop table $dst;"
  done
}

query21() { # query 21 & query 24
  source1="$1"
  source2="$2"
  numTuples="$3"
  attr="unique1"
  dst="temp"
  for i in {1..4}; do
    createStr="create table $dst ( val integer NOT NULL); "
    executeQuery "$createStr"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $dst
select min($src.$attr) from $src
group by $src.onePercent;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/21
    executeQuery "drop table $dst;"
  done
}

query22() { # query 22 & query 25
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp"
  for i in {1..4}; do
    createStr="create table $dst ( val integer NOT NULL); "
    executeQuery "$createStr"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $dst
select sum($src.unique3) from $src
group by $src.onePercent;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/22
    executeQuery "drop table $dst;"
  done
}
query23() {
  source1="$1"
  source2="$2"
  numTuples="$3"
  dst="temp19"
  for i in {1..4}; do
    createStr="create table $dst ( val integer NOT NULL); "
    executeQuery "$createStr"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $dst
select min($src.unique2) from $src;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/23
    executeQuery "drop table $dst;"
  done
}
query24() { # query 21 & query 2r
  source1="$1"
  source2="$2"
  numTuples="$3"
  attr="unique2"
  dst="temp"
  for i in {1..4}; do
    createStr="create table $dst ( val integer NOT NULL); "
    executeQuery "$createStr"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $dst
select min($src.$attr) from $src
group by $src.onePercent;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/24
    executeQuery "drop table $dst;"
  done
}
query25() { # query 22 & query 25
  source1="$1"
  source2="$2"
  numTuples="$3"
  attr="unique2"
  dst="temp"
  for i in {1..4}; do
    createStr="create table $dst ( val integer NOT NULL); "
    executeQuery "$createStr"
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $dst
select sum($src.$attr) from $src
group by $src.onePercent;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/25
    executeQuery "drop table $dst;"
  done
}
query26() { # query 26 & query 29
  source1="$1"
  source2="$2"
  numTuples="$3"
#queryStr="
#insert into tenktup1 values(10001,74,0, 2,0,10,50,688,
#1950,4950,9950,1,100,
#'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
#'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
#'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
#"
#  trim "$queryStr"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $src values(74,10001,0, 2,0,10,50,688,
1950,4950,9950,1,100,
'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/26
    executeQuery "delete from $src where unique2=10001;"
  done
}

query27() { # query 27 & query 30
  source1="$1"
  source2="$2"
  numTuples="$3"
#queryStr="
#delete from tenktup1 where unique1=10001;
#"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
 queryStr="
insert into $src values(74,$(($numTuples+$i)),0, 2,0,10,50,688,
1950,4950,9950,1,100,
'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
"
    queryStr="$(trim "$queryStr")"
    executeQuery "$queryStr"
    queryStr="delete from $src where unique2=10001;"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/27
  done
}

query28() { # query 28 & query 31
  source1="$1"
  source2="$2"
  numTuples="$3"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
update $src
set unique2 = 10001 where unique2 = 1491;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/28
    executeQuery "delete from $src where unique2=10001;"
  done
}
query29() { # query 26 & query 29
  source1="$1"
  source2="$2"
  numTuples="$3"
#queryStr="
#insert into tenktup1 values(10001,74,0, 2,0,10,50,688,
#1950,4950,9950,1,100,
#'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
#'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
#'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
#"
#  trim "$queryStr"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
insert into $src values(74,10001,0, 2,0,10,50,688,
1950,4950,9950,1,100,
'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/29
    executeQuery "delete from $src where unique2=10001;"
  done
}
query30() { # query 27 & query 30
  source1="$1"
  source2="$2"
  numTuples="$3"
#queryStr="
#delete from tenktup1 where unique1=10001;
#"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
 queryStr="
insert into $src values(74,10001,0, 2,0,10,50,688,
1950,4950,9950,1,100,
'MxxxxxxxxxxxxxxxxxxxxxxxxxGxxxxxxxxxxxxxxxxxxxxxxxxC',
'GxxxxxxxxxxxxxxxxxxxxxxxxxCxxxxxxxxxxxxxxxxxxxxxxxxA',
'OxxxxxxxxxxxxxxxxxxxxxxxxxOxxxxxxxxxxxxxxxxxxxxxxxxO');
"
    queryStr="$(trim "$queryStr")"
    executeQuery "$queryStr"
    queryStr="delete from $src where unique2=10001;"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/30
  done
}
query31() { # query 28 & query 31
  source1="$1"
  source2="$2"
  numTuples="$3"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
update $src
set unique2 = 10001 where unique2 = 1491;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/31
    executeQuery "delete from $src where unique2=10001;"
  done
}
query32() { # query 32
  source1="$1"
  source2="$2"
  numTuples="$3"
  for i in {1..10}; do
    [[ $(($i%2)) = 0 ]] && src="$source1" || src="$source2"
queryStr="
update tenktup1
set unique1 = 10001 where unique1 = 1491;
"
    queryStr="$(trim "$queryStr")"
    ( time executeQuery "$queryStr" ) 2>>../data/times/"$numTuples"/32
    executeQuery "delete from $src where unique2=10001;"
  done
}

longq() {
  executeQuery "$(createTable "temp2")"
  time executeQuery "$(query2 tenktup1 temp2 98)"
  executeQuery "drop table temp2;"
}

doBench() {
  numTuples="$1"
  mkdir "../data/times/$numTuples"
  case $numTuples in
  10000)
    tableName="tenktup"
    ;;
  100000)
    tableName="hundredktup"
    ;;
  1000000)
    tableName="onemtup"
    ;;
  10000000)
    tableName="tenmtup"
    ;;
  100000000)
    tableName="hundredmtup"
    ;;
  *)
    echo "invalid number of tuples"
    ;;
  esac

  executeQuery "$(createTable "${tableName}1")"
  executeQuery "$(createTable "${tableName}2")"
  executeQuery "$(createTable "onektup")"
  executeQuery "$(loadTableMysql "onektup" "../data/onektuples.csv")"
  executeQuery "$(loadTableMysql "${tableName}1" "../data/${tableName}les.csv")"
  executeQuery "$(loadTableMysql "${tableName}2" "../data/${tableName}les.csv")"

  time for i in {1..32}; do 
    ./wisconsin.sh "$i" "$numTuples" > >(tee -a stdout) 2> >(tee -a stderr >&2); 
  done

  clean
}

case "$1" in
  1)
    echo "Begin query$1" | tee >(cat >&2)
    query1 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  2)
    echo "Begin query$1" | tee >(cat >&2)
    query2 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  3)
    echo "Begin query$1" | tee >(cat >&2)
    query3 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  4)
    echo "Begin query$1" | tee >(cat >&2)
    query4 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  5) 
    echo "Begin query$1" | tee >(cat >&2)
    query5 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  6)
    echo "Begin query$1" | tee >(cat >&2)
    query6 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  7)
    echo "Begin query$1" | tee >(cat >&2)
    query7 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  8)
    echo "Begin query$1" | tee >(cat >&2)
    query8 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  9)
    echo "Begin query$1" | tee >(cat >&2)
    query9 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  bprime)
    bprime
    ;;
  10)
    echo "Begin query$1" | tee >(cat >&2)
    query10 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  11)
    echo "Begin query$1" | tee >(cat >&2)
    query11 tenktup1 tenktup2 onektup "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  12)
    echo "Begin query$1" | tee >(cat >&2)
    query12 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  13)
    echo "Begin query12" | tee >(cat >&2)
    query13 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  14)
    echo "Begin query14" | tee >(cat >&2)
    query14 tenktup1 tenktup2 onektup "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  15)
    echo "Begin query15" | tee >(cat >&2)
    query15 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  16)
    echo "Begin query16" | tee >(cat >&2)
    query16 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  17)
    echo "Begin query17" | tee >(cat >&2)
    query17 tenktup17 tenktup2 onektup "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  18)
    echo "Begin query$1" | tee >(cat >&2)
    query18 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  19)
    echo "Begin query$1" | tee >(cat >&2)
    query19 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  19temp)
    query19maketemp "$2"
    ;;
  20)
    echo "Begin query$1" | tee >(cat >&2)
    query20 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  20temp)
    createTableSingleInt "$2"
    ;;
  21)
    echo "Begin query$1" | tee >(cat >&2)
    query21 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  22)
    echo "Begin query$1" | tee >(cat >&2)
    query22 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  23)
    echo "Begin query$1" | tee >(cat >&2)
    query23 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  24)
    echo "Begin query$1" | tee >(cat >&2)
    query24 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  25)
    echo "Begin query$1" | tee >(cat >&2)
    query25 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  26)
    echo "Begin query$1" | tee >(cat >&2)
    query26 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  27)
    echo "Begin query$1" | tee >(cat >&2)
    query27 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  28)
    echo "Begin query$1" | tee >(cat >&2)
    query28 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  29)
    echo "Begin query$1" | tee >(cat >&2)
    query29 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  30)
    echo "Begin query$1" | tee >(cat >&2)
    query30 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  31)
    echo "Begin query$1" | tee >(cat >&2)
    query31 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
    ;;
  32)
    echo "Begin query$1" | tee >(cat >&2)
    query32 tenktup1 tenktup2 "$2"
    echo "end query$1" | tee >(cat >&2)
    echo "" | tee >(cat >&2)
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
  generateData)
    generateData
    ;;
  doBench)
    doBench "$2"
    ;;
  *)
    echo "No such query"
    exit 1
esac
