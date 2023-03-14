-module(recursion).

-export([fac/1, duplicate/1, tail_duplicate/1]).

fac(N) ->
	fac(N - 1, N).

fac(N, Acc) when N > 0 ->
	fac(N - 1, Acc * N);
fac(_, Acc) ->
	Acc.

duplicate([H | T]) ->
	[H, H | duplicate(T)];
duplicate([]) ->
	[].


tail_duplicate(L) ->
	tail_duplicate(L, []).

tail_duplicate([H | T], Acc) ->
	tail_duplicate(T, Acc ++ [H, H]);
tail_duplicate([], Acc) ->
	Acc.
