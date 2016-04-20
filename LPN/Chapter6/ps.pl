%myMember(X,L): X is an element of L
myMember(X,L) :- append(_,[X|_],L).

%set(InList,OutList): OutList is a list where elements from InList
%				      appear only once
set([],[]).
set([X|L],OutList) :- set(L,OutList), member(X,OutList), !.
set([X|L],[X|OutList]) :- set(L,OutList).

%flatten(List,Flat): List flattens to Flat
accFlatten([],L,L).
accFlatten(X,Acc,[X|Acc]) :- X \= [], X \= [_|_].
accFlatten([H|T],Acc,Flat) :-
	accFlatten(T,Acc,NewAcc),
	accFlatten(H,NewAcc,Flat).

flatten(List, Flat) :- accFlatten(List, [], Flat), !.
