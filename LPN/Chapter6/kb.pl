%myAppend(L1, L2, L3): L3 is the result of concatenating L1 and L2
myAppend([],L,L).
myAppend([H|T],L2,[H|L3]) :- myAppend(T,L2,L3).

%myPrefix(P, L): P is a prefix of L
myPrefix(P,L) :- myAppend(P,_,L).

%mySuffix(S, L): S is a suffix of L
mySuffix(S,L) :- myAppend(_,S,L).

%mySublist(SubL, L): SubL is a sublist of L
mySublist(SubL,L) :- mySuffix(S,L),myPrefix(SubL,S).

%naiverev(L, R): R is the reverse of L
naiverev([],[]).
naiverev([H|T],R) :- naiverev(T,RevT),myAppend(RevT,[H],R).

%rev(L, R): R is the reverse of L
accRev([H|T],A,R) :- accRev(T,[H|A],R).
accRev([],A,A).
rev(L,R) :- accRev(L,[],R).