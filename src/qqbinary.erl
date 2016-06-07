-module(qqbinary).
-export([bin_endswith/2]).

%% @doc 从binary的末尾匹配串
-spec bin_endswith(binary(), binary())->true|false.
bin_endswith(Subject, Pattern)->
    S = size(Subject),
    P = size(Pattern),
    case P>S of
        true ->
            false;
        _ ->
            Last = binary:part(Subject, {S, -P}),
            case binary:match(Last, Pattern) of
                nomatch ->
                    false;
                _ ->
                    true
            end
    end.

