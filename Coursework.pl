%-------s1--------


%Generates's a list of numbers
%generateNumbers(10,L).
generateNumbers(0,[]).
generateNumbers(N,[Head|Tail]):-
					N > 0,						%N must be greater than 0. Base case.
                    Head is N,					%Sets the head of list to N
                    N1 is N-1,					%Decrements N by 1
                    generateNumbers(N1,Tail).	%Recurses on generateNumbers
