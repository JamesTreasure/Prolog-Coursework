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
prime_list(A,B,L) :-
	 A =< 2,		%If A is less than two
	 !, 			
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

addTest(Start,End,List):-
	prime_list(Start,End,Primes),
	add_to_list(Primes,List).

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


tester(Start,End,List):-
	prime_list(Start,End,Primes),
	add_to_list(Primes,NewList),
	generateNumbers(End,Numbers),
	mysubtract(Numbers,NewList,SubList),
	remove_even(SubList,List).


not_member(Element, List) :-
	not_member_(List, Element). % flip for first argument indexing

not_member_([], _).
not_member_([N|Ns], M) :-
	N \= M,
	not_member_(Ns, M).



%53,51,47,41,37,35,29,27,23,17,11,3,1

/*[[2, 9, 11, 18], [3, 8, 11, 24], [4, 7, 11, 28], [5, 6, 11, 30], 
[2, 15, 17, 30], [3, 14, 17, 42], [2, 21, 23, 42], [2, 25, 27, 50], 
[4, 13, 17, 52], [2, 27, 29, 54], [5, 12, 17, 60], [3, 20, 23, 60], 
[6, 11, 17, 66], [2, 33, 35, 66], [7, 10, 17, 70], [2, 35, 37, 70],
[3, 24, 27, 72], [8, 9, 17, 72], [4, 19, 23, 76], [3, 26, 29, 78], 
[2, 39, 41, 78], [5, 18, 23, 90], [2, 45, 47, 90], [4, 23, 27, 92], 
[3, 32, 35, 96], [4, 25, 29, 100], [6, 17, 23, 102], [3, 34, 37, 102], 
[2, 51, 53, 102], [5, 22, 27, 110], [7, 16, 23, 112], [3, 38, 41, 114], 
[5, 24, 29, 120], [8, 15, 23, 120], [4, 31, 35, 124], [9, 14, 23, 126], 
[6, 21, 27, 126], [10, 13, 23, 130], [11, 12, 23, 132], [3, 44, 47, 132], 
[4, 33, 37, 132], [6, 23, 29, 138], [7, 20, 27, 140], [4, 37, 41, 148], 
[5, 30, 35, 150], [3, 50, 53, 150], [8, 19, 27, 152], [7, 22, 29, 154], 
[5, 32, 37, 160], [9, 18, 27, 162], [8, 21, 29, 168], [10, 17, 27, 170],
[4, 43, 47, 172], [6, 29, 35, 174], [11, 16, 27, 176], [5, 36, 41, 180],
[12, 15, 27, 180], [9, 20, 29, 180], [13, 14, 27, 182], [6, 31, 37, 186], 
[10, 19, 29, 190], [7, 28, 35, 196], [4, 49, 53, 196], [11, 18, 29, 198], 
[12, 17, 29, 204], [13, 16, 29, 208], [7, 30, 37, 210], [5, 42, 47, 210], 
[14, 15, 29, 210], [6, 35, 41, 210], [8, 27, 35, 216], [8, 29, 37, 232], 
[9, 26, 35, 234], [7, 34, 41, 238], [5, 48, 53, 240], [6, 41, 47, 246], 
[10, 25, 35, 250], [9, 28, 37, 252], [11, 24, 35, 264], [8, 33, 41, 264], 
[10, 27, 37, 270], [12, 23, 35, 276], [7, 40, 47, 280], [6, 47, 53, 282], 
[13, 22, 35, 286], [11, 26, 37, 286], [9, 32, 41, 288], [14, 21, 35, 294], 
[15, 20, 35, 300], [12, 25, 37, 300], [16, 19, 35, 304], [17, 18, 35, 306], 
[10, 31, 41, 310], [13, 24, 37, 312], [8, 39, 47, 312], [14, 23, 37, 322], 
[7, 46, 53, 322], [11, 30, 41, 330], [15, 22, 37, 330], [16, 21, 37, 336], 
[17, 20, 37, 340], [18, 19, 37, 342], [9, 38, 47, 342], [12, 29, 41, 348], 
[8, 45, 53, 360], [13, 28, 41, 364], [10, 37, 47, 370], [14, 27, 41, 378], 
[15, 26, 41, 390], [11, 36, 47, 396], [9, 44, 53, 396], [16, 25, 41, 400], 
[17, 24, 41, 408], [18, 23, 41, 414], [19, 22, 41, 418], [20, 21, 41, 420], 
[12, 35, 47, 420], [10, 43, 53, 430], [13, 34, 47, 442], [11, 42, 53, 462], 
[14, 33, 47, 462], [15, 32, 47, 480], [12, 41, 53, 492], [16, 31, 47, 496], 
[17, 30, 47, 510], [13, 40, 53, 520], [18, 29, 47, 522], [19, 28, 47, 532], 
[20, 27, 47, 540], [21, 26, 47, 546], [14, 39, 53, 546], [22, 25, 47, 550], 
[23, 24, 47, 552], [15, 38, 53, 570], [16, 37, 53, 592], [17, 36, 53, 612], 
[18, 35, 53, 630], [19, 34, 53, 646], [20, 33, 53, 660], [21, 32, 53, 672], 
[22, 31, 53, 682], [23, 30, 53, 690], [24, 29, 53, 696], [25, 28, 53, 700], 
[26, 27, 53, 702]] */

