myMember(X,[X|_]).
myMember(X,[_|L]) :- myMember(X,L).

a2b([], []).
a2b([a|La], [b|Lb]) :- a2b(La, Lb).