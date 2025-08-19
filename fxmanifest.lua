fx_version "cerulean"

description "An MMO inspired HUD"
author "solaire"
version '1.0.0'
repository 'https://github.com/solaire-fivem/solaire-hud'

lua54 'yes'

game "gta5"

ui_page 'web/build/index.html'

shared_script "config.lua"

client_scripts {
    "client/*",
    "functions/*",
    "bridge/shared.lua",
}

files {
	'web/build/index.html',
	'web/build/**/*',
}

dependencies {
  'community_bridge',
  'MugShotBase64',
}