%%% Ejercicio 2
%prod(L, P): El producto de los elementos de la lista de enteros L es P
prod([], 1).
prod([X|L], P) :-
	prod(L, P1),
	P is X*P1.

%%%% Ejercicio 3
%pescalar(L1, L2, P): El producto escalar de los vectores L1 y L2 es P
pescalar([], [], 0).
pescalar([X|L1], [Y|L2], P) :-
	pescalar(L1, L2, P1),
	P is X*Y+P1.

%%% Ejercicio 4
%interseccion(L1, L2, I): I es la interseccion entre L1 y L2
%						  (L1 y L2 sin elementos repetidos)
interseccion([], _, []).
interseccion([X|L1], L2, [X|I]) :- 
	member(X, L2), !,
	interseccion(L1, L2, I).
interseccion([_|L1], L2, I) :-
	interseccion(L1, L2, I).


%union(L1, L2, U): U es la unión de L1 y L2
%				   (L1 y L2 sin elementos repetidos)
union([], L, L).
union([X|L1], L2, U) :-
	member(X, L2), !,
	union(L1, L2, U).
union([X|L1], L2, [X|U]) :-
	union(L1, L2, U).

%%% Ejercicio 5
%ultimo(X, L): X es el ultimo elemento de L
ultimo(X, L) :- append(_, [X], L), !.

%inverso(L, R): R es el inverso de L
inverso([], []).
inverso([X|L], R) :- inverso(L, R1), append(R1, [X], R).

%%% Ejercicio 6
%fib(N, F): F es el N-ésimo número de Fibonacci
fib(0, 0) :- !.
fib(1, 1) :- !.
fib(N, F) :- F1 is F-1, F2 is F-2, fib(N2, F2), fib(N1, F1), N is N1+N2.



