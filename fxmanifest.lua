fx_version 'cerulean'
game 'gta5'

author 'Opto Studios'
description 'Opto-Studios Police Dispatch'
version '1.0.0'

client_scripts {
    'client/c-main.lua',
}

server_scripts {
    'server/s-main.lua',
}

shared_scripts {
    'config.lua',
    'locale.lua'
}

ui_page 'ui/ui.html'

files {
    'ui/ui.html',
    'ui/css/main.css',
    'ui/js/app.js',
    'ui/assets/*.svg'
}
