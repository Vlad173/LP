% Вариант 9

:-op(200, xfy, ':').

objects(['шоколад', 'деньги', 'мяч', 'cтихи', 'книга']).

agents(['Даша', 'Маша', 'медведь', 'Саша']).

verbs(File) :- File = 
    ['любить' : ['любит', 'любят'],
    'лежать' : ['лежат', 'лежит'],
    'жить' : ['живёт', 'живут'],
    'спать' : ['спит', 'спят'],
    'сдать' : ['сдал', 'сдали']].

find(V, Inf) :-
    verbs(File),
    member(M, File), conditional(V, Inf, M).

conditional(V, Inf, Inf : Y) :-
    member(V, Y).

an_q(['Где', V, N, _], X) :- 
    find(V, Inf),
    objects(List),
    member(N, List),
    X=..[Inf, object(N), loc(x)].

an_q(['Где', V, N, _], X) :- 
    find(V, Inf),
    agents(List),
    member(N, List),
    X=..[Inf, agent(N), loc(x)].

an_q(['Кто', V, N, _], X) :- 
    find(V, Inf),
    X=..[Inf, agent(y), object(N)].

an_q(['Что', V, N, _], X) :- 
    find(V, Inf),
    agents(List),
    member(N, List),
    X=..[Inf, agent(N), object(y)].
