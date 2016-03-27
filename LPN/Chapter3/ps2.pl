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

travel(X, Y, go(X, Y)) :- byCar(X, Y).
travel(X, Y, go(X, Y)) :- byTrain(X, Y).
travel(X, Y, go(X, Y)) :- byPlane(X, Y).

travel(X, Y, go(X, Z, GO)) :-
	byCar(X, Z),
	travel(Z, Y, GO).

travel(X, Y, go(X, Z, GO)) :-
	byTrain(X, Z),
	travel(Z, Y, GO).

travel(X, Y, go(X, Z, GO)) :-
	byPlane(X, Z),
	travel(Z, Y, GO).
