camino(E, E, C, C).
camino(EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal):-
	unPaso(EstadoActual, EstSiguiente),
	\+member(EstSiguiente,CaminoHastaAhora),
	camino(EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal).

solucion(N, P, [Fi, Ci], [Ff, Cf]):-
	tamano(N),
	camino([Fi,Ci], [Ff,Cf], [[Fi,Ci]], C),
	P1 is P+1,
	length(C, P1),
	write(C).

unPaso([F1, C1], [F2, C2]) :-
	tamano(N),
	salto(X, Y),
	F2 is F1+X, between(1, N, F2),
	C2 is C1+Y, between(1, N, C2).

tamano(_).

salto(1,2).
salto(-1,-2).
salto(2, 1).
salto(-2, -1).
salto(-2, 1).
salto(2, -1).
salto(-1, 2).
salto(1, -2).




