version = 3
ScenarioInfo = {
    name = 'Nomads Mission 1: First Contact',
    description = '',
    type = 'campaign_coop',
    starts = true,
    preview = '',
    size = {512, 512},
    map = '/maps/NMCA_001/NMCA_001.scmap',
    save = '/maps/NMCA_001/NMCA_001_save.lua',
    script = '/maps/NMCA_001/NMCA_001_script.lua',
    map_version = 1,
    norushradius = 0.000000,
    Configurations = {
        ['standard'] = {
            teams = {
                { name = 'FFA', armies = {'Player1','UEF','Civilian','Nomads','Player2','Player3','Player4',} },
            },
            customprops = {
            },
            factions = { {'nomads'}, {'nomads'}, {'nomads'}, {'nomads'} },
        },
    }}
