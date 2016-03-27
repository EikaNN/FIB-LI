%myMember(X, L): X is an element of L
myMember(X, L) :- append(_, [X|_], L).

%set(InList,OutList): OutList is a list where elements from InList
%				      appear only once
set([], []).
set([X|L], OutList) :-
	
	