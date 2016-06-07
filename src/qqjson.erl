-module(qqjson).
-export([json/2]).
-export([recv/1]).
-export([jsonOk/1]).
-include("liberl.hrl").

jsonOk(Req)->
    Json = {struct, 
            [
                {"type", ?U("Accept")},
                {"time", ?U(qqtime:longtime())},
                {"value", true}
                ]},
    json(Req, Json).

json(Req, Json)->
    Re = binary_to_list(list_to_binary(mochijson2:encode(Json))),
    %%        ?B([json, Json]),
    Req:ok({"application/json;charset=UTF-8", [], Re}).

recv(Req)->
    Data = Req:recv_body(),
    ?JSON_DECODE(Data).
