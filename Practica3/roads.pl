cities([1,2,3,4]).
road(1,2, 10). % road between cities 1 and 2 of 10km
road(1,4, 20).
road(2,3, 25).
road(3,4, 12).

mainroads(K,M):-
	findall( road(X,Y,Z), road(X,Y,Z), AllRoads ),
	subcjto(AllRoads,M),
	cities(C), getCities(M, Cities), allVisited(C,Cities),
	totalLength(M, S), S =< K, !.

%getCities(M,Cities) :- Cities is a list of all cities of M
getCities([],[]).
getCities([ road(X,Y,_) | T], Cities) :-
	getCities(T, Cit),
	append([X,Y], Cit, Cities).

%allVisited(C,M): holds if all C cities appear at least once in M
allVisited(C,M) :- set(M,S), length(S,N), length(C,N).	

%totalLength(L,S): S is the sum of all roads of L
totalLength([], 0).
totalLength([ road(_,_,Z) | T], S) :-
	totalLength(T, Tsum),
	S is Z+Tsum.

%%% Auxiliary functions

%subcjto(L,S): S is a subset of L
subcjto([],[]). 
subcjto([H|T],[H|S]) :- subcjto(T,S).
subcjto([_|T],S) :- subcjto(T,S).

%set(L,S): S is a list where elements from L appear only once
set([],[]).
set([H|T],S) :- set(T,S), member(H,S), !.
set([H|T],[H|S]) :- set(T,S).