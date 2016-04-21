camino(E, E, C, C, _).
camino(EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal, N):-
	unPaso(EstadoActual, EstSiguiente, N),
	\+member(EstSiguiente,CaminoHastaAhora),
	camino(EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal, N).

solucion(N, P, [Fi, Ci], [Ff, Cf]) :-
	camino([Fi,Ci], [Ff,Cf], [[Fi,Ci]], C, N),
	P1 is P+1,
	length(C, P1),
	write(C), !.

%saltar de una posicion a otra
unPaso([F1, C1], [F2, C2], N) :-
	salto(X, Y),
	F2 is F1+X, between(1, N, F2),
	C2 is C1+Y, between(1, N, C2).

salto(1,2).
salto(-1,-2).
salto(2, 1).
salto(-2, -1).
salto(-2, 1).
salto(2, -1).
salto(-1, 2).
salto(1, -2).
