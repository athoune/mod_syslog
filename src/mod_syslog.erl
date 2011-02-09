-module(mod_syslog).
-author('mathieu@garambrogne.net').

-behavior(gen_mod).

-include("ejabberd.hrl").
-include("jlib.hrl").


-export([
	start/2,
	stop/1,
	user_available/1,
	presence_update/4,
	register_connection/3,
	remove_connection/3
]).

start(Host, _Opts) ->
	application:start(syslog),
	syslog:send(ejabberd, info, "starting mod_syslog"),
	ejabberd_hooks:add(user_available_hook, Host,
		?MODULE, user_available, 50),
	ejabberd_hooks:add(unset_presence_hook, Host,
		?MODULE, presence_update, 50),
	ejabberd_hooks:add(sm_register_connection_hook, Host,
			?MODULE, register_connection, 50),
	ejabberd_hooks:add(sm_remove_connection_hook, Host,
		?MODULE, remove_connection, 50),
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

register_connection(SID, JID, Info) ->
	?INFO_MSG("SID ~p", [SID]),
	?INFO_MSG("JID ~p", [JID]),
	?INFO_MSG("Info ~p", [Info]),
	%%dict:fetch(ip, Info)
	syslog:send(ejabberd, info, jlib:jid_to_string(JID) ++ io_lib:format(" open connection from ~p", [element(1,element(2,lists:keyfind(ip, 1, Info)))])),
	ok.

remove_connection(SID, JID, Info) ->
	syslog:send(ejabberd, info, jlib:jid_to_string(JID) ++ " close connection" ++ io_lib:format(" ~p", [SID])),
	%% ++ " close connection " ++ SID ++ " : " ++ Info),
	ok.
