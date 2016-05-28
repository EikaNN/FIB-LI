% A matrix which contains zeroes and ones gets "x-rayed" vertically and
% horizontally, giving the total number of ones in each row and column.
% The problem is to reconstruct the contents of the matrix from this
% information. Sample run:
%
%	?- p.
%	    0 0 7 1 6 3 4 5 2 7 0 0
%	 0                         
%	 0                         
%	 8      * * * * * * * *    
%	 2      *             *    
%	 6      *   * * * *   *    
%	 4      *   *     *   *    
%	 5      *   *   * *   *    
%	 3      *   *         *    
%	 7      *   * * * * * *    
%	 0                         
%	 0                         
%	

:- use_module(library(clpfd)).

ejemplo1( [0,0,8,2,6,4,5,3,7,0,0], [0,0,7,1,6,3,4,5,2,7,0,0] ).
ejemplo2( [10,4,8,5,6], [5,3,4,0,5,0,5,2,2,0,1,5,1] ).
ejemplo3( [11,5,4], [3,2,3,1,1,1,1,2,3,2,1] ).


p:-	ejemplo3(RowSums,ColSums),
	length(RowSums,NumRows),
	length(ColSums,NumCols),
	NVars is NumRows*NumCols,
	listVars(NVars,L),  % generate a list of Prolog vars (their names do not matter)
	L ins 0..1,
	matrixByRows(L,NumCols,MatrixByRows),
	transpose(MatrixByRows, MatrixByCols),
	declareConstraints(MatrixByRows, MatrixByCols, RowSums, ColSums),
	labeling([ff], L),
	pretty_print(RowSums,ColSums,MatrixByRows).


pretty_print(_,ColSums,_):- write('     '), member(S,ColSums), writef('%2r ',[S]), fail.
pretty_print(RowSums,_,M):- nl,nth1(N,M,Row), nth1(N,RowSums,S), nl, writef('%3r   ',[S]), member(B,Row), wbit(B), fail.
pretty_print(_,_,_).
wbit(1):- write('*  '), !.
wbit(0):- write('   '), !.

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

% The sum of all elements of L must be equal to N
correctSum(L, N) :- sum(L, #=, N).

% With maplist we apply correctSum to all elements of both MatrixByRows and RowSums lists 
declareConstraints(MatrixByRows, MatrixByCols, RowSums, ColSums) :-
	maplist(correctSum, MatrixByRows, RowSums),
	maplist(correctSum, MatrixByCols, ColSums).

main :- p, nl, halt.