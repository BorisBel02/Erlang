-module(keylist).
-export([loop/1, start/1, start_link/1]).
-record(state, {list = [], counter = 0}).

loop(#state{list = L, counter = C}) ->
	receive
		{From, add, Key, Value, Comment} ->
			NewL = lists:keystore(Key, 1, L, {Key, Value, Comment}),
			From ! {ok, C + 1},
			loop(#state{list = NewL, counter = C + 1});

                {From, is_member, Key} ->
			From ! {lists:keymember(Key, 1, L), C + 1},
			loop(#state{list = L, counter = C + 1});

                {From, take, Key} ->
			take_helper(lists:keytake(Key, 1, L), From, C + 1, L);

                {From, find, Key} ->
			From ! {lists:keyfind(Key, 1, L), C + 1},
			loop(#state{list = L, counter = C + 1});

                {From, delete, Key} ->
			NewL = lists:keydelete(Key, 1, L),
			From ! {ok, counter = C + 1},
			loop(#state{list = NewL, counter = C + 1});
		_ ->
			throw(bad_request)
	end.



take_helper(false, From, C, L) ->
	From ! {false, C},
	loop(#state{list = L, counter = C});

take_helper({_, Tuple, NewL}, From, C, _) ->
	From ! {Tuple, C},
	loop(#state{list = NewL, counter = C}).



start(Name) ->
	Pid = spawn(keylist, loop, [#state{}]),
	register(Name, Pid),
	MonitorRef = monitor(process, Pid),
	{Pid, MonitorRef}.

start_link(Name) ->
	Pid = spawn_link(keylist, loop, [#state{}]),
	register(Name, Pid),
	Pid.
