-module(j).
-include_lib("liberl/include/liberl.hrl").
-export([json/2]).
-export([jsonOk/1]).
-export([jsonOkTime/2]).
-export([jsonFailed/1]).
-export([keepalive/1]).
-export([http_show_json/2]).
-export([http_show_json_s/2]).
-export([http_show_xml_s/2]).
-export([http_show_xml/2]).
-export([http_show/4]).

http_show(all, Req, Show, Opts)->
	http_resp:ok(Req, io_lib:format("<b>~s</b>",[Show]), Opts);
http_show(failed, Req, Show, Opts)->
	http_resp:ok(Req, io_lib:format("<b><r>~s</r></b>",[Show]), Opts);
http_show(skey, Req, Skey, Opts)->
	http_show(all, Req, lists:flatten(["<skey>",Skey,"</skey>"]), Opts).

keepalive(Req)->
    http_show_json_s(Req, [{"k", ?U(qqtime:longtime())}]).

http_show_xml(Req, Xml)->
    	http_resp:ok(Req, lists:flatten(Xml)).
	
http_show_xml_s(Req, Xml)->
%%    ?B(io_lib:format("~s~n", [lists:flatten(Xml, "")])),
    cowboy_req:stream_body(io_lib:format("~s~n", [lists:flatten(Xml, "")]), nofin, Req).

http_show_json_s(Req, Json)->
	All = binary_to_list(list_to_binary(mochijson2:encode(Json))),
%%	?B([http_show_json_s, All]),
    cowboy_req:stream_body(All++"\r\n", nofin, Req).

http_show_json(Req, Msg)->
    json(Req, Msg).

json(Req, JsonString)->
    Json = mochijson2:encode(JsonString),
    cowboy_req:reply(200, #{<<"content-type">> => <<"text/json; charset=utf-8">>}, Json, Req),
    {ok, Req, #{}}.

jsonOkTime(Req, Time)->
    Json = {struct,
            [
             {"type", ?U("Accept")},
             {"time", ?U(Time)},
             {"value", true}
            ]},
    json(Req, Json).


jsonOk(Req)->
    Json = {struct,
            [
             {"type", ?U("Accept")},
             {"time", ?U(qqtime:longtime())},
             {"value", true}
            ]},
    json(Req, Json).

jsonFailed(Req)->
    Json = {struct,
     [
      {"type", ?U("Accept")},
      {"time", ?U(qqtime:longtime())},
      {"value", false}
     ]},
    json(Req, Json).

