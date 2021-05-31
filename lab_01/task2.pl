% Task 2: Relational Data

/* Вариант 2 */
/* Напечатать средний балл для каждого предмета */
/* Для каждой группы, найти количество не сдавших студентов */
/* Найти количество не сдавших студентов для каждого из предметов */

:- ['three.pl'].

% Первое подзадание

sum_grades([],0).
sum_grades([H|T],N) :- 
    sum_grades(T,M), 
    N is H + M.

check1(X, Subject) :-
    student(_, _, List),
    member(grade(Subject, X), List).

task1(Subj, Average) :-
    subject(Subject, Subj),
    setof(X, check1(X, Subject), NewList),
    length(NewList, N),
    sum_grades(NewList, Sum),
    Average is Sum / N.


% Второе подзадание (не смог настроить вывод, выводятся правильные ответы по несколько раз)
check(Name, Group) :-
    student(Group, Name, List), 
    member(grade(_, 2), List).

task2(Group, Result) :-
    student(Group, _, _),
    findall(Name, check(Name, Group), List), 
    length(List, Result).

% Другая реализация второго подзадания с нормальным выводом
withoutcopy([], []):-!.
withoutcopy([X|L], List):-
          member(X, L),
	  !, 
	  withoutcopy(L, List).
withoutcopy([X|L], [X|List]):-
	  !, 
	  withoutcopy(L, List).

task22():-
	findall(Gr, student(Gr, _, _), Group),
	withoutcopy(Group, G),
	count(G).

check(Group) :-
    student(Group, _, List), 
    member(grade(_, 2), List).

count([]) :- !.
count([Group|T]) :-
    findall(Group, check(Group), List),
	length(List, Result),
	write(Group), write(': '),write(Result), nl,
	count(T).


% Третье подзадание
check3(Name, Subject) :-
    student(_, Name, List),
    member(grade(Subject, 2), List).

task3(Subj, N) :-
    subject(Subject, Subj),
    findall(Name, check3(Name, Subject), NewList),
    length(NewList, N).

