pert(X,[X|_]).              % o bien X es el primero, o bien
pert(X,[_|L]):- pert(X,L).  % pertenece a la lista de los demas

concat([],L,L).
concat([X|L1],L2,[X|L3]) :- concat(L1,L2,L3).

