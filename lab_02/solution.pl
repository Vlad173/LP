% Вариант 2
% Три миссионера и три каннибала хотят переправиться с левого берега реки на правый
% Как это сделать за минимальное число шагов, если в их распоряжении имеется трехместная лодка
% и ни при каких обстоятельствах миссионеры не должны оставаться в меньшинстве?


% Поиск в глубину
search_dfs :-
    path_dfs([[3, 3, left]], [0, 0, right], Result),
    print_res(Result).

path_dfs([X|T], X, [X|T]).
path_dfs(P, Y, R) :-
    prolong(P, P1),
    path_dfs(P1, Y, R).

% Поиск в ширину
search_bfs :-
    path_bfs([ [[3, 3, left]] ], [0, 0, right], Result),
    print_res(Result).

path_bfs([[X|T]|_], X, [X|T]).
path_bfs([P|QI], X, R) :-
    findall(Z, prolong(P, Z), T),
    append(QI, T, QQ), !,
    path_bfs(QQ, X, R).
path_bfs([_|T], X, R) :- path_bfs(T, X, R).

% Поиск с итерационным заглублением
search_id :-
    my_integer(Level),
    path_id([[3, 3, left]], [0, 0, right], Result, Level),
    print_res(Result).

path_id([X|T], X, [X|T], 0).
path_id(P, Y, R, N) :- 
    N > 0,
    prolong(P, P1),
    N1 is N - 1,
    path_id(P1, Y, R, N1).

% Вспомогательные предикаты
my_integer(1).
my_integer(M) :- my_integer(N), M is N + 1.

prolong([X|T], [Y, X|T]) :-
    move(X, Y, _),
    condition(Y),
    not(member(Y, [X|T])).

condition([A, B, _]) :-
    (A >= B ; A = 0),
	C is 3 - A, D is 3 - B,
	(C >= D ; C = 0).

print_res([_]).
print_res([A,B|T]):-
	print_res([B|T]),
	move(B, A, Action),
	write(B),write(' -> '),
	write(A),write(': '),
	write(Action), nl.

% Всевозможные движения
move([A, B, left], [C, B, right], '1 миссионер переплывает на правый берег' ) :-
    A > 0, C is A - 1.
move([A, B, left], [C, B, right], '2 миссионера переплывают на правый берег' ) :-
    A > 1, C is A - 2.
move([A, B, left], [C, B, right], '3 миссионера переплывают на правый берег' ) :-
    A > 2, C is A - 3.
move([A, B, left], [A, D, right], '1 каннибал переплывает на правый берег' ) :-
    B > 0, D is B - 1.
move([A, B, left], [A, D, right], '2 каннибала переплывают на правый берег' ) :-
    B > 1, D is B - 2.
move([A, B, left], [A, D, right], '3 каннибала переплывают на правый берег' ) :-
    B > 2, D is B - 3.
move([A, B, left], [C, D, right], '1 миссионер и 1 каннибал переплывают на правый берег' ) :-
    A > 0, B > 0, C is A - 1, D is B - 1.
move([A, B, left], [C, D, right], '2 миссионера и 1 каннибал переплывают на правый берег' ) :-
    A > 1, B > 0, C is A - 2, D is B - 1.

move([A, B, right], [C, B, left], '1 миссионер переплывает на левый берег') :-
    A < 3, C is A + 1.
move([A, B, right], [C, B, left], '2 миссионера переплывают на левый берег') :-
    A < 2, C is A + 2.
move([A, B, right], [C, B, left], '3 миссионера переплывают на левый берег') :-
    A < 1, C is A + 3.
move([A, B, right], [A, D, left], '1 каннибал переплывает на левый берег') :-
    B < 3, D is B + 1.
move([A, B, right], [A, D, left], '2 каннибала переплывают на левый берег') :-
    B < 2, D is B + 2.
move([A, B, right], [A, D, left], '3 каннибала переплывают на левый берег') :-
    B < 1, D is B + 3.
move([A, B, right], [C, D, left], '1 миссионер и 1 каннибал переплывают на левый берег') :-
    A < 3, B < 3, C is A + 1, D is B + 1.
move([A, B, right], [C, D, left], '2 миссионера и 1 каннибал переплывают на левый берег') :-
    A < 2, B < 3, C is A + 2, D is B + 1.
