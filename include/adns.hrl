-ifndef(LIBERL_INCLUDE_HRL).
-define(LIBERL_INCLUDE_HRL, ok).

-define(B(F), lager:log(info, "tag", "~p:~p ~p", [?MODULE, ?LINE, F])).
-define(U(F), unicode:characters_to_binary(F)).

-define(GETVALUE(K, L), proplists:get_value(K, L)).
-define(GETVALUES(K, L), binary_to_list(proplists:get_value(K, L))).
-define(B64(F), base64:encode(F)).

-define(HTTP_OK(F), j:json(F, j:jsonOk())).
-define(HTTP_FAILED(F), j:json(F, j:jsonFailed())).


-define(JSON(F), binary_to_list(list_to_binary(mochijson2:encode(F)))).
-define(JSON_DECODE(F), mochijson2:decode(F)).

-define(HTTP_MSG(F, Msg), j:json(F, j:jsonMessage(io_lib:format("~p", [Msg])))).
-define(HTTP_JSON(F, Msg), j:json(F, Msg)).

-define(HTTP_LINE(F, LINE), h:http_show_s(F, LINE)).

-define(HTOB(F), hex:hexstr_to_bin(F)).
-define(BTOH(F), hex:bin_to_hexstr(F)).
-define(CHECK(F, R), ancode_utils:checkError(F, Reason)).

-endif.
