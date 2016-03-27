child(martha,charlotte).
child(charlotte,caroline).
child(caroline,laura).
child(laura,rose).
descend(X,Y) :- child(X,Y).
descend(X,Y) :- 
	descend(Z,Y),
	child(X,Z).