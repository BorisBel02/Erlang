1)
Shell:
1> DataWrongFormat = <<4:4, 6:4, 0:8, 0:3>>.
<<70,0,0:3>>
2> DataWrongVer = <<6:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32,
2> "hello" >>.
<<102,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
3> Data1 = <<4:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello" >>. 
<<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
4> c(protocol).
{ok,protocol}
5> protocol:
bin_to_rec/1   module_info/0  module_info/1  
5> protocol:bin_to_rec(DataWrongFormat).
** exception throw: conversion_failed
     in function  protocol:bin_to_rec/1 (protocol.erl, line 31)
6> protocol:bin_to_rec(DataWrongVer).   
** exception throw: conversion_failed
     in function  protocol:bin_to_rec/1 (protocol.erl, line 31)
7> protocol:bin_to_rec(Data1).       
Received data <<"hello">> 
{ipv4,4,6,0,232,0,0,0,0,0,0,0,0,<<0,0,0,0>>,<<"hello">>}
8> Data2 = <<4:4, 6:4, 0:8, 232:3, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello" >>. 
<<70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,12,173,
  141,141,7:3>>
9> protocol:bin_to_rec(Data2).                                                                   
** exception throw: conversion_failed
     in function  protocol:bin_to_rec/1 (protocol.erl, line 31)
10> Data2 = <<4:4, 6:4, 0:8, 10:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello" >>. 
** exception error: no match of right hand side value <<70,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                                        0,104,101,108,108,111>>
11> Data3 = <<4:4, 6:4, 0:8, 10:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello" >>.
<<70,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
12> protocol:bin_to_rec(Data3).                                                                   
Received data <<"hello">> 
{ipv4,4,6,0,10,0,0,0,0,0,0,0,0,<<0,0,0,0>>,<<"hello">>}


throw - так как, вероятно, данные могут соответствовать ipv6, и их нужно обработать в другом месте. То есть, это не ошибка, а одна из возможных ситуаций, которую можно обработать.

Значение поля Total length не проверяется, в отличие от его размера => ситуация с неверным размером не проходит, а с неверным(возможно) значением проглатывается.

2)
Shell:
14> spawn(protocol, bin_to_rec, [Data3]). 
Received data <<"hello">> 
<0.105.0>
15> self().
<0.103.0>
16> spawn(protocol, bin_to_rec, [DataWrongFormat]).
<0.108.0>
=ERROR REPORT==== 15-Mar-2023::12:34:15.056386 ===
Error in process <0.108.0> with exit value:
{{nocatch,conversion_failed},
 [{protocol,bin_to_rec,1,[{file,"protocol.erl"},{line,31}]}]}

17> self().                                        
<0.103.0>



Не изменился. С чего бы ему менятся, если это процесс шелла, в котором ошибок не происходило. Если попытаться сам шелл уронить, вызвав в нём ошибку, то шелл перезапуститься.

3) 
1> c(protocol).
{ok,protocol}
2> spawn(protocol, ipv4_listener, []).
<0.88.0>
3> Pid = <0.88.0>.
<0.88.0>
4> DataWrongFormat = <<4:4, 6:4, 0:8, 0:3>>.
<<70,0,0:3>>
5> DataWrongVer = <<6:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32,
5> "hello" >>.
<<102,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
6> Data1 = <<4:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello" >>.
<<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
7> Pid ! {ipv4, self(), Data1}.
Received data <<"hello">> 
{ipv4,<0.80.0>,
      <<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
        101,...>>}
8> Pid ! {ipv4, self(), DataWrongVer}.
{ipv4,<0.80.0>,
      <<102,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        104,101,...>>}
9> Pid ! {ipv4, self(), DataWrongFormat}.
{ipv4,<0.80.0>,<<70,0,0:3>>}
10> flush().
Shell got {ipv4,4,6,0,232,0,0,0,0,0,0,0,0,<<0,0,0,0>>,<<"hello">>}
ok
11> Pid ! {ipv4, self(), Data1}.          
{ipv4,<0.80.0>,
      <<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
        101,...>>}
12> flush().                              
ok
13> Pid1 = spawn(protocol, ipv4_listener, []).                                  <0.100.0>          
14> Pid1 ! {ipv4, self(), DataWrongFormat}.   
{ipv4,<0.80.0>,<<70,0,0:3>>}
=ERROR REPORT==== 17-Mar-2023::19:52:10.960828 ===
Error in process <0.100.0> with exit value:
{{nocatch,conversion_failed},
 [{protocol,bin_to_rec,1,[{file,"protocol.erl"},{line,31}]},
  {protocol,ipv4_listener,0,[{file,"protocol.erl"},{line,36}]}]}

15> 
3) 
1> c(protocol).
{ok,protocol}
2> spawn(protocol, ipv4_listener, []).
<0.88.0>
3> Pid = <0.88.0>.
<0.88.0>
4> DataWrongFormat = <<4:4, 6:4, 0:8, 0:3>>.
<<70,0,0:3>>
5> DataWrongVer = <<6:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32,
5> "hello" >>.
<<102,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
6> Data1 = <<4:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello" >>.
<<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
7> Pid ! {ipv4, self(), Data1}.
Received data <<"hello">> 
{ipv4,<0.80.0>,
      <<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
        101,...>>}
8> Pid ! {ipv4, self(), DataWrongVer}.
{ipv4,<0.80.0>,
      <<102,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        104,101,...>>}
9> Pid ! {ipv4, self(), DataWrongFormat}.
{ipv4,<0.80.0>,<<70,0,0:3>>}
10> flush().
Shell got {ipv4,4,6,0,232,0,0,0,0,0,0,0,0,<<0,0,0,0>>,<<"hello">>}
ok
11> Pid ! {ipv4, self(), Data1}.          
{ipv4,<0.80.0>,
      <<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
        101,...>>}
12> flush().                              
ok
13> Pid1 = spawn(protocol, ipv4_listener, []).                                  <0.100.0>          
14> Pid1 ! {ipv4, self(), DataWrongFormat}.   
{ipv4,<0.80.0>,<<70,0,0:3>>}
=ERROR REPORT==== 17-Mar-2023::19:52:10.960828 ===
Error in process <0.100.0> with exit value:
{{nocatch,conversion_failed},
 [{protocol,bin_to_rec,1,[{file,"protocol.erl"},{line,31}]},
  {protocol,ipv4_listener,0,[{file,"protocol.erl"},{line,36}]}]}

15> 
3) 
1> c(protocol).
{ok,protocol}
2> spawn(protocol, ipv4_listener, []).
<0.88.0>
3> Pid = <0.88.0>.
<0.88.0>
4> DataWrongFormat = <<4:4, 6:4, 0:8, 0:3>>.
<<70,0,0:3>>
5> DataWrongVer = <<6:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32,
5> "hello" >>.
<<102,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
6> Data1 = <<4:4, 6:4, 0:8, 232:16, 0:16, 0:3, 0:13, 0:8, 0:8, 0:16, 0:32, 0:32, 0:32, "hello" >>.
<<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
  101,108,108,111>>
7> Pid ! {ipv4, self(), Data1}.
Received data <<"hello">> 
{ipv4,<0.80.0>,
      <<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
        101,...>>}
8> Pid ! {ipv4, self(), DataWrongVer}.
{ipv4,<0.80.0>,
      <<102,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        104,101,...>>}
9> Pid ! {ipv4, self(), DataWrongFormat}.
{ipv4,<0.80.0>,<<70,0,0:3>>}
10> flush().
Shell got {ipv4,4,6,0,232,0,0,0,0,0,0,0,0,<<0,0,0,0>>,<<"hello">>}
ok
11> Pid ! {ipv4, self(), Data1}.          
{ipv4,<0.80.0>,
      <<70,0,0,232,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,104,
        101,...>>}
12> flush().                              
ok
13> Pid1 = spawn(protocol, ipv4_listener, []).                                  <0.100.0>          
14> Pid1 ! {ipv4, self(), DataWrongFormat}.   
{ipv4,<0.80.0>,<<70,0,0:3>>}
=ERROR REPORT==== 17-Mar-2023::19:52:10.960828 ===
Error in process <0.100.0> with exit value:
{{nocatch,conversion_failed},
 [{protocol,bin_to_rec,1,[{file,"protocol.erl"},{line,31}]},
  {protocol,ipv4_listener,0,[{file,"protocol.erl"},{line,36}]}]}

15> 

