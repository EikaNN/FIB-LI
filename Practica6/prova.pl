splitAt(0, Rest, [], Rest) :- !.
splitAt(N, [H|T], [H|First], Rest) :- 
	N1 is N-1,
	splitAt(N1, T, First, Rest).

matrixByRows([], _, []) :- !.
matrixByRows(L, NumCols, [FirstN | MatrixByRows]) :- 
	splitAt(NumCols, L, FirstN, Rest),
	matrixByRows(Rest, NumCols, MatrixByRows).

test(N) :- N < 9.

f(L, N) :- sum(L, #=, N).






