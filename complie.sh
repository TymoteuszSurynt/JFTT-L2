#!/bin/bash

FILE=$1
lex $FILE
cc lex.yy.c -ll
./a.out
