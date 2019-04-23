# Wisonsin data generation

This script generates data according to the Wisconsin benchmark
specification, as described in "The Wisconsin Benchmark: Past, Present, and
Future" by David J. DeWitt. In order to follow the benchmark specification
as closely as possible, I followed the code laid out in that document and
simply ported it to golang.

# Database system
For this project, I will be using mysql on my local computer. mysql was
chosen because it is easy to set up, and I can use it on my local machine,
which is a boon when as internet connection is unreliable.

# Loading data
To load data into mysql, I use the following commands
I use the following sql commands to create a database and a table, and to
load my data into it from a .csv file:

```
create database dbs;
use dbs;
create table tenktup1
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
LOAD DATA LOCAL INFILE 'go_out.csv' 
INTO TABLE table_name
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 0 ROWS;
```

# Lessons learned
I learned how to set up and use a database system on my machine. Even though
I ended up not using GCP BigQuery, I learned how to use it if I need to.

![unique1 and stringu1][selectscreenshot]

[selectscreenshot]: https://github.com/jcantrell/Wisconsin-data/screenshot.png
