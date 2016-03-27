add_3_and_double(X,Y) :- Y is (X+3)*2.

len([],0).
len([_|L],N) :- len(L,X), N is X+1.

accLen([_|T],A,L) :- Anew is A+1, accLen(T,Anew,L).
accLen([],A,A).

leng(List,Length) :- accLen(List,0,Length).

accMax([H|T],A,Max) :-
	H > A,
	accMax(T,H,Max).
accMax([H|T],A,Max) :-
	H =< A,
	accMax(T,A,Max).
accMax([],A,A).

max(List,Max) :-
	List = [H|_],
	accMax(List,H,Max).