word(abalone,a,b,a,l,o,n,e).
word(abandon,a,b,a,n,d,o,n).
word(enhance,e,n,h,a,n,c,e).
word(anagram,a,n,a,g,r,a,m).
word(connect,c,o,n,n,e,c,t).
word(elegant,e,l,e,g,a,n,t).

crosswd(V1, V2, V3, H1, H2, H3) :-
	word(V1, _, X11, _, X21, _, X31, _),
	word(V2, _, X12, _, X22, _, X32, _),
	word(V3, _, X13, _, X23, _, X33, _),
	word(H1, _, X11, _, X12, _, X13, _),
	word(H2, _, X21, _, X22, _, X23, _),
	word(H3, _, X31, _, X32, _, X33, _).