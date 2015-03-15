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

unique([],[]).
unique((H|T),X) :-
	member1(H,T),
	unique(T, H).