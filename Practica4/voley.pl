:-dynamic(varNumber/3).
symbolicOutput(0). % set to 1 to see symbolic output only; 0 otherwise.


% Extend this Prolog source to design a Voleyball League with 16
% teams, named x01 ... x16, with 15 rounds (playing days), where every
% two teams play against each other exactly once (one team at home and
% the other team away), and on each round each team has exactly one match
% (at home or away). Moreover, we say that a team has a "double" on
% day N if it plays at home on rounds N-1 and on round N, or if it
% plays away on rounds N-1 and on round N.
% Additional constraints:
%  1. No team gets more than one double in the whole league
%  2. No doubles on certain rounds
%  3. Canal+ has bought the tv rights for Saturday Night 8pm for all
%     matches among a group of teams (the so-called tvTeams) and wants
%     all matches among these teams on different rounds (i.e., no two
%     of them on the same round).

%%%%%%%%%%%%%%%%%%%%% toy input example:

teams([x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15,x16]). %the team names
noDoubles([2,15]).                  %no doubles on these rounds
tvTeams([x01,x02,x03,x04,x05,x06]). %all matches between these teams on different rounds

%%%%%% Some helpful definitions to make the code cleaner:
team(T):- teams(Ts), member(T,Ts).
matchOfT(T, T-S):- team(S), S\=T.
matchOfT(T, S-T):- team(S), S\=T.
round(R):- between(1,15,R).
tvMatch(S-T):- tvTeams(TV), member(S,TV), member(T,TV), S\=T.

%%%%%%  Variables: It is mandatory to use these variables!
% match-S-T-R    meaning  "on round R there is a match S-T at home of S"
% home-S-R       meaning  "team S plays at home on round R"
% double-S-R     meaning  "team S has a double on round R"


writeClauses:- 
    defineHome,
    eachTExactlyOneMatchPerR,   %each team plays exactly one game per round
    eachTAgainstEachOther.      %each team plays against each other exactly once

defineHome:-
    team(T), round(R), 
    findall(match-T-S-R, matchOfT(T,T-S), Lits),
    expressOr(home-T-R, Lits), fail.
defineHome.

eachTExactlyOneMatchPerR :-
    team(T), round(R),
    findall(match-T-S-R, matchOfT(T,T-S), Lits1),
    findall(match-S-T-R, matchOfT(T,S-T), Lits2),
    append(Lits1, Lits2, Lits),
    exactly(1,Lits), fail.
eachTExactlyOneMatchPerR.

eachTAgainstEachOther :-
    team(T), team(S), S\=T,
    findall(match-T-S-R, matchOfT(T, T-S), Lits1),
    findall(match-S-T-R, matchOfT(T, S-T), Lits2),
    append(Lits1, Lits2, Lits),
    exactly(1,Lits), fail.
eachTAgainstEachOther.

%eachTeamAtMostOneDouble:-
%    team(T), round(R),
%    findall(match-)

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% show the solution. Here M contains the literals that are true in the model:

displaySol(M):- nl, round(R), nl, write(R), write(':  '), member(match-S-T-R, M ), write(S-T), write(' '), fail.
displaySol(M):- nl,nl,write('Tv matches: '), 
		round(R), nl, write(R), write(':  '), member(match-S-T-R, M ), tvMatch(S-T), write(S-T), write(' '), fail.
displaySol(M):- nl,nl,write('Homes: '), team(T),nl, write(T), write(':  '), round(R), writeH(T,R,M), fail.
displaySol(_):- nl.

writeH(T,R,M):- member(home-T-R,M), write('H'),!.
writeH(_,_,_):- write('.'),!.

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
