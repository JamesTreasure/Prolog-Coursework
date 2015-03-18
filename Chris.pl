s1(Q, N) :-
	list(Q1, N, 2, 3),
	product_sort(Q1, Q2),
	split_uniques(Q3, _, Q2),
	sum_sort(Q3, Q).

s2(Q, N) :-
	list(Q1, N, 2, 3),
	product_sort(Q1, Q2),
	split_uniques(Q3, R1, Q2),
	sum_sort(Q3, Q4),
	sum_sort(R1, R2),
	remover_loop(Q5, R2, Q4),
	product_sort(Q5, Q).

s3(Q, N) :-
	s2(Q1, N),
	split_uniques(_, R1, Q1),
	sum_sort(R1, Q).

s4(Q, N) :-
	s3(Q1, N),
	split_uniques2(_, Q, Q1).

list(Q, N, X, Y) :-
	S is X + Y,
	S < N,
	P is X * Y,
	Y2 is Y + 1,
	list(Q2, N, X, Y2),
	Q = [[X, Y, S, P] | Q2].

list(Q, N, X, Y) :-
	S is X + Y,
	S = N,
	P is X * Y,
	X2 is X + 1,
	Y2 is X + 2,
	list(Q2, N, X2, Y2),
	Q = [[X, Y, S, P] | Q2].

list(Q, N, X, Y) :-
	S is X + Y,
	S > N,
	Q = [].

product_sort([], []).

product_sort([A], [A]).

product_sort([A, B|T], S) :-
	divide([A, B|T], L1, L2),
	product_sort(L1, S1),
	product_sort(L2, S2),
	prod_merge(S1, S2, S).

sum_sort([], []).

sum_sort([A], [A]).

sum_sort([A, B|T], S) :-
	divide([A, B|T], L1, L2),
	sum_sort(L1, S1),
	sum_sort(L2, S2),
	sum_merge(S1, S2, S).

divide([], [], []).

divide([A], [A], []).

divide([A, B|T], [A|Ta], [B|Tb]) :-
	divide(T, Ta, Tb).

prod_merge(A, [], A).

prod_merge([], A, A).

prod_merge([A|Ta], [B|Tb], [A|S]) :-
	A = [_, _, _, P1],
	B = [_, _, _, P2],
	P1 =< P2,
	prod_merge(Ta, [B|Tb], S).

prod_merge([A|Ta], [B|Tb], [B|S]) :-
	A = [_, _, _, P1],
	B = [_, _, _, P2],
	P1 > P2,
	prod_merge([A|Ta], Tb, S).

sum_merge(A, [], A).

sum_merge([], A, A).

sum_merge([A|Ta], [B|Tb], [A|S]) :-
	A = [_, _, S1, _],
	B = [_, _, S2, _],
	S1 =< S2,
	sum_merge(Ta, [B|Tb], S).

sum_merge([A|Ta], [B|Tb], [B|S]) :-
	A = [_, _, S1, _],
	B = [_, _, S2, _],
	S1 > S2,
	sum_merge([A|Ta], Tb, S).

split_uniques(Q, R, [A]) :-
	Q = [],
	R = [A].

split_uniques(Q, R, [A, B]) :-
	A = [_, _, _, P],
	B = [_, _, _, P],
	Q = [A, B],
	R = [].

split_uniques(Q, R, [A, B]) :-
	A = [_, _, _, P1],
	B = [_, _, _, P2],
	P1 \= P2,
	Q = [],
	R = [A, B].

split_uniques(Q, R, [A, B, C|T]) :-
	A = [_, _, _, P1],
	B = [_, _, _, P2],
	C = [_, _, _, P3],
	P1 = P2,
	P2 \= P3,
	split_uniques(Q2, R, [C|T]),
	Q = [A, B|Q2].

split_uniques(Q, R, [A, B, C|T]) :-
	A = [_, _, _, P],
	B = [_, _, _, P],
	C = [_, _, _, P],
	split_uniques(Q2, R, [B, C|T]),
	Q = [A|Q2].

split_uniques(Q, R, [A, B, C|T]) :-
	A = [_, _, _, P1],
	B = [_, _, _, P2],
	P1 \= P2,
	split_uniques(Q, R2, [B, C|T]),
	R = [A|R2].






split_uniques2(Q, R, [A]) :-
	Q = [],
	R = [A].

split_uniques2(Q, R, [A, B]) :-
	A = [_, _, P, _],
	B = [_, _, P, _],
	Q = [A, B],
	R = [].

split_uniques2(Q, R, [A, B]) :-
	A = [_, _, P1, _],
	B = [_, _, P2, _],
	P1 \= P2,
	Q = [],
	R = [A, B].

split_uniques2(Q, R, [A, B, C|T]) :-
	A = [_, _, P1, _],
	B = [_, _, P2, _],
	C = [_, _, P3, _],
	P1 = P2,
	P2 \= P3,
	split_uniques2(Q2, R, [C|T]),
	Q = [A, B|Q2].

split_uniques2(Q, R, [A, B, C|T]) :-
	A = [_, _, P, _],
	B = [_, _, P, _],
	C = [_, _, P, _],
	split_uniques2(Q2, R, [B, C|T]),
	Q = [A|Q2].

split_uniques2(Q, R, [A, B, C|T]) :-
	A = [_, _, P1, _],
	B = [_, _, P2, _],
	P1 \= P2,
	split_uniques2(Q, R2, [B, C|T]),
	R = [A|R2].

remover_loop(Q, [], Q).

remover_loop(Q, [Hr|Tr], [Hq|Tq]) :-
	remove_sums(Q2, Hr, [Hq|Tq]),
	remover_loop(Q, Tr, Q2).

remove_sums(Q, _, []) :-
	Q = [].

remove_sums(Q, R, [Hq|Tq]) :-
	R = [_, _, S, _],
	Hq = [_, _, S, _],
	remove_sums(Q, R, Tq).

remove_sums(Q, R, [Hq|Tq]) :-
	R = [_, _, S1, _],
	Hq = [_, _, S2, _],
	S1 \= S2,
	remove_sums(Q2, R, Tq),
	Q = [Hq|Q2].