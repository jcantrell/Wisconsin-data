#!/bin/bash

randomInclusive() {
  low="$1"
  high="$2"

  range=32768
  r=-1
  echo "r: $r low: $low high: $high"

  while (( $r < $low || $r > $high )); do 
    echo "hello"
  done
}

query1() {
  randomInclusive 1 10000
}

query1 tenktup1 tenktup2 10000
