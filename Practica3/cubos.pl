camino(E, E, C, C).
camino(EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal):-
	unPaso(EstadoActual, EstSiguiente),
	\+member(EstSiguiente,CaminoHastaAhora),
	camino(EstSiguiente, EstadoFinal, [EstSiguiente|CaminoHastaAhora], CaminoTotal).

nat(0).
nat(N) :- nat(N1), N is N1+1.

solucionOptima:-
	nat(N),
	camino([0,0],[0,4],[[0,0]],C),
	length(C,N),
	write(C).

%estado
% [litros_cubo5, litros_cubo8]

%llenar cubo5
unPaso([_, Y], [5, Y]).
%vaciar cubo5
unPaso([_, Y], [0, Y]).

%llenar cubo8
unPaso([X, _], [X, 8]).
%vaciar cubo8
unPaso([X, _], [X, 0]).

%verter el contenido de cubo5 a cubo8
unPaso([X1, Y1], [X2, Y2]) :-
	X1 > 0,
	Q is min(8-Y1, X1),
	X2 is X1 - Q,
	Y2 is Y1 + Q.

%verter el contenido de cubo8 a cubo5
unPaso([X1, Y1], [X2, Y2]) :-
	Y1 > 0,
	Q is min(5-X1, Y1),
	X2 is X1 + Q,
	Y2 is Y1 - Q.









