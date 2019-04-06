version = 3
ScenarioInfo = {
    name = 'Nomads Mission 3 - Frosty Winds',
    description = 'Develop version',
    type = 'campaign_coop',
    starts = true,
    preview = '',
    size = {1024, 1024},
    map = '/maps/NMCA_003/NMCA_003.scmap',
    save = '/maps/NMCA_003/NMCA_003_save.lua',
    script = '/maps/NMCA_003/NMCA_003_script.lua',
    map_version = 1,
    norushradius = 0.000000,
    Configurations = {
        ['standard'] = {
            teams = {
                { name = 'FFA', armies = {'Player1','Aeon','Crashed_Ship','Aeon_Neutral','Crystals','Player2','Player3',} },
            },
            customprops = {
            },
            factions = { {'nomads'}, {'nomads'}, {'nomads'} },
        },
    }}
