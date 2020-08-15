version = 3
ScenarioInfo = {
    name = 'Nomads Mission 2: Intervention',
    description = 'Captain, The Infinite war between the UEF, Cybrans, and Aeon must be kept alive. Reports suggest that the UEF is lossing the war, this can not be allowed to happen. If the Cybrans or Aeon win we stand no chance of suriving. We must bring the war back in favor of the UEF, at least for now. To acomplish this task you are being sent to a high value Cybran world. Clear out all hostiles.',
    type = 'campaign_coop',
    starts = true,
    preview = '',
    size = {1024, 1024},
    map = '/maps/NMCA_002/NMCA_002.scmap',
    save = '/maps/NMCA_002/NMCA_002_save.lua',
    script = '/maps/NMCA_002/NMCA_002_script.lua',
    norushradius = 90.000000,
    norushoffsetX_Player1 = 0.000000,
    norushoffsetY_Player1 = 0.000000,
    norushoffsetX_Cybran = 0.000000,
    norushoffsetY_Cybran = 0.000000,
    norushoffsetX_NomadsEnemy = 0.000000,
    norushoffsetY_NomadsEnemy = 0.000000,
    norushoffsetX_UEF = 0.000000,
    norushoffsetY_UEF = 0.000000,
    norushoffsetX_Nomads = 0.000000,
    norushoffsetY_Nomads = 0.000000,
    norushoffsetX_Player2 = 0.000000,
    norushoffsetY_Player2 = 0.000000,
    norushoffsetX_Player3 = 0.000000,
    norushoffsetY_Player3 = 0.000000,
    norushoffsetX_Player4 = 0.000000,
    norushoffsetY_Player4 = 0.000000,
    Configurations = {
        ['standard'] = {
            teams = {
                { name = 'FFA', armies = {'Player1','Cybran','NomadsEnemy','UEF','Nomads','Player2','Player3','Player4',} },
            },
            customprops = {
            },
            factions = { {'nomads'}, {'nomads'}, {'nomads'}, {'nomads'} },
        },
    }}
