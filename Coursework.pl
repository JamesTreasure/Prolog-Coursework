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
/*The goal s1(Q,100) will bind Q with a list of quadruples [X,Y,S,P],
 where S=X+Y and P=X*Y and X and Y are possible solutions after 
 sentence (a) is pronounced. The list will be ordered by ascending values of S.

Q = [[3, 4, 7, 12], [2, 6, 8, 12], [4, 5, 9, 20], [3, 6, 9, 18], 
[4, 6, 10, 24], [5, 6, 11, 30], [4, 7, 11, 28], [3, 8, 11, 24], 
[2, 9, 11, 18], [4, 8, 12, 32], [2, 10, 12, 20], [6, 7, 13, 42], 
[5, 8, 13, 40], [4, 9, 13, 36], [3, 10, 13, 30], [6, 8, 14, 48], 

step 1: using Sieve of Eratosthenes method to get prime number list which is less
than 100
step 2: geting composite number list according to prime number list	which is less
than 100
step 3: combining the prime number list with prime list[P,C,P+C,P*C] and 
combining the composite number list with composite number list[C1,C2,C1+C2,C1*C2].
In this step,firstly I am going to get rid of the pairs which its sum
more than 100. Secondly, after adding the first filter, I am using mergesort 
to order the list by it's product,afterthen,I will move out the list which it's 
product is single(compare the product of the list and it's next list, if they are
equal, then save all the list which have the same product with the first list.
Otherwise, delete that list).

*/

%Generates's a list of numbers
%generateNumbers(10,L).
generate_numbers(0,[]).
generate_numbers(N,[Head|Tail]):-
					N > 0,						%N must be greater than 0. Base case.
                    Head is N,					%Sets the head of list to N
                    N1 is N-1,					%Decrements N by 1
                    generate_numbers(N1,Tail).	%Recurses on generateNumbers


prime(2).
prime(N) :- 
	sqrt(N,S), 		%Square root N and store in S.
	prime_checker(N,S,3).	%Pass N, Square root of N and 3 to prime_checker.

prime_checker(_,S,D) :- D>S.	%D greater than square root of N.
prime_checker(N,S,D) :-
	N =\= D*(N//D), %N not equal to D*(N divided by D (integer division))
	D1 is D+2,		%Add two to D. Means even numbers are never prime.
	prime_checker(N,S,D1).	%Recurse with new D1

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


my_membership(X,[H|_]) :- 
	X==H,!.
my_membership(X,[_|T]) :- 
	my_membership(X,T).


my_subtract([], _, []).
my_subtract([Head|Tail], L2, L3) :-
    my_membership(Head, L2),
    !,
    my_subtract(Tail, L2, L3).
my_subtract([Head|Tail1], L2, [Head|Tail3]) :-
    my_subtract(Tail1, L2, Tail3).

my_composites(Start,End,Comp):-
	generate_numbers(End,Full),
	prime_list(Start,End,Primes),
	my_subtract(Full,Primes,Comp).

my_between(N, M, K) :- 
	N =< M, 
	K = N.
my_between(N, M, K) :- 
	N < M, 
	N1 is N+1, 
	my_between(N1, M, K).

values_p_can_be(Start,End,Final):-
	generate_numbers(End,Full),
	check_div(Start,End,List),
	my_subtract(Full,List,Final).



check_div(Start,End,[]):-
	Start > End,!.
check_div(Start,End,[Start|L]):-
	divisors(Start,List),
	length(List,GetLength),
	GetLength < 5,
	mynext(Start,Start1),
	check_div(Start1,End,L).
check_div(Start,End,L):-
	mynext(Start,Start1),
	check_div(Start1,End,L).

getLength(Number,Length):-
	divisors(Number,Div),
	length(Div,Length).

divisors(X, Divs) :- 
	bagof(D,divs(X,D), Divs).
divs(X,D) :- 
	my_between(1,X,D), 
	0 is X mod D.

mynext(2,3) :- !.
mynext(A,A1) :- A1 is A + 1.

generate_quads(X,Y):-
	generate_numbers(49,X).

gen_numbers(MaxSum, Result) :-
    MaxSum> 1,
    gen_numbers(2, MaxSum, 1, Result).

gen_numbers(Sum, Sum, Sum, []).            % 'Sum' has reached max value
gen_numbers(Sum, MaxSum, Sum, Result) :-   % 'X' has reached max value
    Sum < MaxSum,
    Sum1 is Sum + 1,
    gen_numbers(Sum1, MaxSum, 1, Result).
gen_numbers(Sum, MaxSum, X, [[X, Y, Sum]|Result]) :-
    Sum =< MaxSum,
    X < Sum,
    Y is Sum - X,
    X1 is X + 1,
    gen_numbers(Sum, MaxSum, X1, Result).




