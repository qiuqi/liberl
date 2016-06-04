-module(qqjson).
-export([json/2]).
-export([recv/1]).
-export([jsonOk/0]).
-include("liberl.hrl").

jsonOk()->
        {struct, 
         [
          {"type", ?U("Accept")},
          {"time", ?U(utils:longtime())},
          {"value", true}
         ]}.

json(Req, Json)->
        Re = binary_to_list(list_to_binary(mochijson2:encode(Json))),
%%        ?B([json, Json]),
        Req:ok({"application/json;charset=UTF-8", [], Re}).

recv(Req)->
        Data = Req:recv_body(),
        ?JSON_DECODE(Data).
