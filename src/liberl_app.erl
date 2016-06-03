%% @doc liberl's application module.
%% @private
-module(liberl_app).
-behaviour(application).
-include("liberl.hrl").
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.
-export([start/0,
         start/2,
         stop/1]).

start()->
        application:start(liberl).

start(_StartType, _StartArgs)->
        {ok}.

stop(_Handlers)->
        {ok}.
