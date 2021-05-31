# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Епанешников В.С.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |     5-        |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*
Грамматика в п.5
## Введение

Надеюсь, что курсовой проект поможет разобраться с принципами работы логических языков программирования, научит решать задачи кардинально другими способами и я получу базовые навыки написания программ на языке логического программирования, а также смогу познакомитсья в целом с парадигмой логического программирования.

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: ...
 3. Реализовать предикат проверки/поиска .... 
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Для создания родословного дерева я использовал сервис https://www.myheritage.com/. В родословном дереве получилось 68 индивидов и 4-5 поколения. Скачал в формате GEDCOM

## Конвертация родословного дерева

Python. Простой в использовании, отлично подошел для парсинга текста конкретно в этой задаче. 

Принцип работы:
1. Открываю файл, создаю два словаря и считываю файл построчно, заполняя словарь имён и полов в формате name[ID] = name. Параллельно выписываю все факты mother.
```python
edcom = open('tree.ged', 'r' )
prolog = open('ged.pl', 'w')
name = dict()
sex = dict()
 
for line in gedcom:
	if "INDI" in line:
		ID = line [5:10]
	elif "NAME" in line:
		full_name = line [7:-2]
		full_name = full_name.replace('/', '')
	elif "_UID" in line:
		name[ID] = full_name
	elif "SEX" in line:
		sex[ID] = line [6]
	elif "WIFE" in line:
		mother = line [10:15]
	elif "CHIL" in line:
		child = line [10:15] 
		prolog.write("mother('" + name[mother] + "', '" + name[child] + "').\n") 
```
2. Ставлю указатель на начало файла, повторно пробегаюсь по нему, выписывая уже факты father.
```python
gedcom.seek(0) 
for line in gedcom:
	if "HUSB" in line:
		father = line [10:15]
	elif "CHIL" in line:
		child = line [10:15] 
		prolog.write("father('" + name[father] + "', '" + name[child] + "').\n")
```
3. Далее итерируюсь по словарю полов и выписываю факты sex(name, 'M/F') для каждого человека. Закрываю файлы.
```python
for key in name:
	prolog.write("sex('" + name[key] + "', '" + sex[key] + "').\n")
 
gedcom.close()
prolog.close()
```

Важное замечание: добавил факты sex, поскольку невозможно определить пол человека, если у него нет детей.

## Предикат поиска родственника

Реализовать предикат проверки/поиск: деверь.

Деберь - брат мужа, следовательно, "ищем" сначала мужа для жены, затем находим всех братьев мужа.

```prolog
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
```
Для этого задания потребовалось отдельно реализовать предикаты `brother(Brother, X)`, который использует предикаты `the_same_mother(X, Y)`, `the_same_mother(X, Y)`, и `husband(Husband, X)`. 

`Пример работы:`
```
?- brother_in_law('Ирина Васильева', X). (Иван Котов с. и Артур Котов - братья мужа Ирины).
X = 'Иван Котов Старший' ;
X = 'Артур Котов' ;
false.
 
?- brother_in_law('Владислав Епанешников', X).   (У меня нет жены, а следовательно и деберя)
false.
```

## Определение степени родства

1. Описал все необходимые очевидные связи. И затем связал их одним предикатом move, для перехода в графе состояний.
```prolog
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
```
2.  Я решил использовать поиск с итерационным заглублением, чтобы находился сначала самый кратчайший путь.
```prolog
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
```
Поиск сначала выстраивает список пути имён от человека к человеку, затем отправляется в предикат `names_to_relations` и переводится в список отношений между каждой парой элементов в списке. Таким образом мы получим список, который показывает отношение родства.

`Пример работы:`
```
?- relative('Владислав Епанешников', 'Артур Котов', X). 
X = [mother, brother].
 
?- relative('Владислав Епанешников', 'Алексей Котов', X).
X = [grandmother, grandson].
 
?- relative('Роза Котова', 'Ксения Котова', X). 
X = [brother, daughter].
```

## Естественно-языковый интерфейс

1. `question` принимает вопрос в виде слов в списке и, используя предикаты формата `an_...`, где хранятся слова, решает, в какой предикат `answer` "отправиться", где уже будет вычисляться и выводиться на экран ответ.

```prolog
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
	write('Yes, '), write(Member1), write(' is '), write(Relation), write(' of '), write(Member2), nl.
 
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
	write(Member1), write(' is '), write(Relation), write(' of '), write(Member2), nl.
 
answer3(Name, Who) :-
	findall(Res, move(Who, Res, Name), NewList),
	write(Name), write(' has '), length(NewList, N), write(N), write(' '), 
	write(Who), write('s.'), nl, write(NewList), !.
```
2. Предикаты `change` необходимы для ответа на 3 тип вопроса: "How many ... does ... have", чтобы переводить существительные из множественного числа в единственное.

```prolog
change(brothers, brother).
change(sisters, sister).
change(daughters, daughter).
change(sons, son).
change(grandmothers, grandmother).
change(grandfathers, grandfather).
change(grandsons, grandson).
change(granddaughters, granddaughter).
```
3. Вопросы могут быть заданы в следующем виде:
- `?- question(['Is', 'Владислав Епанешников', 'a', 'brother', 'of', 'Владимир Епанешников']).`
- `?- question(['How', 'many', 'granddaughters', 'does', 'Пелагея Колесникова', 'have']).`
- `?- question(['Is', 'Владислав Епанешников', 'a', 'mother', 'of', 'Владимир Епанешников']).`
- `?- question(['Is', 'NoName', 'a', Z, 'of', 'Алёна Калачёва']).`
- `?- question(['Who', 'is', 'a', 'mother', 'of', 'Алексей Котов']).`

Ответы выдаются в виде:
- `Yes, Владислав Епанешников is a brother of Владимир Епанешников`
- `Пелагея Колесникова has 6 granddaughters. [Ксения Котова,Алёна Котова,Кристина Котова,Роза Галиева,Алёна Калачёва,Ирина Калачёва]`
- `No, Владислав Епанешников is not mother of Владимир Епанешников`
- `No, NoName is not in relation with anybody`
- `Ирина Андрианова is a mother of Алексей Котов`
## Выводы

Курсовой проект, на мой взгляд, состоит из очень интересных заданий: составить генеалогическое дерево, отпарсить его, определить степень родства двух любых людей, "нестандартное родство", научиться отвечать на более-менее человекоподобные вопросы. По ходу выполнения заданий начал смотреть под другим углом на привычные для меня вещи: сам стиль решения задач и подход к написанию программ. Местами было трудно, но в конечном итоге все знания о языке Prolog собрались в одну общую картину. В целом, когда пишешь на прологе, понимаешь, что к задаче нужно подходить несколько иначе чем обычно, и это сбивает с толку. В итоге для себя я пришел к выводу, что prolog действительно очень интересный язык, он заставляет менять мышление, конечно, он в каких-то обычных вещах очень непроизводительный, но вот в науке и для анализа текстов он подходит отлично.
