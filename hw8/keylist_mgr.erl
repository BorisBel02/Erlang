-module(keylist_mgr).
-export([loop/1, start/0, start_child/2, stop_child/2, get_names/1]).
-record(state, {children = []}).

start_child(From, Name) ->
	?MODULE ! {From, start_child, Name}.
stop_child(From, Name) ->
	?MODULE ! {From, stop_child, Name}.
get_names(From) ->
	?MODULE ! {From, get_names}.


loop(#state{children = Children} = State) ->
	process_flag(trap_exit, true),
	receive
		{From, start_child, Name} ->
			case proplists:is_defined(Name, Children) of
				true ->
					From ! {err, name_already_exist},
					NewL = State;
				false ->
					Pid = keylist:start_link(Name),
					From ! {ok, Pid},
					NewL = [{Name, Pid} | Children]
			end,
			loop(#state{children = NewL});
		{From, stop_child, Name} ->
			case proplists:is_defined(Name, Children) of
				true ->
					exit(whereis(Name), bye),
					unregister(Name),
					From ! {ok},
					NewL = proplists:delete(Name, Children);
				false ->
					From ! {err, such_name_does_not_exist},
					NewL = State
				end,
		loop(#state{children = NewL});

		{From, get_names} ->
			From ! {ok, Children},
			loop(#state{children = State});

		{'EXIT', Pid, Reason} ->

			Ans = lists:filtermap(fun ({KeyF, ValF}) ->
				case Pid of
					ValF ->
						{true, KeyF};
					_ ->
						false
				end

				end, Children),
			io:format('start'),
			io:format('~p~n', [Ans]),
			case Ans of
				[H | _T] -> NewL = proplists:delete(H, Children),
					io:format('Process ~p failed. Reason: ~p~n', [Pid, Reason]),
					loop(#state{children = NewL});
				[] -> loop(State)
			end;
		_ ->
			loop(State)
	end.

start() ->
	{Pid, MonitorRef} = spawn_monitor(?MODULE, loop, [#state{}]),
	register(?MODULE, Pid),
	{Pid, MonitorRef}.


