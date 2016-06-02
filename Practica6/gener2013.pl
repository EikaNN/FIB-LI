
% John, Paul and Ringo are rich. Here we will count their money in natural numbers 
% that represent millions of Euros. They all have more than zero and at most 10.

% John has at least twice the amount that Ringo has. 
% Paul has at least 3 more than John. 
% Ringo has at least 3.

:- use_module(library(clpfd)).

rich :- 
	L = [_, _, _],
	L ins 1..10,
	declareConstraints(L),
	labeling([ff], L),
	writeSolution(L), nl, fail.

declareConstraints([John,Paul,Ringo]) :-
	John #>= 2*Ringo,
	Paul #>= 3+John,
	Ringo #>= 3.

writeSolution([John,Paul,Ringo]) :-
	write('John has '), write(John), write(' millions of Euros'), nl,
	write('Paul has '), write(Paul), write(' millions of Euros'), nl,
	write('Ringo has '), write(Ringo), write(' millions of Euros'), nl.

main :- rich, nl, halt.
