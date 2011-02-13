Syslog for Ejabberd
===================


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