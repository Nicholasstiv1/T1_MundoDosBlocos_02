% A means-ends planner with goal regression
% plan( State, Goals, Plan, Conditions)
plan(State, Goals, [], Conditions):-
    satisfied(State, Goals, Conditions).

plan(State, Goals, Plan, Conditions):-
    append(PrePlan, [Action], Plan),
    select(State, Goals, Goal),
    achieves(Action, Goal),
    can(Action, Condition),
    preserves(Action, Goals),
    regress(Goals, Action, RegressedGoals, Conditions),
    plan(State, RegressedGoals, PrePlan, Conditions).

satisfied(State, Goals, Conditions)  :-
    delete_all(Goals, State, Conditions).

select(State, Goals, Goal)  :-
    (member(Goal, Goals) ; member(Goal, Conditions)),
    \+ member(Goal, State).

achieves(Action, Goal)  :-
    adds(Action, Goals),
    member(Goal, Goals).

preserves(Action, Goals)  :-
    deletes(Action, Relations),
    \+ (member(Goal, Relations), member(Goal, Goals)).

regress(Goals, Action, RegressedGoals, Conditions)  :-
    adds(Action, NewRelations),
    delete_all(Goals, NewRelations, RestGoals),
    can(Action, Condition),
    addnew(Condition, RestGoals, RegressedGoals, Conditions).

addnew([], L, L, _).

addnew([Goal | _], Goals, _, Conditions)  :-
    impossible(Goal, Goals, Conditions),
    !,
    fail.

addnew([X | L1], L2, L3, Conditions)  :-
    (member(X, L2) ; member(X, Conditions)), !,
    addnew(L1, L2, L3, Conditions).

addnew([X | L1], L2, [X | L3], Conditions)  :-
    addnew(L1, L2, L3, Conditions).

% Extra clause to handle quasi goals
satisfied(State, [Goal | Goals], Conditions) :-
    holds(Goal, Conditions),
    satisfied(State, Goals, Conditions).

% Extra clause for quasi goals
holds(Goal, Conditions) :-
    \+ member(Goal, Conditions).
