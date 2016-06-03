-module(missing_time).
-export([longtime_int/0]).
-export([longtime/0]).
-export([iso_8601_fmt/1, format_iso8601/0, format_iso8601_local/0]).


longtime_int()->
        {M, S, I} = erlang:timestamp(),
        trunc(M * 1000000000 + S * 1000 + I / 1000).

longtime()->
        integer_to_list(longtime_int()).

iso_8601_fmt(DateTime) ->
        {{Year,Month,Day},{Hour,Min,Sec}} = DateTime,
        iolist_to_binary(
          io_lib:format(
            "~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0wZ",
            [Year, Month, Day, Hour, Min, Sec] )).

format_iso8601_local()->
        iso_8601_fmt(calendar:local_time()).

format_iso8601() ->
        {{Year, Month, Day}, {Hour, Min, Sec}} = calendar:universal_time(),
        iolist_to_binary(
          io_lib:format(
            "~.4.0w-~.2.0w-~.2.0wT~.2.0w:~.2.0w:~.2.0wZ",
            [Year, Month, Day, Hour, Min, Sec] )).



