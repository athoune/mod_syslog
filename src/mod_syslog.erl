-module(mod_syslog).
-author('mathieu@garambrogne.net').

-behavior(gen_mod).

-include("ejabberd.hrl").
-include("jlib.hrl").


-export([
	start/2,
	stop/1,
	user_available/1,
	presence_update/4
]).

start(Host, _Opts) ->
	application:start(syslog),
	syslog:send(ejabberd, info, "starting mod_syslog"),
	ejabberd_hooks:add(user_available_hook, Host,
		?MODULE, user_available, 50),
	ejabberd_hooks:add(unset_presence_hook, Host,
		?MODULE, presence_update, 50),
	ok.

stop(_Host) ->
	syslog:send(ejabberd, info, "stopping mod_syslog"),
	ok.

user_available(#jid{luser = LUser, lserver = LServer} = _JID) ->
	syslog:send(ejabberd, info, LUser ++ "@" ++ LServer ++ " is available"),
	ok.

presence_update(User, Server, Resource, Status) ->
	syslog:send(ejabberd, info, User ++ "@" ++ Server ++ "/" ++ Resource ++ " is " ++ Status),
	ok.