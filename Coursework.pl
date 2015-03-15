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
	okay(N,S,3).	%Pass N, Square root of N and 3 to okay.

okay(N,S,D) :- D>S.	%D greater than square root of N.
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

member1(X,[H|_]) :- 
	X==H,!.
member1(X,[_|T]) :- 
	member1(X,T).
 
remove_duplicates([],[]).		%Empty list has no duplicate
remove_duplicates([H|T],X) :- 	%Head and tail of input list and variable X for new list
	member1(H,T),				%check if the first element is a member of the list
	!, 							%Stops multiple	
	remove_duplicates(T,X).		%Recursion on remove_duplicates with tail of list

remove_duplicates([H|T],[H|X]) :- 
	remove_duplicates(T,X).

%concat_list([1,2,3],[4,5,6],A).
concat_list([],L1,L1).    
concat_list([X|Tail],L2,[X|Tail1]):-
        	concat_list(Tail,L2,Tail1).

test(A, B) :- 
	prime_list(1, A, Primes), 
	generate_numbers(A, Numbers), 
	concat_list(Primes, Numbers, B).

	





