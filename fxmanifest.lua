fx_version 'cerulean'
game 'gta5'

author 'Opto Studios'
description 'Opto-Studios Police Dispatch'
version '2.0.0'

client_scripts {
    'client/c-main.lua',
    'client/c-core.lua',
}

server_scripts {
    'server/s-main.lua',
    'server/s-core.lua',
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
    'ui/js/draggable.js',
    'ui/assets/*.svg'
}
