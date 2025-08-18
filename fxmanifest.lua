fx_version "cerulean"

description "A world of warcraft inspired player and vehicle HUD"
author "solaire"
version '1.0.0'
repository ''

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page 'web/build/index.html'

shared_script "config.lua"

client_scripts {
    "client/functions.lua",
    "client/client.lua",
    "client/utils.lua",
    "client/events.lua",
}

files {
	'web/build/index.html',
	'web/build/**/*',
}