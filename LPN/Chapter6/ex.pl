%doubled(L): L is made of two consecutive blocks of elements 
%            that are exactly the same
doubled(L) :- append(X, X, L).

%palindrome(L): L is a palindrome
palindrome(L) :- reverse(L, L).

%second(X, L): X is the second element of L
second(X, [_, X | _]).

%swap12(List1,List2): List1 is identical to List2, 
%					  except that the first two elements are exchanged
swap12([], []).
swap12([_], [_]).
swap12([X, Y | L], [Y, X | L]).

%final(X, L): X is the last element of L
final(X, [X]).
final(X, [_|L]) :- final(X, L).

%toptail(InList,OutList): If InList has two or more elements, Output is equal
%						  to InList with first and last item deleted
%						  Otherwise return false
toptail(InList, OutList) :- append([_|OutList], [_], InList).

%swapfl(List1,List2): List1 is identical to List2,
%					  except that the first and last elements are exchanged
swapfl([X|L1], [Y|L2]) :-
	append(L, [Y], L1),
	append(L, [X], L2).

%house(C, N, P): In house of color C lives a person of nationality N 
%				 who has a pet P
suffix(S,L) :- append(_,S,L).
sublist(SubL,L) :- suffix(S,L), prefix(SubL,S).

zebra(ZebraOwner) :-
	Street = [_, _, _],
	member(house(red, english, _), Street),
	member(house(_, spanish, jaguar), Street),
	member(house(_, ZebraOwner, zebra), Street),
	sublist([house(_, _, snail), house(_, japonese, _)], Street),
	sublist([house(_, _, snail), house(blue, _, _)], Street),
	!.
