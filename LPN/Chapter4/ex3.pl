twice([], []).

twice([X|L1], [X, X|L2]) :- twice(L1, L2).