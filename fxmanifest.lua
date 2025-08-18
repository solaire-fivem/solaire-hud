fx_version "cerulean"

description "An MMO inspired HUD"
author "solaire"
version '1.0.0'
repository 'https://github.com/solaire-fivem/solaire-hud'

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

dependencies {
  'community_bridge',
  'MugShotBase64',
}