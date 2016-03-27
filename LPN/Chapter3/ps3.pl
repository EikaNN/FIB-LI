byCar(auckland,hamilton).
byCar(hamilton,raglan).
byCar(valmont,saarbruecken).
byCar(valmont,metz).
byTrain(metz,frankfurt).
byTrain(saarbruecken,frankfurt).
byTrain(metz,paris).
byTrain(saarbruecken,paris).
byPlane(frankfurt,bangkok).
byPlane(frankfurt,singapore).
byPlane(paris,losAngeles).
byPlane(bangkok,auckland).
byPlane(losAngeles,auckland).

travel(X, Y, go(X, Y, car)) :- byCar(X, Y).
travel(X, Y, go(X, Y, train)) :- byTrain(X, Y).
travel(X, Y, go(X, Y, plane)) :- byPlane(X, Y).

travel(X, Y, go(X, Z, car, GO)) :-
	byCar(X, Z),
	travel(Z, Y, GO).

travel(X, Y, go(X, Z, train, GO)) :-
	byTrain(X, Z),
	travel(Z, Y, GO).

travel(X, Y, go(X, Z, plane, GO)) :-
	byPlane(X, Z),
	travel(Z, Y, GO).
