#!/bin/bash

testfunc () {
sudo -u postgres psql -p 5433 <<ENDOFSQLCOMMANDS
source query1.sql
ENDOFSQLCOMMANDS
}

testfunc
