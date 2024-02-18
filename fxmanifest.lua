fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'kats1337'

description 'A script that lets you change vehicle licenseplates in exchange for money'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    "scripts/*_cl.lua"
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', --change this if you use some other MySQL script
    "scripts/*_sv.lua"
}