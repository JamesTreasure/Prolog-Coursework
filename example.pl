% Mister X
% ========
% 
% Although this problem has a straightforward solution, it does
% demonstrate the value of "Prolog thinking" in understanding the problem,
% which relates to nondeterminism -- especially "don't know"
% nondeterminism, and an appropriate use of "lemmas".
% 
% Problem:
% --------
% 
% Problem as posted to comp.lang.prolog by Thorsten Seelend. Also known as
% Hans Freudenthal's Impossible Puzzle.
% 
%   Mister X thinks about two integers between 1 and 100 excluding:
% 
% MISTERX: Two integers, X and Y between 2 and 99 (My formalization of the
% given information)

two_integers( X, Y ) :-
    between( 2, 98, X ),
    between( X, 99, Y ).

% He tells Susan the Sum of them and Peter their Product. Their task is to
% get the two original values without telling each other the numbers that
% Mister X told them.
% 
%   After some time Peter says: "I can't say definitively which are the
%   original numbers."
% 
% PETER1: There is more than one pair of factors giving Product

property( peter1, Product ) :-
    \+ unique_factors( Product ).

%   Then Susan responds:
% 
%   "Neither can I, but I knew that you couldn't know it."
% 
% SUSAN1: The product of every pair of summands giving Sum has the
% property PETER1

property( susan1, Sum ) :-
    forall( ordered_summands(Sum, X, Y), peter1(X * Y) ).

%   Peter: "Really? So now I know the original numbers".
% 
% PETER2: exactly one pair of factors giving Product gives a sum with the
% property SUSAN1

property( peter2, Product ) :-
    unique_solution( (ordered_factors(Product, X, Y), susan1(X+Y)) ).

%   Susan: "Now I know them too".
% 
% SUSAN2: exactly one pair of summands giving Sum has a product with the
% property PETER2

property( susan2, Sum ) :-
    unique_solution( (ordered_summands(Sum, X, Y), peter2(X * Y)) ).

%   Question: What are the two numbers that Mister X thought of?
% 
% Unique solution

solve( X, Y ) :-
    unique_solution( mister_x(X, Y) ).
 
mister_x( X, Y ) :-
    two_integers( X, Y ),
    Sum is X + Y,
    Product is X * Y,
    peter1( Product ),
    susan1( Sum ),
    peter2( Product ),
    susan2( Sum ).

% Macros
% ------

peter1( Product ) :-
    lemma( peter1, Product ).
 
peter2( Product ) :-
    lemma( peter2, Product ).
 
susan1( Sum ) :-
    lemma( susan1, Sum ).
 
susan2( Sum ) :-
    lemma( susan2, Sum ).

% Lemmas
% ------
% 
% lemma( +Property, +Expression )
% 
% holds wherever Property holds for Expression.
% 
% Asserted facts are used to record successful (positive) or failed
% (negative) demonstrations. This saves recomputation without changing the
% meaning of the pure program.
% 
% Although the use of side-effects is generally undesirable, the use of
% lemmas is justified when the alternative is to compromise performance or
% clarity.
% 
% Using lemmas or tabling to cache results is three orders of magnitude
% faster than recalculating each property every time it is used.

:- dynamic positive/2, negative/2.
 
lemma( Name, Expression ) :-
    Value is Expression,
    ( positive( Value, Name ) ->
        true
    ; \+ negative( Value, Name ) ->
        ( property(Name, Value) ->
           assert( positive(Value, Name) )
        ; otherwise ->
           assert( negative(Value, Name) ),
           fail
        )
    ).

% Supporting Predicates
% ---------------------
% 
% ordered_summands( +Sum, ?X, ?Y )
% 
% when X =< Y and Sum = X+Y. NB: Since X=<Y it follows that X =< Sum/2.

ordered_summands( Z, X, Y ) :-
    Half is Z//2,
    between( 2, Half, X ),
    Y is Z - X,
    between( X, 98, Y ).

% ordered_factors( +Product, ?X, ?Y )
% 
% when X =< Y and Product = X × Y. NB: Since X=<Y it follows that X =<
% SQRT Product.

ordered_factors( Z, X, Y ) :-
    integer_sqrt( Z, SqrtZ ),
    between( 2, SqrtZ, X ),
    Y is Z // X,
    between( X, 99, Y ),
    Z =:= X * Y.

% unique_factors( +Product )
% 
% when Product has exactly one pair of factors.

unique_factors( Product ) :-
    ordered_factors( Product, X, _Y ),
    \+ (ordered_factors(Product, X1, _Y1), X1 =\= X).

% integer_sqrt( +N, ?Sqrt )
% 
% when Sqrt^2 =< N and (Sqrt+1)^2 >= N.

integer_sqrt( N, Sqrt ) :-
    Float is N * 1.0,
    sqrt( Float, FSqrt ),
    Sqrt is integer(FSqrt).

% Load a small library of Puzzle Utilities.

:- ensure_loaded( misc ).
