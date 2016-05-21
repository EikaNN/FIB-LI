:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.
% Extend this Prolog source to design a university timetable:
% - Every weekday (5 days) has 5 teaching hours (9:00 - 14:00).
% - Each course has 3 teaching hours per week, distributed in 3 slots of one hour in 3 different days.
% - For each student we know the courses s(he) has to attend. No overlapping can exist among these courses.
% - For each course we know the list of rooms where it can be held. All sessions of a course are always in the same room.
% - Each student has at most 3 hours per day.
% - The goal is to design a schedule that satisfies all previous constraints and minimizes the number of days with some lecture from 13:00 to 14:00.

%%%%%%%%%%%%%%%%%%%%% toy input example:

courses(9).
students(8).
rooms(2).

student(1,[1,3,5,7,9]).
student(2,[2,4,7,8,9]).
student(3,[1,6,7]).
student(4,[2,5,7,8]).
student(5,[3,5,6,9]).
student(6,[1,2,3,7]).
student(7,[2,4,5]).
student(8,[3,6,7,8]).

courseRooms(1,[1,2]).
courseRooms(2,[2]).
courseRooms(3,[1,2]).
courseRooms(4,[1]).
courseRooms(5,[2]).
courseRooms(6,[2]).
courseRooms(7,[1,2]).
courseRooms(8,[1,2]).
courseRooms(9,[2]).

%%%%%% Some helpful definitions to make the code cleaner:
course(C):-  courses(N), between(1,N,C).
student(S):- students(N), between(1,N,S).
room(R):-    rooms(N), between(1,N,R).
day(D):-     between(1,5,D).
hour(H):-    between(1,5,H).

rooms(C, R) :- courseRooms(C, L), member(R, L).
courses(S, C) :- student(S, L), member(C, L).

%%%%%%  Variables: It is mandatory to use these variables!
% courseHour-C-D-H   meaning "course C is given on day D at hour H"
% courseRoom-C-R     meaning "course C is given at room R"
% late-D             meaning "there is some course at 13:00 on day D"

writeClauses:-
    eachCExactly3H,         % each course has 3 teaching hours per week
    eachC3DifferentD,       % each course hour is distributed in 3 different days
    eachCExactly1R,         % each course has exactly one valid room assigned
    eachRAtMost1CPerH,      % each room can host one course at most on same day and hour
    noOverlappingC.			% each student has no overlapping courses in his schedule

eachCExactly3H :-
    course(C),
    findall(courseHour-C-D-H, (day(D), hour(H)), Lits),
    exactly(3, Lits), fail.
eachCExactly3H.

eachC3DifferentD :-
    course(C),
    findall(courseHour-C-D-_, day(D), Lits),
    atMost(1, Lits), fail.
eachC3DifferentD.

eachCExactly1R :-
    course(C),
    findall(courseRoom-C-R, rooms(C, R), Lits),
    exactly(1, Lits), fail.
eachCExactly1R.

eachRAtMost1CPerH :-
	day(D), hour(H), room(R), course(C1), course(C2), C1 \= C2,
	writeClause([\+courseHour-C1-D-H, \+courseHour-C2-D-H, \+courseRoom-C1-R, \+courseRoom-C2-R]),
	fail.
eachRAtMost1CPerH.

noOverlappingC :-
	student(S), day(D), hour(H),
	findall(courseHour-C-D-H, (courses(S, C)), Lits),
	atMost(1, Lits), fail.
noOverlappingC.

%noOverlappingC :-
%	student(S), day(D), hour(H), courses(S, C1), courses(S, C2), C1 \= C2,
%	writeClause([\+courseHour-C1-D-H, \+courseHour-C2-D-H]),
%	fail.
%noOverlappingC.


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% show the solution. Here M contains the literals that are true in the model:


displaySol(_):-nl,nl,write('\t'), day(D), write('\t'), writeDay(D), fail.
displaySol(M):- hour(H), nl, writeSeparator, nl,  writeHour(H), 
    room(R), nl, write('  r'), write(R), write('\t'), day(D), write('\t'), findall(C,(member(courseHour-C-D-H,M), member(courseRoom-C-R,M)), L), writeSlot(L), fail.
displaySol(_):-nl, nl, nl, nl,write('\t'), day(D), write('\t'), writeDay(D), fail.
displaySol(M):- student(S), nl, writeSeparator, nl, write('Student '), write(S), write(':'), student(S,Courses), 
   hour(H), nl,  writeHour(H), write('\t'), day(D), write('\t'), findall(courseHour-C-D-H,(member(C,Courses),member(courseHour-C-D-H,M)),L),  writeSlot(L,M), fail.
displaySol(_).

writeSeparator:-between(1,53,_), write('-'), fail.
writeSeparator.

writeSlot([],_):-write('X'),!.
writeSlot(L,M):- member(courseHour-C-_-_,L), write('c'), write(C), member(courseRoom-C-R,M), write('-r'), write(R). 

writeSlot([]):-write('X'),!.
writeSlot(L):- member(X,L), write('c'), write(X).

writeDay(D):-nth1(D,['Mon','Tue','Wed','Thu','Fri'],W), write(W).
writeHour(H):- nth1(H,[' 9:00','10:00','11:00','12:00','13:00'],W), write(W).

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits ):- member(Lit,Lits), negate(Lit,NLit), writeClause([ NLit, Var ]), fail.
expressOr( Var, Lits ):- negate(Var,NVar), writeClause([ NVar | Lits ]),!.


%%%%%% Cardinality constraints on arbitrary sets of literals Lits:

exactly(K,Lits):- atLeast(K,Lits), atMost(K,Lits),!.

atMost(K,Lits):-   % l1+...+ln <= k:  in all subsets of size k+1, at least one is false:
    negateAll(Lits,NLits), 
    K1 is K+1,    subsetOfSize(K1,NLits,Clause), writeClause(Clause),fail.
atMost(_,_).

atLeast(K,Lits):-  % l1+...+ln >= k: in all subsets of size n-k+1, at least one is true:
    length(Lits,N),
    K1 is N-K+1,  subsetOfSize(K1, Lits,Clause), writeClause(Clause),fail.
atLeast(_,_).

negateAll( [], [] ).
negateAll( [Lit|Lits], [NLit|NLits] ):- negate(Lit,NLit), negateAll( Lits, NLits ),!.

negate(\+Lit,  Lit):-!.
negate(  Lit,\+Lit):-!.

subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).


%%%%%% main:

main:-  symbolicOutput(1), !, writeClauses, halt.   % print the clauses in symbolic form and halt
main:-  initClauseGeneration,
        tell(clauses), writeClauses, told,          % generate the (numeric) SAT clauses and call the solver
    tell(header),  writeHeader,  told,
    numVars(N), numClauses(C),
    write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
    shell('cat header clauses > infile.cnf',_),
    write('Calling solver....'), nl, 
    shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
    treatResult(Result),!.

treatResult(20):- write('Unsatisfiable'), nl, halt.
treatResult(10):- write('Solution found: '), nl, see(model), symbolicModel(M), seen, displaySol(M), nl,nl,halt.

initClauseGeneration:-  %initialize all info about variables and clauses:
    retractall(numClauses(   _)), 
    retractall(numVars(      _)), 
    retractall(varNumber(_,_,_)),
    assert(numClauses( 0 )), 
    assert(numVars(    0 )),     !.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w( Lit ):- symbolicOutput(1), write(Lit), write(' '),!.
w(\+Var):- var2num(Var,N), write(-), write(N), write(' '),!.
w(  Var):- var2num(Var,N),           write(N), write(' '),!.


% given the symbolic variable V, find its variable number N in the SAT solver:
var2num(V,N):- hash_term(V,Key), existsOrCreate(V,Key,N),!.
existsOrCreate(V,Key,N):- varNumber(Key,V,N),!.                            % V already existed with num N
existsOrCreate(V,Key,N):- newVarNumber(N), assert(varNumber(Key,V,N)), !.  % otherwise, introduce new N for V

writeHeader:- numVars(N),numClauses(C), write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-     retract( numClauses(N0) ), N is N0+1, assert( numClauses(N) ),!.
newVarNumber(N):- retract( numVars(   N0) ), N is N0+1, assert(    numVars(N) ),!.
 
% Getting the symbolic model M from the output file:
symbolicModel(M):- get_code(Char), readWord(Char,W), symbolicModel(M1), addIfPositiveInt(W,M1,M),!.
symbolicModel([]).
addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.
addIfPositiveInt(_,L,L).
readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c
readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
%========================================================================================
