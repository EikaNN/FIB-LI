%increment(X, Y): Y is equal to X plus one
increment(X, Y) :- Y is X+1.

%sum(X,Y,Z): Z is the sum of X and Y
sum(X,Y,Z) :- Z is X+Y.

%addone(L1, L2): L2 is obtained by adding one to each element of L1
addone([], []).
addone([X|T1], [Y|T2]) :- Y is X+1, addone(T1, T2).