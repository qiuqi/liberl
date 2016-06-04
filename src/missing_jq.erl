-module(missing_jq).
-export([test/1]).
-export([getItem/2, setItem/3]).
-export([setKey/4]).
-include("liberl.hrl").

test(_Req)->
        ok.

%% KeyPath = [<<"router">>, <<"ipTunnel">>, <<"allowedConnections">>]
setKey(Json, KeyPath, 1, Value)->
        [Key] = KeyPath,
        setItem(Json, Key, Value);

setKey(Json, KeyPath, Len, Value)->
        [H|T] = KeyPath, 
        {struct, NewJson} = s:gv(H, Json), 
        setItem(Json, H, setKey(NewJson, T, Len-1, Value)).


setItem(List, Key, Value)->
        lists:keyreplace(Key, 1, List, {Key, Value}).


getItem(Json, [])->
        Json;

getItem(Json, KeyPath)->
        {struct, NewJson} = Json,
        [H|T] = KeyPath,
%%        ?B([H, NewJson]),
        Item = s:gv(H, NewJson),
        getItem(Item, T).

