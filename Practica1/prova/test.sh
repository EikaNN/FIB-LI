#! /bin/bash

# Variables
FILES=../random3SAT-100
RESULTATS=resultats$2.txt
RESUM=resum$2.txt

function usage() {
	echo "Illegal number of arguments"
	echo "usage: $./test.sh sat_executable file_id"
	exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

# Execute all .cnf tests in FILES
for f in $FILES/*.cnf
do
	TEST=$(basename $f)
	echo -n "$TEST" | tee -a $RESULTATS $RESUM
	echo -ne "\t" >> $RESULTATS
	echo -e "$TEST" >> $RESUM
	echo "========================" >> $RESUM
	#echo -n "Time: " >> $RESUM
	echo -n " "
	TIME=$(/usr/bin/time --quiet -f "%e" ./$1 < $f 2>> $RESUM 1>> $RESUM)
	echo $(tac $RESUM | egrep -m 1 . | awk '{ print $NF }' )
	echo $(tac $RESUM | egrep -m 2 . | awk '{ print $NF }' ) >> $RESULTATS
	echo -e "\n" >> $RESUM
done

#Check if our program is correct
DIFF=$(diff $RESULTATS $FILES/resultats.txt) 
if [ "$DIFF" != "" ]; then
    echo "Results are NOT correct! :("
    echo "$DIFF"
else
	echo "Results are correct! :)"
fi
