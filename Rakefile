EJAB_SRC = '/usr/local/Cellar/ejabberd/2.1.5'
INCLUDE = '/usr/local/Cellar/ejabberd/2.1.5/lib/ejabberd/include'
EBIN = '/usr/local/Cellar/ejabberd/2.1.5/lib/ejabberd/ebin/'
task :compile do
	sh "erlc -pa #{EJAB_SRC} -I #{EJAB_SRC} -I #{INCLUDE} src/mod_syslog.erl"
end

task :install => :compile do
	sh "cp mod_syslog.beam #{EBIN}"
end