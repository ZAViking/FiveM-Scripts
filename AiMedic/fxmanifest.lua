fx_version 'cerulean'
game 'gta5'

-- Resource Metadata
author 'Duncan Smokey'
description 'Description of your resource'
version '1.0.0'

-- Client Scripts
client_scripts {
    'client/client.lua',
    'client/another_client_file.lua'
}

-- Server Scripts
server_scripts {
    'server/server.lua',
    'server/another_server_file.lua'
}

-- Shared Scripts (Optional, for shared configs or utility files)
shared_scripts {
    'shared/config.lua'
}

-- Files to Load (like assets, HTML UI, etc.)
files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

-- Data Files (Optional, for handling custom data like vehicles, weapons, etc.)
data_file 'DLC_ITYP_REQUEST' 'stream/some_model.ytyp'

-- UI Page (if you have a UI component)
ui_page 'ui/index.html'

-- Dependencies (Optional, for other resources your script depends on)
dependencies {
    'some_dependency'
}
