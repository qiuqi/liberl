-module(s).
-export([b64/1]).
-export([gv/2, gvs/2]).


gv(K, L)->
        proplists:get_value(K,L).

gvs(K,L)->
        binary_to_list(proplists:get_value(K, L)).

b64(F)->
        base64:encode(F).
