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

echo "########################################"
echo "#########TEST IS GOING TO START#########"
echo "########################################"
echo -e "\nTestID\t        MySat\tPico\tTimesPico\n"

# Execute all .cnf tests in FILES
for f in $FILES/*.cnf
do
	TEST=$(basename $f)
	echo -n "$TEST" | tee -a $RESULTATS $RESUM
	echo -ne "\t" >> $RESULTATS
	echo -e "\n========================" >> $RESUM

	# our solver
	/usr/bin/time --quiet -f "%e" ./$1 < $f 2>> $RESUM 1>> $RESUM
	OUR_TIME=$(tac $RESUM | egrep -m 1 . | awk '{ print $NF }' )
	echo -ne "\t$OUR_TIME"
	echo $(tac $RESUM | egrep -m 2 . | awk '{ print $NF }' | sed -n 2p) >> $RESULTATS

	# picosat
	/usr/bin/time --quiet -f "%e" picosat < $f 2>> $RESUM 1>>/dev/null
	PICO_TIME=$(tac $RESUM | egrep -m 1 . | awk '{ print $NF }' )
	echo -ne "\t$PICO_TIME"
	if [ "$PICO_TIME" = "0.00" ]; then
		echo "INF" >> $RESUM
		echo -e "\tINF"
	else
		echo $(echo "$OUR_TIME/$PICO_TIME" | bc -l) >> $RESUM
		echo -ne "\t"
		echo $(echo "$OUR_TIME/$PICO_TIME" | bc -l)
	fi
	echo -ne "\n" >> $RESUM
done

#Check if our program is correct
DIFF=$(diff $RESULTATS $FILES/resultats.txt) 
if [ "$DIFF" != "" ]; then
    echo "Results are NOT correct! :("
    echo "$DIFF"
else
	echo "Results are correct! :)"
fi

echo "########################################"
echo "#############TEST HAS ENDED#############"
echo "########################################"