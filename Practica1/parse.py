#! /usr/bin/python3

import sys

resum = sys.argv[1]
id = resum.split('.')[-2][-1]

resum = open(resum, "r")

taula = "taula" + id + ".csv"
taula = open(taula, "w")

ref = open("picoSAT.txt", "r")
ref = ref.readlines()

taula.write("PROBLEM,Solution,Decisions,Propagations,Time(seconds),Propagations/second,mySolution,myDecisions,myPropagations,myTime(seconds),myPropagations/second\n")

i = 0
while True:
	test=resum.readline().rstrip('\n')
	if not test: break
	resum.readline().rstrip('\n')
	dec = resum.readline().split(':')[-1][1:].rstrip('\n')
	prop = resum.readline().split(':')[-1][1:].rstrip('\n')
	sol = resum.readline().rstrip('\n')
	mytime = resum.readline().rstrip('\n')
	ptime = resum.readline().rstrip('\n')
	resum.readline() # read mySAT/picosat
	resum.readline() # read empty line

	pline = ref[i]
	psol = pline.split(',')[1].rstrip('\n')
	pdec = pline.split(',')[2].rstrip('\n')
	pprop = pline.split(',')[3].rstrip('\n')

	print(mytime)

	if float(mytime) == 0: props = ""
	else: props = str(int(float(prop)/float(mytime)))
	if float(ptime) == 0: pprops = ""
	else: pprops = str(int(float(pprop)/float(ptime)))
	c = ','
	taula.write(test + c + psol + c + pdec + c + pprop + c + ptime + c + pprops + \
				c + sol + c + dec + c + prop + c + mytime + c + props + '\n')
	i += 1
