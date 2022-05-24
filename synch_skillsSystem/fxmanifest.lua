fx_version 'cerulean'
game 'gta5'

name "synch_skillsSystem"
description "Skill System for Gta"
author "Synchrer"
version "0.5.0"

shared_scripts {
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}