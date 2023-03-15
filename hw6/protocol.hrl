
-record(ipv4, {
  	version,
	ihl,
	tos,
	total_length,
	identification,
	flags,
	fragment_offset,
	ttl,
	protocol,
	header_checksum,
	src,
	dest,
	options,
	data
  }).
