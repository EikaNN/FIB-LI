
% The SEND + MORE = MONEY cryptoarithmetic puzzle is a classic "hello world" 
% for constraint programming. The puzzle is to assign the digits 0 through 9 
% to letters such that they spell out SEND MORE MONEY and when read as 
% base 10 numbers create a true mathematical formula. 
% Leading zeros are not permitted on numbers.

%       S E N D
%     + M O R E
%      ---------
%     M O N E Y

:- use_module(library(clpfd)).

send :-
    L = [S, E, N, D, M, O, R, Y],
    L ins 0..9,
    all_different(L),
    1000*S + 100*E + 10*N + D + 
    1000*M + 100*O + 10*R + E #= 
    10000*M + 1000*O + 100*N + 10*E + Y,
    M #\= 0, S #\= 0,
    labeling([ff], L),
    write(L).

main :- send, nl, halt.    

