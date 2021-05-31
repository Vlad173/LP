% Реализация стандартных предикатов обработки списков

% Длина списка (список, длина)
my_length([],0).
my_length([_|T], N) :- my_length(T, N1), N is N1+1.

% Принадлежность элемента списку (элемент, список)
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).

% Конкатенация списков (список1, список2, список1+2)
my_append([], L, L).
my_append([H|L1], L2, [H|L3]) :- my_append(L1, L2, L3).

% Удаление элемента из списка (элемент, список, список без элемента)
my_remove(X, [X|T], T).
my_remove(X, [H|T], [H|Z]) :- my_remove(X, T, Z).

% Перестановки элементов в списке (список, перестановка)
my_permute([], []).
my_permute(L, [X|T]) :- my_remove(X, L, Y), my_permute(Y, T).

% Подсписки списка (подсписок, список)
my_sublist(S, L) :- my_append(_, L1, L), my_append(S, _, L1).

% Вставка элемента в список на указанную позицию (список, элемент, позиция, новый список)
insert(T, X, 1, [X|T]) :- !.
insert([H|T], X, N, L) :- 
    M is N - 1, 
    insert(T, X, M, L1), 
    L = [H|L1].

% Со стандартными предикатами
insert2(L, Val, N, Result) :-
	length(X, N1),
	N1 is N - 1,
	append(X, Y, L),
	append(X, [Val], Temp),
	append(Temp, Y, Result), !.

% Вычисление позиции максимального элемента в списке (список, позиция)       
min_position([L|List],I) :-
	getMin([L|List], M),
	getIndex([L|List],M,1,I), !.

getMin([M],M).
getMin([M|T],M) :- getMin(T,Q), M < Q, !.
getMin([_|T],M) :- getMin(T,M).
	
getIndex([L|_],L,I,I).
getIndex([_|List],M,C,I):-
	Counter is C + 1,
	getIndex(List,M,Counter,I).

% Со стандартными предикатами
min_list(Lst, Ind) :-
	member(Max, Lst),
	\+((member(N, Lst), N < Max)),
	nth0(I, Lst, Max), 
	Ind is I + 1, !.

% Вставка на позицию минимального элемента в списке (писок, значение, новый список)
insert_min(List, Val, NewList) :-
	min_position(List, I),
	insert(List, Val, I, NewList).