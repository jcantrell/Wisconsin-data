#!/bin/bash
go run Wisconsin.go 1000 > ../data/onektuples.csv
go run Wisconsin.go 10000 > ../data/tenktuples.csv
go run Wisconsin.go 100000 > ../data/hundredktuples.csv
#go run Wisconsin.go 1000000 > ../data/onemtuples.csv
#go run Wisconsin.go 10000000 > ../data/tenmtuples.csv
