combine1([], [], []).
combine1([X|L1], [Y|L2], [X,Y|L3]) :- combine1(L1, L2, L3).

combine2([], [], []).
combine2([X|L1], [Y|L2], [[X,Y]|L3]) :- combine2(L1, L2, L3).

combine3([], [], []).
combine3([X|L1], [Y|L2], [join(X,Y)|L3]) :- combine3(L1, L2, L3).

mysubset([], _).
mysubset([X|L1], L2) :-
	member(X, L2),
	mysubset(L1, L2).

mysuperset(A, B) :- mysubset(B, A).