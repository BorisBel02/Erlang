-module(converter).
-export([to_rub/1, to_rub2/1, to_rub3/1, rec_to_rub/1, map_to_rub/1]).
-record(conv_info, {type, amount, comission}).

to_rub({_, Amount}) when Amount < 0 ->
	io:format("Amount of money can not be a negative value~n"),
	{error, badarg};
to_rub({usd, Amount}) ->
	{ok, Amount * 75.5};
to_rub({euro, Amount}) ->
	{ok, Amount * 80};
to_rub({lari, Amount}) ->
	{ok, Amount * 29};
to_rub({peso, Amount}) ->
	{ok, Amount * 3};
to_rub({krone, Amount}) ->
	{ok, Amount * 10};
to_rub({Val, _}) ->
	io:format("Unknown vallet ~p~n", [Val]),
	{error, badarg}.

to_rub2(Arg) ->
	Result =
		case Arg of
		{_, Amount} when Amount < 0 ->
			io:format("Amount of money can not be a negative~n"),
			{error, badarg};
		{usd, Amount} ->
			{ok, 75.5 * Amount};
                {euro, Amount} ->
                        {ok, 80 * Amount};
                {lari, Amount} ->
                        {ok, 29 * Amount};
                {peso, Amount} ->
                        {ok, 3 * Amount};
                {krone, Amount} ->
                        {ok, 10 * Amount};
		Error ->
			io:format("Can’t convert to rub, error ~p~n", [Error]),
			{error, badarg}
		end,
	Result.
to_rub3(Arg) ->
                case Arg of
		{_, Amount} when Amount < 0 ->
			io:format("Amount of money can not be a negative~n"),
			{error, badarg};
                {usd, Amount} ->
                        {ok, 75.5 * Amount};
                {euro, Amount} ->
                        {ok, 80 * Amount};
                {lari, Amount} ->
                        {ok, 29 * Amount};
                {peso, Amount} ->
                        {ok, 3 * Amount};
                {krone, Amount} ->
                        {ok, 10 * Amount};
                Error ->
                        io:format("Can’t convert to rub, error ~p~n", [Error]),
                        {error, badarg}
                end.

rec_to_rub(#conv_info{type = _, amount = Amount, comission = Comission}) when Amount < 0 ; Comission > 1 ; Comission < 0 ->
        {error, badargs};
rec_to_rub(#conv_info{type = usd, amount = Amount, comission = Comission}) ->
	{ok, Amount * 75.5 * (1 - Comission)};
rec_to_rub(#conv_info{type = euro, amount = Amount, comission = Comission}) ->
        {ok, Amount * 80 * (1 - Comission)};
rec_to_rub(#conv_info{type = lari, amount = Amount, comission = Comission}) ->
        {ok, Amount * 29 * (1 - Comission)};
rec_to_rub(#conv_info{type = peso, amount = Amount, comission = Comission}) ->
        {ok, Amount * 3 * (1 - Comission)};
rec_to_rub(#conv_info{type = krone, amount = Amount, comission = Comission}) ->
        {ok, Amount * 10 * (1 - Comission)};
rec_to_rub(#conv_info{type = _, amount = _, comission = _}) ->
        {error, badarg}.

map_to_rub(#{type := _, amount := Amount, comission := Comission}) when Amount < 0 ; Comission < 0 ; Comission > 1 ->
	{error, badarg};
map_to_rub(#{type := usd, amount := Amount, comission := Comission}) ->
        {ok, Amount * 75.5 * (1 - Comission)};
map_to_rub(#{type := euro, amount := Amount, comission := Comission}) ->
        {ok, Amount * 80 * (1 - Comission)};
map_to_rub(#{type := lari, amount := Amount, comission := Comission}) ->
        {ok, Amount * 29 * (1 - Comission)};
map_to_rub(#{type := peso, amount := Amount, comission := Comission}) ->
        {ok, Amount * 3 * (1 - Comission)};
map_to_rub(#{type := krone, amount := Amount, comission := Comission}) ->
        {ok, Amount * 10 * (1 - Comission)};
map_to_rub(#{type := _, amount := _, comission := _}) ->
        {error, badarg}.
