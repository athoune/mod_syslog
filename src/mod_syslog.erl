-module(mod_syslog).
-author('mathieu@garambrogne.net').

-behavior(gen_mod).

-include("ejabberd.hrl").
-include_lib("syslog/src/syslog.hrl").
-include("jlib.hrl").


-export([
	start/2,
	stop/1,
	user_available/1,
	presence_update/4,
	register_connection/3,
	remove_connection/3
]).

start(Host, Opts) ->
	?INFO_MSG("options ~p", [Opts]),
	?INFO_MSG("elements ~p", [element(2, lists:keyfind(modules, 1, Opts))]),
	application:start(syslog),
	?SYSLOG_INFO(ejabberd, "starting mod_syslog", []),
	lists:foreach(fun(Elem)->
		?INFO_MSG("element ~p", [Elem]),
		case Elem of
			connection ->
				ejabberd_hooks:add(sm_register_connection_hook, Host,
						?MODULE, register_connection, 50),
				ejabberd_hooks:add(sm_remove_connection_hook, Host,
					?MODULE, remove_connection, 50),
					?SYSLOG_INFO(ejabberd, "mod_syslog enabling connection module", []);
			presence ->
				ejabberd_hooks:add(user_available_hook, Host,
					?MODULE, user_available, 50),
				ejabberd_hooks:add(unset_presence_hook, Host,
					?MODULE, presence_update, 50),
				?SYSLOG_INFO(ejabberd, "mod_syslog enabling presence module", []);
			_ -> ok
		end
	end, element(2, lists:keyfind(modules, 1, Opts))),
	
	ok.

stop(_Host) ->
	?SYSLOG_INFO(ejabberd, "stopping mod_syslog", []),
	ok.

user_available(#jid{luser = LUser, lserver = LServer} = _JID) ->
	?SYSLOG_INFO(ejabberd, "~s@~s is available" , [LUser, LServer]),
	ok.

presence_update(User, Server, Resource, Status) ->
	?SYSLOG_INFO(ejabberd, "~s@~s/~s is ~s", [User, Server, Resource, Status]),
	ok.

register_connection(_SID, JID, Info) ->
	%%dict:fetch(ip, Info)
	IP = element(1,element(2,lists:keyfind(ip, 1, Info))),
	?SYSLOG_INFO(ejabberd, "~s open connection from ~B.~B.~B.~B", [
	    jlib:jid_to_string(JID), element(1, IP), element(2, IP), element(3, IP), element(4, IP)]),
	ok.

remove_connection(_SID, JID, _Info) ->
	?SYSLOG_INFO(ejabberd, "~s close connection", [jlib:jid_to_string(JID)]),
	%% ++ io_lib:format(" ~p", [SID])
	%% ++ " close connection " ++ SID ++ " : " ++ Info),
	ok.
