-module(mod_syslog).
-author('mathieu@garambrogne.net').

-behavior(gen_mod).

-include("ejabberd.hrl").
-include("jlib.hrl").


-export([
	start/2,
	stop/1
]).

start(Host, Opts) ->
	application:start(syslog),
	syslog:send(ejabberd, info, "starting mod_syslog"),
	ok.
	
stop(Host) ->
	syslog:send(ejabberd, info, "stopping mod_syslog"),
	ok.