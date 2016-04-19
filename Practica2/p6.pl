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
card([X|L], [ [X, N1] | Ar]) :-
	card(L, A),
	pert_con_resto([X|N], A, Ar), !,
	N1 is N+1.
card([X|L], [ [X,1] | A]) :-
	card(L, A).
card(L) :- card(L, A), write(A).

%%% Ejercicio 11
%esta_ordenada(L): L está ordenada de menor a mayor
esta_ordenada([]).
esta_ordenada([_]) :- !.
esta_ordenada([X, Y|L]) :- X =< Y, esta_ordenada([Y|L]).

%%% Ejercicio 12
%ordenacionP(L1, L2): L2 es L1 ordenada de menor a mayor,
%				      método utilizado: permutaciones
ordenacionP(L1, L2) :- permutacion(L1, L2), esta_ordenada(L2).

%%% Ejercicio 13
% esta_ordenada: En el caso peor (lista ordenada) se realizan n-1 comparaciones
%				 	=> O(n)
% ordenacion: En el caso peor se prueban todas las posibles permutaciones
% de n elementos. El número de permutaciones es n! por lo que
% se realizarán aproximadamente n! comparaciones.
%			  		=> O(n!)

%%% Ejercicio 14
%ordenacionI(L1, L2): L2 es L1 ordenada de menor a mayor
%					  método utilizado: inserción
%insercion(X, L1, L2): L2 es la lista obtenida al insertar X en su sitio en L1,
%					   que está ordenada de menor a mayor
insercion(X, [], [X]).
insercion(X, [Y|L1], [X, Y|L1]) :- X =< Y.
insercion(X, [Y|L1], [Y|L2]) :- X > Y, insercion(X, L1, L2). 

ordenacionI([], []).
ordenacionI([X|L1], L2) :- ordenacionI(L1, Ord), insercion(X, Ord, L2).

%%% Ejercicio 15
% En el caso peor el algoritmo de inserción puede llegar a hacer un
% número cuadrático de comparaciones. Se produce cuando la lista está
% ordenada de mayor a menor

%%% Ejercicio 16
%ordenacionM(L1, L2): L2 es L1 ordenada de menor a mayor
%					  método utilizado: mergesort
%merge(L1, L2, L3): L3 es la lista obtenida al fusionar L1 y L2
%split(L, L1, L2): L1 y L2 son una partición de L
merge([], L, L) :- !.
merge(L, [], L) :- !.
merge([X|L1], [Y|L2], [X|L3]) :- X =< Y, !, merge(L1, [Y|L2], L3).
merge([X|L1], [Y|L2], [Y|L3]) :- merge([X|L1], L2, L3).

split([], [], []).
split([X], [X], []).
split([X, Y|L], [X|L1], [Y|L2]) :- split(L, L1, L2).

mergesort([], []) :- !.
mergesort([X], [X]) :- !.
mergesort(L, Ord) :-
	split(L, L1, L2),
	mergesort(L1, Ord1),
	mergesort(L2, Ord2),
	merge(Ord1, Ord2, Ord).

ordenacionM(L1, L2) :- mergesort(L1, L2).

%%% Ejercicio 17
%diccionario(A, N): Dado un alfabeto de A símbolos y un natural N,
%					escribe todas las palabras de N símbolos
%diccionario()

nmembers(_, 0, []) :- !.
nmembers(A, N, [S|L]) :-
	pert(S, A),
	N1 is N-1,
	nmembers(A, N1, L).

writeList([]) :- write(' '), !.
writeList([X|L]) :- write(X), writeList(L).

diccionario(A, N) :-
	nmembers(A, N, L),
	writeList(L), fail.

%%% Ejercicio 18
%palindromos(L): Dada una lista de letras L, escribe todas las permutaciones
%			     de sus elementos que sean palíndromos
%es_palindromo(L): Cierto si L es un palíndromo
es_palindromo([]).
es_palindromo([_]) :- !.
es_palindromo([X|L]) :- concat(L1, [X], L), es_palindromo(L1).

palindromos(L) :-
	permutacion(L, P),
	es_palindromo(P),
	write(P), nl, fail.

%%% Ejercicio 19
%suma(L1, L2, S): L3 es la suma de las listas L1 y L2, que son interpretadas
% 				   como un solo dígito
suma([], [], 0, C, C).
suma([X|L1], [Y|L2], S) :-
	S1 is S-X-Y,
	suma(L1, L2, S1),
	S is X+Y+S1. 