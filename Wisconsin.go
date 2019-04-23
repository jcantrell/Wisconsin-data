/*
  This file generates data for the Wisconsin benchmark,
  as described in "The Wisconsin Benchmark: Past, Present, and Future"
  by David J. DeWitt, U of Wisconsin

  the code here is heavily derived from the pseudo-code given in 
  section 2.1.2 of that document
*/
package main

import (
  "os"
  "fmt"
  "strconv"
)

func convert(unique int64) string {
  var tmp [7]byte
  var i,rem int64
  var result = []byte("AAAAAAA")
  i=6
  for (unique > 0) {
    rem = unique % 26
    tmp[i] = byte('A' + rem)
    unique = unique / 26
    i--
  }
  for i=i + 1; i <= 6; i++ {
    result[i] = tmp[i]
  }

  return string(result[:])
}

func data_rand(seed, limit, generator, prime int64) int64 {
  for ok := true; ok; ok = seed > limit {
    seed = (generator * seed) % prime
  }
  return seed
}

func generate_relation (tupCount, generator, prime int64) {
  var string4_values [4]string
  string4_values[0] = "AAAAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  string4_values[1] = "HHHHxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  string4_values[2] = "OOOOxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  string4_values[3] = "VVVVxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

  seed := generator
  for i:=0;int64(i)<tupCount;i++ {
      seed = data_rand(seed,tupCount,generator,prime)
      unique1 := seed - 1
      unique2 := int64(i);
      two  := unique1 % 2
      four := unique1 % 4
      ten  := unique1 % 10
      twenty := unique1 % 20
      onePercent := unique1 % 100
      tenPercent := unique1 % 10
      twentyPercent := unique1 % 5
      fiftyPercent  := unique1 % 2
      unique3        := unique1
      evenOnePercent := onePercent*2
      oddOnePercent  := onePercent*2 + 1
      stringu1 := convert(unique1) + "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      stringu2 := convert(unique2) + "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      string4 := string4_values[i%4]

      fmt.Printf( "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%s,%s,%s\n",
        unique1, unique2, two, four, ten, twenty, onePercent, tenPercent,
        twentyPercent, fiftyPercent, unique3, evenOnePercent, oddOnePercent,
        stringu1, stringu2, string4);
    }
}

func main() {
  argc := len(os.Args[1:])
  if (argc < 1) {
    fmt.Println("Usage: Wisonsin num-tuples")
    os.Exit(1)
  }
  countIn, _ := strconv.Atoi(os.Args[1])
  var tupCount int64 = int64(countIn)
  if      tupCount <= 1000 {generate_relation(tupCount,279,1009)
  } else if tupCount <= 10000 {generate_relation(tupCount,2969,10007)
  } else if tupCount <= 100000 {generate_relation(tupCount,21395,100003)
  } else if tupCount <= 1000000 {generate_relation(tupCount,2107,10000)
  } else if tupCount <= 10000000 {generate_relation(tupCount,211,10000)
  } else if tupCount <= 100000000 {generate_relation(tupCount,21,10000)
  } else { fmt.Println("too many rows requested\n"); os.Exit(0)}
}
