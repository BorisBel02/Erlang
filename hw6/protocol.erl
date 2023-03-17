-module(protocol).
-include("protocol.hrl").

-export([bin_to_rec/1, ipv4_listener/0]).

bin_to_rec(<<Version:4, IHL:4, ToS:8, TotalLength:16,
	Identification:16, Flags:3, FragOffset:13,
	TimeToLive:8, Protocol:8, Checksum:16,
	SourceAddress:32, DestinationAddress:32,
	OptionsAndPadding:((IHL-5)*32)/bits,
	RemainingData/bytes >>
) when Version =:= 4 ->
	io:format("Received data ~p ~n", [RemainingData]),
	#ipv4{
	  	version = Version,
       		ihl = IHL,
        	tos = ToS,
        	total_length = TotalLength,
        	identification = Identification,
        	flags = Flags,
        	fragment_offset = FragOffset,
        	ttl = TimeToLive,
        	protocol = Protocol,
        	header_checksum = Checksum,
        	src = SourceAddress,
        	dest = DestinationAddress,
        	options = OptionsAndPadding,
        	data = RemainingData
	  };
bin_to_rec(_) ->
	throw(conversion_failed).

ipv4_listener() ->
	receive
		{ipv4, From, BinData} ->
			From ! protocol:bin_to_rec(BinData);
		_ ->
			throw(bad_input)
	end.
