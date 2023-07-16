-module(read_file_ffi).
-export([read_file/1]).

read_file(FileName) ->
	file:read_file(FileName).

