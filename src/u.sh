#!/bin/bash

trim() {
  # Trim empty first and last lines
  echo "$1" | head -n -1 | tail -n +2
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
  echo "randomInclusive called"
  low="$1"
  high="$2"

  range=32768 # range of numbers given by $RANDOM
  r=-1
  echo "r: $r low: $low high: $high"

  while (( $r < $low || $r > $high )); do
    echo "hello"
  done
#  while (( $r < $low || $r > $high )); do 
#    r=0
#    iterRange=$(($high - $low + 1))
#    while (($iterRange > 0)); do
#      r=$(($range*$r+$RANDOM))
#      iterRange=$(($iterRange - $range))
#    done
#  done
#  echo "$r"
}

#query1() { # query 1: source, destination
#queryStr="
#insert into $2
#select * from $1
#where unique2 between $3 and $(($3+99));
#"
#  trim "$queryStr"
#  selectQuery "$1", "$2", "unique1", "$3", $(($3+99)) 
#  src="$1"
#  dst="$2"
#  numTuples=$3
##  for i in {1..10}; do
##    [[ $(($i%2)) = 0 ]] && (src="$1" && dst="$2") || (src="$2" && dst="$1") ;
#    rand=$(randomInclusive 1, $numTuples)
#    echo "i: $i, src: $src, dst: $dst, rand: $rand"
##  done
#}

#query1 tenktup1 tenktup2 10000

#numTuples=10000
#rand=$(randomInclusive 1, $numTuples)

echo "randomInclusive called"
l1=1
l2=10000
#low="$1"
#high="$2"
low="$l1"
high="$l2"

range=32768 # range of numbers given by $RANDOM
r=-1
echo "r: $r low: $low high: $high"

while (( $r < $low || $r > $high )); do
  echo "hello"
done
