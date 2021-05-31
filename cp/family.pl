:- ['ged.pl'].

% деберь
brother_in_law(Wife, Bro) :-
    husband(Husband, Wife),
    brother(Bro, Husband).


the_same_father(X, Y) :-
    father(F, Y),
    father(F, X).

the_same_mother(X, Y) :-
    mother(M, Y),
    mother(M, X).

% муж
husband(Husband, X) :-
    mother(X, Child),
    father(Husband, Child).

% жена
wife(Wife, X) :-
    mother(Wife, Child),
    father(X, Child).

% брат
brother(Brother, X) :-
    the_same_mother(X, Brother),
    the_same_father(X, Brother),
    sex(Brother, 'M'),
    X \= Brother.

% сестра
sister(Sister, X) :-
    the_same_mother(X, Sister),
    the_same_father(X, Sister),
    sex(Sister, 'F'),
    X \= Sister.

% внук
grandson(Gs, X) :-
    sex(Gs, 'M'),
    (mother(M, Gs), mother(X, M);
    father(F, Gs), mother(X, F)).

    
% внучка
granddaughter(Gd, X) :-
    sex(Gd, 'F'),
    (mother(M, Gd), mother(X, M);
    father(F, Gd), mother(X, F)).

% родитель
parent(Parent, X) :-
    father(Parent, X);
    mother(Parent, X).

% бабушка
grandmother(Gm, X) :-
    parent(P, X),
    mother(Gm, P).

% дедушка
grandfather(Gf, X) :-
    parent(P, X),
    father(Gf, P).

% сын
son(S, X) :-
    sex(S, 'M'),
    parent(X, S).

% дочь
daughter(D, X) :-
    sex(D, 'F'),
    parent(X, D).

move('father', X, Y) :- father(X, Y).
move('mother', X, Y) :- mother(X, Y).
move('brother', X, Y) :- brother(X, Y).
move('sister', X, Y) :- sister(X, Y).
move('husband', X, Y) :- husband(X, Y).
move('wife', X ,Y) :- wife(X, Y).
move('son', X, Y) :- son(X, Y).
move('daughter', X, Y) :- daughter(X, Y).
move('grandson', X, Y) :- grandson(X, Y).
move('granddaughter', X, Y) :- granddaughter(X, Y).
move('grandfather', X, Y) :- grandfather(X, Y).
move('grandmother', X, Y) :- grandmother(X, Y).  

my_integer(1).
my_integer(X) :-
	my_integer(N),
	X is N + 1.

names_to_relations([_], []).
names_to_relations([First, Second|Tail], Res) :-
	move(Relation, First, Second),
	Res = [Relation|Tmp],
	names_to_relations([Second|Tail], Tmp).

relative(X, Y, Res) :-
	search_id(X, Y, Res), !.

search_id(Start, Finish, Res) :-
    	my_integer(Level),
    	search_id(Start, Finish, Path, Level),
    	names_to_relations(Path, Res1), 
   	reverse(Res1, Res).

search_id(Start, Finish, Path, DepthLimit):-
   	depth_id([Start], Finish, Path, DepthLimit).

depth_id([Finish|Tail], Finish, [Finish|Tail], 0).
depth_id(Path, Finish, Res, N) :-
	N > 0,
	prolong(Path, NewPath),
	N1 is N - 1,
	depth_id(NewPath, Finish, Res, N1).

prolong([H|T], [New, H|T]) :-
    	move(_, H, New),
    	not(member(New, [H|T])).
    
% Естественно-языковый интерфейс
change(brothers, brother).
change(sisters, sister).
change(daughters, daughter).
change(sons, son).
change(grandmothers, grandmother).
change(grandfathers, grandfather).
change(grandsons, grandson).
change(granddaughters, granddaughter).
 
question([L1, L2, L3, L4, L5, L6]) :-
    (an_who(L1), an_is(L2), an_article(L3), an_prist(L5)) -> answer2(L4, L6) ;
    (an_does(L1), an_prist(L5), an_article(L3)) -> answer1(L4, L2, L6);
    ( an_how(L1), L2 = 'many', change(L3, L), an_does(L4), an_hovehas(L6)) -> answer3(L5, L).
 
 
an_does(X) :-
   	member(X, ['Does', 'does', 'Is']).
 
an_who(X) :-
   	member(X, ['Who', 'who']).
 
an_article(X) :-
   	member(X, ['a', 'an']).
 
an_how(X) :-
   	member(X, ['How', 'how']).
 
an_prist(X):-
	member(X, ['of']).
 
an_is(X):-
	member(X, ['is', 'are']).
 
an_hovehas(X) :-
	member(X, ['have', 'has']).
 
 
 
answer1(Relation, Member1, Member2) :-
	move(Relation, Member1, Member2),
	write('Yes, '), write(Member1), write(' is '), write(' a '), write(Relation), write(' of '), write(Member2), nl.
 
answer1(Relation, Member1, Member2) :-
	not(move(Relation, Member1, Member2)),
	atomic(Relation),
	write('No, '), write(Member1), write(' is not '), write(Relation), write(' of '), write(Member2), nl.
 
answer1(Relation, Member1, Member2) :-
	not(move(Relation, Member1, Member2)),
	not(atomic(Relation)),
	write('No, '), write(Member1), write(' is not in relation with anybody'), nl.
 
 
answer2(Relation, Member2) :-
	move(Relation, Member1, Member2),
	write(Member1), write(' is '), write(' a '), write(Relation), write(' of '), write(Member2), nl.
 
answer3(Name, Who) :-
	findall(Res, move(Who, Res, Name), NewList),
	write(Name), write(' has '), length(NewList, N), write(N), write(' '), write(Who), write('s.'), nl, write(NewList), !.
