natlist(N,[N]).
natlist(N,[N|L]) :- N1 is N+1, natlist(N1,L).


primes(PL) :- natlist(2,L2), sieve(L2,PL).

sieve([ ],[ ]).
sieve([P|L],[P|IDL]) :- sieveP(P,L,PL), sieve(PL,IDL).

sieveP(P,[ ],[ ]). 
sieveP(P,[N|L],[N|IDL]) :- N mod P  >  0, sieveP(P,L,IDL).
sieveP(P,[N|L],   IDL)  :- N mod P =:= 0, sieveP(P,L,IDL).