numNutrients(8).
product(milk,[2,4,6]).
product(meat,[1,8]).
product(eggs,[3,4,5,6]).
product(pear,[7,1,2]).
product(cake,[1,5,4,2]).

shopping(K,L) :-
	getProducts(AllProducts), 
	subcjto(AllProducts,Products),
	length(Products,LenProducts), LenProducts =< K,
	getNutrients(Products,Nutrients),
	numNutrients(N), allNutrients(N, Nutrients),
	displaySol(Products).

getProducts([product(X,Y)|AllProducts]) :-
	product(X,Y),
	\+member(product(X,Y),AllProducts).

%getNutrients(L,N) :- N is a list of all nutrients of each product of L
getNutrients([],[]).
getNutrients([product(_,L) | T], N) :-
	getNutrients(T, Nutrients),
	append(L, Nutrients, N).

%allNutrients(N,L): holds if all N nutrients appear at least once in L
allNutrients(N,L) :- set(L,S), length(S,N).

displaySol([]).
displaySol([product(P,L) | T]) :- write(P), write(' '), write(L), nl, displaySol(T).	

%%% Auxiliary functions

%subcjto(L,S): S is a subset of L
subcjto([],[]). 
subcjto([H|T],[H|S]):-subcjto(T,S).
subcjto([_|T],S):-subcjto(T,S).

%set(L,S): S is a list where elements from L appear only once
set([],[]).
set([H|T],S) :- set(T,S), member(H,S), !.
set([H|T],[H|S]) :- set(T,S).