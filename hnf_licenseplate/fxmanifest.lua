fx_version "cerulean"
game "gta5"
lua54 "yes"

author "heldernf"
description "Plate Generator | Custom resource for Habbon"
version "0.0.1"

files {
    "config/shared.lua",
    "locales/*.lua"
}

shared_scripts {
    "@hnf_lib/imports/init.lua",
    "core/validateSystem/shared.lua",
	"@ox_lib/init.lua",
    "global/shared.lua",
    "utils/**/shared.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "modules/**/server.lua",
}

client_scripts {
    "modules/**/client.lua",
}

dependencies {
    "oxmysql",
    "ox_lib",
}

escrow_ignore {
    "config/*.lua",
    "locales/*.lua"
}