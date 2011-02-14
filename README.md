Syslog for Ejabberd
===================

_mod_syslog_ is a simple ejabberd's module wich listen events and send them to syslogd.

[erlang_syslog](https://github.com/athoune/erlang_syslog) is the erlang application used for syslogd communication.

Build
-----

The Rakefile is hardcoded for macbrew's ejabberd. I'll fix that later.

Config
------

in ejabberd.cfg, in the modules section

	 {mod_syslog, [
		{syslog, {"localhost", 514, user}},
		{modules, [presence, connection, muc]}
		]},

For _syslog_, you choose a server, a port, and a facility.

For _modules_, you choose wich events are watched. For now, you can't watch muc events.