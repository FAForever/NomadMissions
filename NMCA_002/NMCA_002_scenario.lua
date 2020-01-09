version = 3
ScenarioInfo = {
    name = 'Nomads Mission 2: The Enemy of My Enemy',
    description = 'Commander, We need to establish a foothold in this region of space, after that last encounter with the group we know as the \'UEF\', We have prepared a similar ACU for your use. We have located a possible planet for a base and are on route right now.',
    type = 'campaign_coop',
    starts = true,
    preview = '',
    size = {1024, 1024},
    map = '/maps/NMCA_002/NMCA_002.scmap',
    save = '/maps/NMCA_002/NMCA_002_save.lua',
    script = '/maps/NMCA_002/NMCA_002_script.lua',
    map_version = 1,
    norushradius = 90.000000,
    Configurations = {
        ['standard'] = {
            teams = {
                { name = 'FFA', armies = {'Player1','Cybran','CybranCivilian','UEF','Nomads','Player2','Player3','Player4',} },
            },
            customprops = {
            },
            factions = { {'nomads'}, {'nomads'}, {'nomads'}, {'nomads'} },
        },
    }}
