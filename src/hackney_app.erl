%%% -*- erlang -*-
%%%
%%% This file is part of hackney released under the Apache 2 license.
%%% See the NOTICE for more information.
%%%
%%% Copyright (c) 2012-2014 Benoît Chesneau <benoitc@e-engura.org>
%%%

-module(hackney_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1,
         ensure_deps_started/0,
         get_app_env/1, get_app_env/2]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    _ = ensure_deps_started(),
    hackney_sup:start_link().

stop(_State) ->
    ok.


ensure_deps_started() ->
    {ok, Deps} = application:get_key(hackney, applications),
    _ = [ensure_started(A) || A <- Deps],
    ok.

ensure_started(App) ->
    case application:start(App) of
        ok -> ok;
        {error, {already_started, App}} -> ok
    end.


%% @doc return a config value
get_app_env(Key) ->
    get_app_env(Key, undefined).

%% @doc return a config value
get_app_env(Key, Default) ->
    case application:get_env(hackney, Key) of
        {ok, Val} -> Val;
        undefined -> Default
    end.
