2.

1> Linked = keylist:start_link(linked).
<0.82.0>
2> {Monitored, Monitor} = keylist:start(monitored).
{<0.84.0>,#Ref<0.3417268412.3713269762.215498>}
3> Linked ! {self(), add, "Bob", 28, "male"}.
{<0.80.0>,add,"Bob",28,"male"}
4> Linked ! {self(), add, "Johnny", 28, " no leg :( "}.
{<0.80.0>,add,"Johnny",28," no leg :( "}
5> Linked ! {self(), is_member, "Johnny"}.                   
{<0.80.0>,is_member,"Johnny"}
6> flush().                               
Shell got {ok,1}
Shell got {ok,2}
Shell got {true,3}
ok


3.

28> Monitored ! {self(), is_member, "Johnny"}.
{<0.110.0>,is_member,"Johnny"}
29> flush().
Shell got {false,1}
ok
30> exit(Monitored, "Do svyazi").             
true
31> flush().
ok
32> self().
<0.110.0>
33> Monitored ! {self(), is_member, "Johnny"}.
{<0.110.0>,is_member,"Johnny"}
34> flush().                                  
ok


4.
7> self().
<0.80.0>
8> exit(Linked, "Do svyazi").
** exception exit: "Do svyazi"
9> self().
<0.91.0>

5.
10> process_flag(trap_exit, true).
false
11> f(Linked).
ok
12> Linked ! {self(), is_member, "Johnny"}.
* 1:1: variable 'Linked' is unbound
13> Linked = keylist:start_link(linked).                
<0.97.0>
14> exit(Linked, "Do svyazi").             
true
15> self().
<0.91.0>
16> flush().
Shell got {'EXIT',<0.97.0>,"Do svyazi"}
ok
17> process_flag(trap_exit, false).        
true
18> Linked1 = keylist:start_link(linked1). 
<0.103.0>
19> Linked2 = keylist:start_link(linked2).
<0.105.0>
20> Linked1 ! {self(), is_member, "Johnny"}.
{<0.91.0>,is_member,"Johnny"}
21> Linked2 ! {self(), is_member, "Johnny"}.
{<0.91.0>,is_member,"Johnny"}
22> flush().
Shell got {false,1}
Shell got {false,1}
ok
23> exit(Linked1, "Do svyazi").             
** exception exit: "Do svyazi"
24> self().
<0.110.0>
25> Linked2 ! {self(), is_member, "Johnny"}.
{<0.110.0>,is_member,"Johnny"}
26> Linked1 ! {self(), is_member, "Johnny"}.
{<0.110.0>,is_member,"Johnny"}
27> flush().
ok


4,5 - связанные процессы уничтожаются вместе(при отсутствии trap_exit)
3 - процессы не связаны.

