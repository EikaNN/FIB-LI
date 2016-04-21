numNutrients(8).
product(milk,[2,4,6]).
product(meat,[1,8]).
product(eggs,[3,4,5,6]).
product(pear,[7,1,2]).
product(cake,[1,5,4,2]).

shopping(K,L) :-
	findall((X,Y),product(X,Y),AllProducts),
	subcjto(AllProducts,L),
	length(L,LenL), LenL =< K,
	getNutrients(L,Nutr),
	numNutrients(N), allNutrients(N, Nutr).

%getNutrients(L,N) :- N is a list of all nutrients of each product of L
getNutrients([],[]).
getNutrients([ (_,L) | T], N) :-
	getNutrients(T, Nutrients),
	append(L, Nutrients, N).

%allNutrients(N,L): holds if all N nutrients appear at least once in L
allNutrients(N,L) :- set(L,S), length(S,N).

%displaySol([]).
%displaySol([(P,L) | T]) :- write(P), write(' '), write(L), nl, displaySol(T).	

%%% Auxiliary functions

%subcjto(L,S): S is a subset of L
subcjto([],[]). 
subcjto([H|T],[H|S]):-subcjto(T,S).
subcjto([_|T],S):-subcjto(T,S).

%set(L,S): S is a list where elements from L appear only once
set([],[]).
set([H|T],S) :- set(T,S), member(H,S), !.
set([H|T],[H|S]) :- set(T,S).