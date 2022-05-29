fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "synch_chemicals"
description "Chemical Mod"
author "Synchrer"
version "0.5.0"

shared_scripts {
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
    '@ox_lib/init.lua',
    '@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}


escrow_ignore {
    --'server/*.lua',  -- Only ignore one file
    --'stream/tuner.ydr', -- Works for any file, stream or code
    --'stream/*.yft',     -- Ignore all .yft files in that folder
    --'stream/**/*.yft'   -- Ignore all .yft files in any subfolder
}