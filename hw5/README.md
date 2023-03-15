КОПИПАСТ ШЕЛЛА:

1)

1> rr("*.hrl").
[person]
2> c(persons).
{ok,persons}
3> P = [   
3>                   #person{id = 1, name = "Bob", age = 23, gender = male},
3>                   #person{id = 2, name = "Kate", age = 20, gender = female},
3>                   #person{id = 3, name = "Jack", age = 34, gender = male},
3>                   #person{id = 4, name = "Nata", age = 54, gender = female}
3>                  ].
[#person{id = 1,name = "Bob",age = 23,gender = male},
 #person{id = 2,name = "Kate",age = 20,gender = female},
 #person{id = 3,name = "Jack",age = 34,gender = male},
 #person{id = 4,name = "Nata",age = 54,gender = female}]
4> persons:filter(fun(#person{gender = Gender}) -> gender == male end, P).
[]
5> persons:filter(fun(#person{gender = Gender}) -> gender = male end, P). 
** exception error: no match of right hand side value male
     in function  erl_eval:expr/5 (erl_eval.erl, line 450)
     in call from lists:'-filter/2-lc$^0/1-0-'/2 (lists.erl, line 1290)
6> persons:filter(fun(#person{gender = Gender}) -> Gender == male end, P).
[#person{id = 1,name = "Bob",age = 23,gender = male},
 #person{id = 3,name = "Jack",age = 34,gender = male}]
7> persons:any(fun(#person{gender = Gender}) -> Gender == female end, P).   
true
8> persons:any(fun(#person{age = Age}) -> Age > 20 end, P).              
true
9> persons:all(fun(#person{age = Age}) -> Age > 20 end, P).
false
10> persons:all(fun(#person{age = Age}) -> Age >= 30 end, P).
false
11> persons:all(fun(#person{age = Age}) -> Age >= 20 end, P).
true
12> pers                 
persistent_term    persons            
12> persons:update(fun(#person{age = Age, gender = female})->Person#person{age = Age - 1};(Person) -> Person end, P).
* 1:58: variable 'Person' is unbound
13> persons:update(fun(#person{age = Age, gender = female} = Person)->Person#person{age = Age - 1};(Person) -> Person end, P).
[#person{id = 1,name = "Bob",age = 23,gender = male},
 #person{id = 2,name = "Kate",age = 19,gender = female},
 #person{id = 3,name = "Jack",age = 34,gender = male},
 #person{id = 4,name = "Nata",age = 53,gender = female}]
 


2)

1> [3*X || X <- [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]].
[3,6,9,12,15,18,21,24,27,30]
2> [X*X || X <- [1, "hello", 100, boo, "boo", 9], is_integer(X)].
[1,10000,81]

3)

7> exceptions:catch_all(fun() -> 1/0 end).
Action #Fun<erl_eval.45.65746770> failed, reason badarith 
error
8> exceptions:catch_all(fun() -> throw(custom_exceptions) end).
Action #Fun<erl_eval.45.65746770> failed, reason custom_exceptions 
throw
9> exceptions:catch_all(fun() -> exit(killed) end).            
Action #Fun<erl_eval.45.65746770> failed, reason killed 
exit
10> exceptions:catch_all(fun() -> erlang:error(runtime_exception) end).
Action #Fun<erl_eval.45.65746770> failed, reason runtime_exception 
error

