%accMin(List, Acc, Min): Min is the minimum element of List
accMin([H|T],A,Min) :-
	H < A,
	accMin(T,H,Min).
accMin([H|T],A,Min) :-
	H >= A,
	accMin(T,A,Min).
accMin([],A,A).

%scalarMult(N, Vector, Res): Res is the scalar multiplication of N by Vector
scalarMult(_, [], []).
scalarMult(N, [X|T1], [Y|T2]) :-
	Y is N*X,
	scalarMult(N, T1, T2).

%dotProduct(V1, V2, Res): Res is the dot product between V1 and V2
dotProduct([], [], 0).
dotProduct([X|T1], [Y|T2], R) :-
	dotProduct(T1, T2, R1),
	R is R1+X*Y.