
fx_version "cerulean"
game "gta5"
lua54 "yes"

author "fashion.demon"
version "1.0.0"

shared_script "@ox_lib/init.lua"

server_scripts {
    "config.lua",
    "server/*.lua",
}

client_scripts {
    "config.lua",
    "client/*.lua",
}

file "locales/*.json"
ox_lib "locale"
