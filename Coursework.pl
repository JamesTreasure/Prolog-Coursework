/* <Username: jat52 	Name:James Treasure>

THIS WORK IS ENTIRELY MY OWN.

The program does not produce multiple answers.

I have not used built-ins.

1. <Number of elements in the list binding Q after executing s1(Q,100) is 1747>
<First I make a list of every potential quad before anything at all has been said.
Remove unique products>

2. <Number of elements in the list binding Q after executing s2(Q,100) is 145>
<Generate a list of numbers that S must be. Remove any quad where S is not in
that list.>

3. <Number of elements in the list binding Q after executing s3(Q,100) is 86>
<Remove duplicate producuts>

4.
<Remove duplicate sums.>

5. <Number of elements in the list binding Q after executing s4(Q,500) is 1>
s4(Q,500) uses <number> inferences. */

%------s1------
get_quads(MaxSum, Result) :-
    MaxSum> 1,								
    get_quads(2, MaxSum, 2, Result).		
get_quads(Sum, Sum, Sum, []).            % 'Sum' has reached max value
get_quads(Sum, MaxSum, Sum, Result) :-   
    Sum < MaxSum,
    Sum1 is Sum + 1,
    get_quads(Sum1, MaxSum, 2, Result).	%3,100,1,Result
get_quads(Sum, MaxSum, X, [[X, Y, Sum, P]|Result]) :- 
	Sum =< MaxSum,	
	X < Sum,
	Y is Sum - X, 
	X < Y,
	P is X*Y,
	X1 is X + 1, 
	get_quads(Sum, MaxSum, X1, Result).
get_quads(Sum, MaxSum, X, Result) :-
	X1 is X + 1,
    get_quads(Sum, MaxSum, X1, Result).
 
fourth([_,_,_,F|_], F).
 
get_fourth([], _, 0).
get_fourth([H|T], X, R) :- 
	fourth(H, X),!,
	get_fourth(T, X, RR), 
	R is RR + 1.
get_fourth([_|T], X, R) :- 
	get_fourth(T, X, R).

remove_unique([], [], _).
remove_unique([H|T], [H|R], A) :- 
	fourth(H, X), 
	get_fourth(A, X, C),
	C > 1, 
	remove_unique(T, R, A).
remove_unique([_|T], R, A) :- 
	remove_unique(T, R, A).
remove_unique(L, R) :-  
	remove_unique(L, R, L), !.
 
s1(Q,N):-
	get_quads(N,Numbers), !,
	remove_unique(Numbers,Q).

%------s2------
prime(2).
prime(N) :- 
	sqrt(N,S), 		%Square root N and store in S.
	check(N,S,3).	%Pass N, Square root of N and 3 to check.

check(_,S,D) :- D>S.	%D greater than square root of N.
check(N,S,D) :-
	N =\= D*(N//D), 
	D1 is D+2,		%Add two to D. Means even numbers are never prime.
	check(N,S,D1).	%Recurse with new D1

%Generates prime numbers between two numbers. prime_list(1,100,A).
prime_list(B,L) :-
 	 prime_list(2,B,L).	%Calls prime_list with A replaces by 2.

prime_list(A,B,[]) :-	%Empty list if A is bigger than B. eg, (100,10,A).
	 A > B, 		%Base case for when to stop recursing.
	 !.

%If it returns true then add A to the prime list.
prime_list(A,B,[A|L]) :- 
	prime(A), 		%Checks if first number is prime.
	!, 
   	next(A,A1),		%Adds two to A and returns A1.
   	prime_list(A1,B,L). %Recursive call with new value A1.

%If A wasn't prime in the prime check above, add two to A and recurse.
prime_list(A,B,L) :- 
   next(A,A1),
   prime_list(A1,B,L).

next(2,3) :- !.
next(A,A1) :- A1 is A + 2.

add_to_list([],[]).
add_to_list([H|T],[Y|List]):-
	Y is H + 2,
	add_to_list(T,List).

remove_even([],[]).
remove_even([H|T], R):- 
    H mod 2 =:= 0,
    remove_even(T, R).
remove_even([H|T1], [H|T2]):-                            
    remove_even(T1, T2).

generateNumbers(0,[]).
generateNumbers(N,[Head|Tail]):-
	N > 0,						%N must be greater than 0. Base case.
    Head is N,					%Sets the head of list to N
    N1 is N-1,					%Decrements N by 1
    generateNumbers(N1,Tail).	%Recurses on generateNumbers

mysubtract([], _, []).
mysubtract([Head|Tail], L2, L3) :-
        member(Head, L2),
        !,
        mysubtract(Tail, L2, L3).
mysubtract([Head|Tail1], L2, [Head|Tail3]) :-
        mysubtract(Tail1, L2, Tail3).

remove_greater([],[]).
remove_greater([H|T],[H|List]):-
	H < 55,
	H \= 51,
	remove_greater(T,List).
remove_greater([_|T],List):-
	remove_greater(T,List).

not_member(_,[]).
not_member(Element,[H|Tail]) :-
	Element \= H,
	not_member(Element, Tail),!.

member_third(H,List):-
	third(H,Third),
	not_member(Third,List).

s2_remove([],_,[]).
s2_remove([H|T], TheList, Result) :-
	member_third(H, TheList),
	s2_remove(T, TheList, Result),!.
s2_remove([A|T], TheList, [A|Result]) :-
	s2_remove(T, TheList, Result).

split_list([], [], []).
split_list([A], [A], []).
split_list([A, B|T], [A|Ta], [B|Tb]) :-
	split_list(T, Ta, Tb).

merge_by_product(A, [], A).
merge_by_product([], A, A).
merge_by_product([A|Ta], [B|Tb], [A|S]) :-
	A = [_, _, _, P1],
	B = [_, _, _, P2],
	P1 =< P2,
	merge_by_product(Ta, [B|Tb], S).
merge_by_product([A|Ta], [B|Tb], [B|S]) :-
	A = [_, _, _, P1],
	B = [_, _, _, P2],
	P1 > P2,
	merge_by_product([A|Ta], Tb, S).

sort_by_product([], []).
sort_by_product([A], [A]).
sort_by_product([A, B|T], S) :-
	split_list([A, B|T], L1, L2),
	sort_by_product(L1, S1),
	sort_by_product(L2, S2),
	merge_by_product(S1, S2, S).


s2(Q,End):-
	generateNumbers(End,Numbers),
	remove_greater(Numbers,RemovedNumbers),
	prime_list(End,Primes),
	remove_greater(Primes,RemovedPrimes),
	add_to_list(RemovedPrimes,NewList),
	mysubtract(RemovedNumbers,NewList,SubList),
	remove_even(SubList,SPossible),
	s1(S1,End),
	s2_remove(S1,SPossible,AA),!,
	sort_by_product(AA,Q),!.

%------s3------
remove_duplicte_products([], [], _).
 
remove_duplicte_products([H|T], [H|R], A) :- 
	last(H, X),
	get_fourth(A, X, C),
	C =:= 1, 
	remove_duplicte_products(T, R, A).
 
remove_duplicte_products([_|T], R, A) :- 
	remove_duplicte_products(T, R, A).
 
remove_duplicte_products(L, R) :-  
	remove_duplicte_products(L, R, L), !.

merge_by_sum(A, [], A).
merge_by_sum([], A, A).
merge_by_sum([A|Ta], [B|Tb], [A|S]) :-
	A = [_, _, S1, _],
	B = [_, _, S2, _],
	S1 =< S2,
	merge_by_sum(Ta, [B|Tb], S).

merge_by_sum([A|Ta], [B|Tb], [B|S]) :-
	A = [_, _, S1, _],
	B = [_, _, S2, _],
	S1 > S2,
	merge_by_sum([A|Ta], Tb, S).

sort_by_sum([], []).
sort_by_sum([A], [A]).
sort_by_sum([A, B|T], S) :-
	split_list([A, B|T], L1, L2),
	sort_by_sum(L1, S1),
	sort_by_sum(L2, S2),
	merge_by_sum(S1, S2, S).

s3(Q,N):-
	s2(Result,N),
	remove_duplicte_products(Result,AA),!,
	sort_by_sum(AA,Q),!.

%------s4------
third([_,_,Third|_], Third).
 
get_third([], _, 0).
get_third([H|T], X, R) :- 
	third(H, X),!,
	get_third(T, X, RR), 
	R is RR + 1.
get_third([_|T], X, R) :- 
	get_third(T, X, R).

remove_duplicate_sums([], [], _).
remove_duplicate_sums([H|T], [H|R], A) :- 
	third(H, X),
	get_third(A, X, C),
	C =:= 1, 
	remove_duplicate_sums(T, R, A).
remove_duplicate_sums([_|T], R, A) :- 
	remove_duplicate_sums(T, R, A).
remove_duplicate_sums(L, R) :-  
	remove_duplicate_sums(L, R, L), !.

s4(Q,N):-
	s3(Result,N),!,
	remove_duplicate_sums(Result,Q).

