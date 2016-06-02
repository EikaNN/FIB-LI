:- use_module(library(clpfd)).

machines(5).
tasks([1,2,3,4,5,6,7,8,9,10,11,12,13,14]).
duration([8,6,7,5,2,3,8,6,2,6,1,2,6,4]).

main :- schedule, nl, halt.

schedule :-
    tasks(T), length(T, NumRows),
    machines(NumCols),
    NVars is NumRows*NumCols,
    listVars(NVars, L),
    L ins 0..1,
    duration(D), sum_list(D, Max), K in 1..Max,
    matrixByRows(L, NumCols, MatrixByRows),
    transpose(MatrixByRows, MatrixByCols),
    declareConstraints(MatrixByRows, MatrixByCols, K),
    labeling([ff, min(K)], [K|L]),
    writeSolution(MatrixByRows, K).

% listVars(N, L): generate a list L of Prolog vars of size N(their names do not matter)
listVars(0, []) :- !.
listVars(N, [_|L1]) :- N1 is N-1, listVars(N1, L1).

% splitAt(N, L, First, Rest) : First are the first N elements of L and Rest are the rest
splitAt(0, Rest, [], Rest) :- !.
splitAt(N, [H|T], [H|First], Rest) :- 
    N1 is N-1,
    splitAt(N1, T, First, Rest).

% Create a MatrixByRows from list L, we take NumCols elements at each step
% We assume that Numcols divides L
matrixByRows([], _, []) :- !.
matrixByRows(L, NumCols, [FirstN | MatrixByRows]) :- 
    splitAt(NumCols, L, FirstN, Rest),
    matrixByRows(Rest, NumCols, MatrixByRows).

exactlyOne(L) :- sum(L, #=, 1).
atMostK(L, K) :-
    duration(D),
    scalar_product(D, L, #=<, K).

replicate(N, X, L) :-
    length(L, N),
    maplist(=(X), L).   

declareConstraints(MatrixByRows, MatrixByCols, K) :-
    maplist(exactlyOne, MatrixByRows),
    length(MatrixByCols, N),
    replicate(N, K, Ks),
    maplist(atMostK, MatrixByCols, Ks).

indexOf([X|_], X, 1) :- !.
indexOf([_|T], X, N) :-
    indexOf(T, X, N1),
    N is N1+1.

writeTask([], _) :- nl.
writeTask([Row|MatrixByRows], N) :-
    indexOf(Row, 1, M),
    write('Task '), write(N), write(' is executed by machine '), write(M), nl,
    N1 is N+1,
    writeTask(MatrixByRows, N1).

writeSolution(MatrixByRows, K) :-
    writeTask(MatrixByRows, 1),
    write('The total duration is '), write(K), nl.

