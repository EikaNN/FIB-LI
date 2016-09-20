file = torn1

$(file): $(file).pl
	swipl -quiet -O -g main --stand_alone=true -o $(file) -c $(file).pl
