-module(qqconfig).
-export([init/0]).
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

read(Filename)->
        {ok, ConfigData} = file:read_file(filename(Filename)),
        ?JSON_DECODE(ConfigData).

init()->
        Json = "{\"key1\":\"value1\", \"key2\":\"value2\"}",
        file:write_file(filename(?CONFIG), Json).

read()->
        read(?CONFIG).

%% @doc 获取指定配置文件的值
-spec getItem(string(), list())->binary().
getItem(Filename, Key)->
        qqjq:getItem(qqconfig:read(Filename), Key).


%% @doc 获取配置文件的值
-spec getItem(list())->binary().
getItem(Key)->
        qqjq:getItem(qqconfig:read(), Key).



%%
%% Tests
%%
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-define(D(F), ?debugFmt("~n~p:~p ~p", [?MODULE, ?LINE, F])).
%% 暂时屏蔽这个测试用例，因为无法eunit的时候缺省目录不对
%%init_test()->
%%        init(),
%%        read(),
%%        getItem([<<"key1">>]).

generate_test()->
        Json = "{\"key1\":\"value1\", \"key2\":\"value2\"}",
        ?D(Json),
        file:write_file("test.json", Json).

c_test()->
        ?debugMsg(getItem("/test.json", [<<"key1">>])).

-endif.
