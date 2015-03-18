/*
Let X and Y be two integers with 1 < X < Y and X + Y <= 100.
Mathematician S is given the sum X + Y
Mathematician P is given the product X * Y
The following conversation takes place:
(a) P: I do not know the two numbers.
(b) S: I knew you didn’t know. I don’t know either.
(c) P: Now I know the two numbers. 
(d) S: Now I know the two numbers.
*/

%-------s1--------
my_between(N, M, K) :- 
	N =< M, 
	K = N.
my_between(N, M, K) :- 
	N < M, 
	N1 is N+1, 
	my_between(N1, M, K).

gen_numbers(MaxSum, Result) :-
    MaxSum> 1,								
    gen_numbers(2, MaxSum, 2, Result).		
gen_numbers(Sum, Sum, Sum, []).            % 'Sum' has reached max value
gen_numbers(Sum, MaxSum, Sum, Result) :-   
    Sum < MaxSum,
    Sum1 is Sum + 1,
    gen_numbers(Sum1, MaxSum, 2, Result).	%3,100,1,Result
gen_numbers(Sum, MaxSum, X, [[X, Y, Sum, P]|Result]) :- 
	Sum =< MaxSum,	
	X < Sum,
	Y is Sum - X, 
	X < Y,
	P is X*Y,
	X1 is X + 1, 
	gen_numbers(Sum, MaxSum, X1, Result).
gen_numbers(Sum, MaxSum, X, Result) :-
	X1 is X + 1,
    gen_numbers(Sum, MaxSum, X1, Result).

test(End,Final):-
	gen_numbers(End,Numbers),
	length(Numbers,Final).
	
last([X], X).
last([_|T], X) :- last(T, X).
 
forth([_,_,_,F|_], F).
 
matching_forth([], _, 0).
matching_forth([H|T], X, R) :- 
	forth(H, X), 
	matching_forth(T, X, RR), 
	R is RR + 1.
matching_forth([_|T], X, R) :- 
	matching_forth(T, X, R).

 
my_membership([], [], _).
 
my_membership([H|T], [H|R], A) :- 
	last(H, X), 
	matching_forth(A, X, C),
	C > 1, 
	my_membership(T, R, A).
 
my_membership([_|T], R, A) :- 
	my_membership(T, R, A).
 
my_membership(L, R) :-  
	my_membership(L, R, L), !.
 
s1(Q,N):-
	gen_numbers(N,Numbers), !,
	my_membership(Numbers,Q).

%-------s2--------
%S is odd.
%S is not of form Q+2 where Q is prime
%S is less than 55.
%Remove all even numbers, all primes+2 and all numbers greater than 55.S

prime(2).
prime(N) :- 
	sqrt(N,S), 		%Square root N and store in S.
	okay(N,S,3).	%Pass N, Square root of N and 3 to okay.

okay(_,S,D) :- D>S.	%D greater than square root of N.
okay(N,S,D) :-
	N =\= D*(N//D), %N not equal to D*(N divided by D (integer division))
	D1 is D+2,		%Add two to D. Means even numbers are never prime.
	okay(N,S,D1).	%Recurse with new D1

%Generates prime numbers between two numbers. prime_list(1,100,A).
prime_list(B,L) :-
 	 p_list(2,B,L).	%Calls p_list with A replaces by 2.

prime_list(A,B,L) :-
	 A1 is (A // 2) * 2 + 1,	%Essentially makes A1 always odd as even not prime.
	 p_list(A1,B,L).			%Calls p_list with A1

p_list(A,B,[]) :-	%Empty list if A is bigger than B. eg, (100,10,A).
	 A > B, 		%Base case for when to stop recursing.
	 !.

%If it returns true then add A to the prime list.
p_list(A,B,[A|L]) :- 
	prime(A), 		%Checks if first number is prime.
	!, 
   	next(A,A1),		%Adds two to A and returns A1.
   	p_list(A1,B,L). %Recursive call with new value A1.

%If A wasn't prime in the prime check above, add two to A and recurse.
p_list(A,B,L) :- 
   next(A,A1),
   p_list(A1,B,L).

next(2,3) :- !.
next(A,A1) :- A1 is A + 2.

add_to_list([],[]).
add_to_list([H|T],[Y|List]):-
	Y is H + 2,
	add_to_list(T,List).

remove_even([],[]).
remove_even([El|T], NewT):- 
    El mod 2 =:= 0,
    remove_even(T, NewT).
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

third([_,_,Third|_], Third).

member_third(H,List):-
	third(H,Third),
	not_member(Third,List).

s2_remove([],_,[]).
s2_remove([H|T], TheList, Result) :-
	member_third(H, TheList),
	s2_remove(T, TheList, Result),!.
s2_remove([A|T], TheList, [A|Result]) :-
	s2_remove(T, TheList, Result).

/*
check_div(Start,End,[Start|L]):-
	divisors(Start,List),
	length(List,GetLength),
	GetLength < 5,
	mynext(Start,Start1),
	check_div(Start1,End,L).
check_div(Start,End,L):-
	next(Start,Start1),
	check_div(Start1,End,L).
*/

tester(End,List):-
	generateNumbers(End,Numbers),
	remove_greater(Numbers,RemovedNumbers),
	prime_list(End,Primes),
	remove_greater(Primes,RemovedPrimes),
	add_to_list(RemovedPrimes,NewList),
	mysubtract(RemovedNumbers,NewList,SubList),
	remove_even(SubList,SPossible),
	s1(S1,End),
	s2_remove(S1,SPossible,FF),
	length(FF,List).

s2(Q,End):-
	generateNumbers(End,Numbers),
	remove_greater(Numbers,RemovedNumbers),
	prime_list(End,Primes),
	remove_greater(Primes,RemovedPrimes),
	add_to_list(RemovedPrimes,NewList),
	mysubtract(RemovedNumbers,NewList,SubList),
	remove_even(SubList,SPossible),
	s1(S1,End),!,
	s2_remove(S1,SPossible,Q).

%53,51,47,41,37,35,29,27,23,17,11,3,1

%-------s3------










