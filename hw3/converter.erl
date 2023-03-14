-module(converter).
-export([to_rub/1, to_rub2/1, to_rub3/1]).

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


