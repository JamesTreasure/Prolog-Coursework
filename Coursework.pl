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



