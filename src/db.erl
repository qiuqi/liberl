-module(db).

%%API
-export([decr/2, del/2, exists/2, expire/3,get/2,hdel/3,
	hexists/3,hget/3,hgetall/2,hkeys/2, hlen/2, hset/4,
	hvals/2,incr/2,info/1,lindex/3,llen/2,
	lpop/2,lrange/2, lrange/4, lrem/4,rpush/3,sadd/3,save/1,scard/2,
	set/3,setex/4,sismember/3,smembers/2,spop/2,srem/3,ttl/2]).
-export([zadd/4, zcard/2, zcount/4, zincrby/4, zrange/4, zrange_by_score/4, zrange_all/4, zrem/3, zscore/3]).

%%-spec decr(DB::atom(), Key::string())->
%% {ok, integer} | 0
decr(Db, Key)->
	case eredis_pool:q(Db, ["DECR", Key]) of
		{ok, Number}->
			list_to_integer(binary_to_list(Number));
		_ ->
			0
	end.

%%-spec del(Db::atom(), Key::string()) ->
%%	{ok,binary} | {error, Reason::binary()}.
del(Db, Key)->
	eredis_pool:q(Db, ["DEL", Key]).

%%-spec exists(Db::atom(), Key::string()) ->
%%	{true | false}.
exists(Db, Key)->
	case eredis_pool:q(Db, ["EXISTS", Key]) of
		{ok, <<"1">>} ->true;
		_ -> false
	end.

%%-spec expire(Db::atom(), Key::string(), Timeout::integer()) ->
%%	{true, false}.
expire(Db, Key, Timeout) ->
	case eredis_pool:q(Db, ["EXPIRE", Key, integer_to_list(Timeout)]) of
		{ok, <<"1">>} -> true;
		_ -> false
	end.

get(Db, Key)->
	case eredis_pool:q(Db, ["GET", Key]) of
		{ok, Result} when Result =/= undefined ->
			Result;
		_ ->
			failed
	end.	

hdel(Db, Key, Field) ->
	case eredis_pool:q(Db, ["HDEL", Key, Field]) of
		{ok, <<"1">>} -> ok;
		_ -> failed
	end.

hexists(Db, Key, Field) ->
	case eredis_pool:q(Db, ["HEXISTS", Key, Field]) of
		{ok, <<"1">>} -> true;
		_ -> false
	end.

hget(Db, Key, Field)->
	case eredis_pool:q(Db, ["HGET", Key, Field]) of
		{ok, Result} when Result =/= undefined ->
			Result;
		_ ->
			failed
	end.

hgetall(Db, Key) ->
	case eredis_pool:q(Db, ["HGETALL", Key]) of 
		{ok, []} -> failed;
		{ok, Result} -> Result;
		_ -> failed
	end.

hkeys(Db, Key) -> 
	case eredis_pool:q(Db, ["HKEYS", Key]) of
		{ok, []} -> failed;
		{ok, Keys} -> Keys;
		_ -> failed
	end.

hlen(Db, Key) ->
	case eredis_pool:q(Db, ["HLEN", Key]) of
		{ok, Number}->
		       list_to_integer(binary_to_list(Number));
		_ ->
			0
	end.

hset(Db, Key, Field, Value)->
	eredis_pool:q(Db, ["HSET", Key, Field, Value]).	

hvals(Db, Key)->
	case eredis_pool:q(Db, ["HVALS", Key]) of
		{ok, []} -> failed;
		{ok, Vals} -> Vals;
		_ -> failed
	end.

incr(Db, Key)->
	case eredis_pool:q(Db, ["INCR", Key]) of
		{ok, Number}->
			list_to_integer(binary_to_list(Number));
		_ ->
			0
	end.

info(Db)->
	case eredis_pool:q(Db, ["INFO"]) of
		{ok, Info} ->
			binary_to_list(Info);
		_ ->
			"Unknow"
	end. 

lindex(Db, Key, Index)->
	%%?B(["lindex", Key, Index]),
	case eredis_pool:q(Db, ["LINDEX", Key, integer_to_list(Index)]) of
		{ok, Result} when Result =/= undefined ->
			Result;
		_ ->
			failed
	end.

llen(Db, Key)->
	case eredis_pool:q(Db, ["LLEN", Key]) of
		{ok, Len}->
			list_to_integer(binary_to_list(Len));
		_ ->
			0
	end.

lpop(Db, Key)->
	case eredis_pool:q(Db, ["LPOP", Key]) of
		{ok, Result} when Result =/= undefined ->
			Result;
		_ ->
			failed
	end.	

lrange(Db, Key, Start, End)->
	case eredis_pool:q(Db, ["LRANGE", Key, Start, End]) of
		{ok, Members} ->
			Members;
		_ -> failed
	end.

lrange(Db, Key)->
	lrange(Db, Key, 0, -1). 


lrem(Db, Key, Count, Value)->
	eredis_pool:q(Db, ["LREM", Key, Count, Value]).

rpush(Db, Key, Value)->
	case eredis_pool:q(Db, ["RPUSH", Key, Value]) of
		{ok, Length}->
			list_to_integer(binary_to_list(Length));
		_ ->
			0
	end.

sadd(Db, Key, Member)->
	case eredis_pool:q(Db, ["SADD", Key, Member]) of
		{ok, _} -> ok;
		_ -> failed
	end.

save(Db) ->
	eredis_pool:q(Db, ["SAVE"]).

scard(Db, Key) ->
	case eredis_pool:q(Db, ["SCARD", Key]) of
		{ok, Length} ->
			list_to_integer(binary_to_list(Length));
		_ ->
			0
	end.

set(Db, Key, Value)->
	%%?B(["set:", Key, Value]),
	case eredis_pool:q(Db, ["SET", Key, Value]) of
		{ok, _} -> ok;
		_ -> failed
	end.

setex(Db, Key, Value, Timeout)->
	%%?B(["setex", Key, Value, Timeout]),
	case eredis_pool:q(Db, ["SETEX", Key, integer_to_list(Timeout), Value]) of
		{ok, _} -> ok;
		_ -> failed
	end.

sismember(Db, Key, Member) ->
	case eredis_pool:q(Db, ["SISMEMBER", Key, Member]) of
		{ok, <<"1">>} ->true;
		_ ->false
	end.

smembers(Db, Key) ->
	case eredis_pool:q(Db, ["SMEMBERS", Key]) of
		{ok, Members} ->
			Members;
		_ -> failed
	end.

spop(Db, Key) ->
	case eredis_pool:q(Db, ["SPOP", Key]) of
		{ok, undefined} ->failed;
		{ok, Value} -> Value;
		_ -> failed
	end.

srem(Db, Key, Member) ->
	case eredis_pool:q(Db, ["SREM", Key, Member]) of
		{ok, <<"1">>} -> ok;
		_ -> failed
	end.

ttl(Db, Key)->
	case eredis_pool:q(Db, ["TTL", Key]) of
		{ok, <<"-1">>} ->-1;
		{ok, Time} -> list_to_integer(binary_to_list(Time));
		_ -> -1
	end.


%%--------------sorted set---------------------
zadd(Db, Key, Score, Member)->
	case eredis_pool:q(Db, ["ZADD", Key, Score, Member]) of
		{ok, _} -> ok;
		_ -> failed
	end.

zcard(Db, Key)->
	case eredis_pool:q(Db, ["ZCARD", Key]) of
		{ok, Length} ->
			list_to_integer(binary_to_list(Length));
		_ ->
			0
	end.

zcount(Db, Key, Min, Max)->
    case eredis_pool:q(Db, ["ZCOUNT", Key, Min, Max]) of
        {ok, Length} ->
            list_to_integer(binary_to_list(Length));
        _ ->
            0
    end.

zincrby(Db, Key, Score, Member)->
	case eredis_pool:q(Db, ["ZINCRBY", Key, Score, Member])	of
		{ok, _} -> ok;
		_ -> failed
	end.

zrange(Db, Key, Start, Stop) ->
	case eredis_pool:q(Db, ["ZRANGE", Key, Start, Stop]) of
		{ok, Members} ->
			Members;
		_ -> failed
	end.

zrange_by_score(Db, Key, Start, Stop) ->
    case eredis_pool:q(Db, ["ZRANGEBYSCORE", Key, Start, Stop]) of
        {ok, Members} ->
            Members;
        _ -> []
    end.

zrange_all(Db, Key, Start, Stop) ->
	case eredis_pool:q(Db, ["ZRANGE", Key, Start, Stop, "WITHSCORES"]) of
		{ok, Members} ->
			Members;
		_ -> failed
	end.


zrem(Db, Key, Member)->
	case eredis_pool:q(Db, ["ZREM", Key, Member]) of
		{ok, <<"1">>} -> ok;
		_ -> failed
	end.

zscore(Db, Key, Member)->
%%	Temp = eredis_pool:q(Db, ["ZSCORE", Key, Member]),
%%	?B(["temp", Temp]),
	case eredis_pool:q(Db, ["ZSCORE", Key, Member]) of
		{ok, undefined} -> failed;
		{ok, Score} -> binary_to_list(Score);
		_ -> failed
	end.





