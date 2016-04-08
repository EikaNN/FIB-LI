%%% Funciones auxiliares

%pert(X, L): El elemento X pertenece a la lista L.
pert(X, [X|_]).
pert(X, [_|L]) :- pert(X, L).

%concat(L1, L2, L3): L3 es la concatenación de L1 y L2.
concat([], L, L).
concat([X|L1], L2, [X|L3]) :- concat(L1, L2, L3).

%pert_con_resto(X, L, R): Los elementos de R más el elemento X forman la lista L.
pert_con_resto(X, L, R) :- concat(L1, [X|L2], L), concat(L1, L2, R).

%permutacion(L, P): P es una permutación de L
permutacion([], []).
permutacion(L, [X|P]) :- pert_con_resto(X, L, R), permutacion(R, P).

%long(L, N): La longitud de L es N.
long([], 0).
long([_|L], N) :- long(L, N1), N is N1+1.


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
	pert(X, L2), !,
	interseccion(L1, L2, I).
interseccion([_|L1], L2, I) :-
	interseccion(L1, L2, I).


%union(L1, L2, U): U es la unión de L1 y L2
%				   (L1 y L2 sin elementos repetidos)
union([], L, L).
union([X|L1], L2, U) :-
	pert(X, L2), !,
	union(L1, L2, U).
union([X|L1], L2, [X|U]) :-
	union(L1, L2, U).

%%% Ejercicio 5
%ultimo(X, L): X es el ultimo elemento de L
ultimo(X, L) :- concat(_, [X], L), !.

%inverso(L, R): R es el inverso de L
inverso([], []).
inverso([X|L], R) :- inverso(L, R1), concat(R1, [X], R).

%%% Ejercicio 6
%fib(N, F): F es el N-ésimo número de Fibonacci
fib(0, 0) :- !.
fib(1, 1) :- !.
fib(N, F) :-
	N1 is N-1,
	N2 is N-2,
	fib(N2, F2),
	fib(N1, F1),
	F is F1+F2.

%%% Ejercicio 7
%dados(P, N, L): L es una manera de sumar P puntos lanzando N dados
dados(0, 0, []).
dados(P, N, [X|L]) :-
	N > 0,
	pert(X, [1,2,3,4,5,6]),
	N1 is N-1,
	P1 is P-X,
	dados(P1, N1, L).

%%% Ejercicio 8
%suma_demas(L): Cierto si existe un elemento de L que es igual a 
%               la suma de los demas
%suma(L, S): La suma de todos los elementos de L es S
suma([], 0).
suma([X|L], S) :- suma(L, S1), S is S1+X.
suma_demas(L) :-
	concat(L1, [X|L2], L),
	suma(L1, S1),
	suma(L2, S2),
	X is S1 + S2, !.

%%% Ejercicio 9
%suma_ants:(L): Cierto si existe un elemento de L que es igual
%			    a la suma de los elementos anteriores a él
suma_ants(L) :-
	concat(L1, [X|_], L),
	suma(L1, X), !.

%%% Ejercicio 10
%card(L): Escribe el número de apariciones de cada elemento de L.
%		  El orden es el mismo en el que aparacen el L.
card([], []).
card([X|L1], [ [X, N] | L2]) :-
	card(L1, )
card([X|L1], [ [X,1] | L2) :-
	card(L1, L2).
card(L) :- card(L, A), write(A).













