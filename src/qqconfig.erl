-module(qqconfig).
-export([read/0, read/1]).
-export([getItem/1, getItem/2]).


%% example: config.json
%% {
%%   "key1":"value1",
%%   "key2":"value2"
%% }  

-include("liberl.hrl").
-define(CONFIG, "/priv/config/config.json").

filename(Filename)->
        {ok, RootDir} = file:get_cwd(),
        RootDir++Filename.

read()->
        read(?CONFIG).

read(Filename)->
        {ok, ConfigData} = file:read_file(filename(Filename)),
        ?B([read, ?JSON_DECODE(ConfigData)]),
        ?JSON_DECODE(ConfigData).

read1(Filename)->
        {ok, ConfigData} = file:read_file(filename(Filename)),
        ConfigData.


%% @doc 获取指定配置文件的值
-spec getItem(string(), list())->string().
getItem(Filename, Key)->
        qqjq:getItem(qqconfig:read(Filename), Key).


%% @doc 获取配置文件的值
-spec getItem(list())->string().
getItem(Key)->
        qqjq:getItem(qqconfig:read(), Key).



%%
%% Tests
%%
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-define(D(F), ?debugFmt("~n~p:~p ~p", [?MODULE, ?LINE, F])).
generate_test()->
        Json = "{\"key1\":\"value1\", \"key2\":\"value2\"}",
        ?D(Json),
        file:write_file("test.json", Json).

c_test()->
        ?debugMsg(getItem("/test.json", [<<"key1">>])).

-endif.
