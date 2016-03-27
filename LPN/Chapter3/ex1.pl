%in(X, Y): Doll X is in doll Y
%inside(X, Y): Doll X is just inside doll Y

inside(irina, natsha).
inside(natsha, olga).
inside(olga, katarina).

in(X, Y) :- inside(X, Y).

in(X, Y) :-
	inside(X, Z),
	in(Z, Y).
