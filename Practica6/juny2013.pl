
% You are flying back from China, and you should write a program to compute how many
% units of each one of six products you should take in your suitcase with capacity 80Kg 
% if you want to maximize the total value.

:- use_module(library(clpfd)).

capacity(80).
weight([1,2,3,5,6,7]).
value([1,4,7,11,14,15]).

main :- bag, nl, halt.


bag :-
    value(V), length(V, Size),
    capacity(C),
    listVars(Size, L),
    L ins 0..C,
    declareConstraints(L, Cost),
    labeling([ff, max(Cost)], L),
    writeSolution(L).

listVars(0, []) :- !.
listVars(N, [_|L1]) :- N1 is N-1, listVars(N1, L1).

declareConstraints(L, Cost) :- 
    weight(W), scalar_product(W, L, #=<, 80),
    value(V), scalar_product(V, L, #=, Cost).

writeProduct([], _) :- nl.
writeProduct([H|T], N) :-
    write('We pick '), write(H), write(' times product '), write(N), nl,
    N1 is N+1, writeProduct(T, N1).

writeSolution(L) :-
    writeProduct(L, 1),
    value(V), weight(W),
    write('Total weight '), dot_product(W, L, Weight), write(Weight), nl,
    write('Total value '), dot_product(V, L, Value), write(Value), nl.

dot_product([], [], 0).
dot_product([X|Xs], [Y|Ys], Res) :-
    dot_product(Xs, Ys, Res1),
    Res is Res1 + X*Y.   
