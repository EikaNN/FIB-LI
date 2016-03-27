%directTrain(X, Y): there is a direct train from X to Y
%travelBetween(X, Y): it is possible to go from X to Y

directTrain(forbach,saarbruecken).
directTrain(freyming,forbach).
directTrain(fahlquemont,stAvold).
directTrain(stAvold,forbach).
directTrain(saarbruecken,dudweiler).
directTrain(metz,fahlquemont).
directTrain(nancy,metz).

travelBetween(X, X) :- !.

travelBetween(X, Y) :-
	directTrain(X, Z),
	travelBetween(Z, Y).

travelBetween(X, Y) :- travelBetween(Y, X), !.