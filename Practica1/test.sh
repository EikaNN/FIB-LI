#! /bin/bash

FILES=../random3SAT/*

for f in $FILES
do
	TEST=$(basename $f)
	echo "$TEST" >> resultats$1.txt
	echo "./SAT-alumnes.exe < $f >> resultats$1.txt"
done