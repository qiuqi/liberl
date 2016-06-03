-module(s).
-export([b64/1]).
-export([g_v/2, g_vs/2]).


g_v(K, L)->
        proplists:get_value(K,L).

g_vs(K,L)->
        binary_to_list(proplists:get_value(K, L)).

b64(F)->
        base64:encode(F).
