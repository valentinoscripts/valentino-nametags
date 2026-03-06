fx_version 'cerulean'

game 'gta5'

author 'valentino'
version '1.0.0'
description 'Configurable nametags with /tognames, /mark/friend, /nmask; ESX/QBCore/QBX compatible; ox_lib notifications.'

lua54 'yes'

shared_script '@ox_lib/init.lua'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib'
}
