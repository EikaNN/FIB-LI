solve(Balls):-
	camino(Balls, [_], Acciones),
	displaySol(Acciones).

camino(E, E, []).
camino(EstadoActual, EstadoFinal, [Accion|Acciones]):-
	unPaso(EstadoActual, EstSiguiente, Accion),
	camino(EstSiguiente, EstadoFinal, Acciones).

displaySol([]).
displaySol([ [X,Y] | L ]) :- 
	write(X), write(' jumps over '), write(Y), nl, displaySol(L).

unPaso(Balls, [ [X3,Y3] | R2 ], [ [X1, Y1], [X2,Y2] ]) :-
	pert_con_resto([X1,Y1], Balls, R1),
	pert_con_resto([X2,Y2], R1, R2),
	jump(X, Y),
	X2 is X1+X, Y2 is Y1+Y,
	X3 is X2+X, Y3 is Y2+Y,
	between(1, 5, X3), between(1, 5, Y3), X3 >= Y3, \+member([X3,Y3], R2).

jump(0, 1).
jump(0, -1).
jump(1, 0).
jump(-1, 0).
jump(1, 1).
jump(-1, -1).

%%% Funciones auxiliares

%concat(L1, L2, L3): L3 es la concatenación de L1 y L2.
concat([], L, L).
concat([X|L1], L2, [X|L3]) :- concat(L1, L2, L3).

%pert_con_resto(X, L, R): Los elementos de R más el elemento X forman la lista L.
pert_con_resto(X, L, R) :- concat(L1, [X|L2], L), concat(L1, L2, R).
