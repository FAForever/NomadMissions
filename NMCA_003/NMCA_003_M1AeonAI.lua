local BaseManager = import('/lua/ai/opai/basemanager.lua')
local CustomFunctions = '/maps/NMCA_003/NMCA_003_CustomFunctions.lua'
local SPAIFileName = '/lua/ScenarioPlatoonAI.lua'

---------
-- Locals
---------
local Aeon = 2
local Difficulty = ScenarioInfo.Options.Difficulty

----------------
-- Base Managers
----------------
local AeonM1Base = BaseManager.CreateBaseManager()

---------------
-- Aeon M1 Base
---------------
function AeonM1BaseAI()
    AeonM1Base:InitializeDifficultyTables(ArmyBrains[Aeon], 'M1_Aeon_Base', 'M1_Aeon_Base_Marker', 80, {M1_Aeon_Base = 100, M1_Aeon_Base_Defenses = 90})
    AeonM1Base:StartNonZeroBase({{3, 4, 5}, {3, 3, 3}})
    AeonM1Base:SetActive('AirScouting', true)
    AeonM1Base:SetActive('LandScouting', true)

    AeonM1BaseAirAttacks()
    AeonM1BaseLandAttacks()
    AeonM1BaseNavalAttacks()
end

function AeonM1BaseAirAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ----------
    -- Attacks
    ----------
    -- Send 3 Bombers if player has more than 13, 10, 7 Pgens
    trigger = {13, 10, 7}
    opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Air_Attack_Chain_Middle'
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Bombers', 3)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ENERGYPRODUCTION, '>='})

    -- Send 3 Bombers / Gunships if player has more than 6 Mexes
    opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Air_Attack_Chain_Middle',
                    'M1_Aeon_Air_Attack_Chain_West',
                    'M1_Aeon_Air_Attack_Chain_East',
                },
            },
            Priority = 110,
        }
    )
    if Difficulty <= 2 then
        opai:SetChildQuantity('Bombers', 3)
    else
        opai:SetChildQuantity('Gunships', 3)
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 6, categories.MASSEXTRACTION, '>='})

    -- Send 3, 3, 6 Interceptors if player has more than 80, 70, 60 units
    quantity = {3, 3, 6}
    trigger = {8, 6, 4}
    opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Air_Attack_Chain_Middle',
                    'M1_Aeon_Air_Attack_Chain_West',
                    'M1_Aeon_Air_Attack_Chain_East',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})

    -- Send 3, 3, 6 Bombers if player has more than 70, 60, 50 units
    quantity = {3, 3, 6}
    trigger = {70, 60, 50}
    opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Air_Attack_Chain_Middle',
                    'M1_Aeon_Air_Attack_Chain_West',
                    'M1_Aeon_Air_Attack_Chain_East',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    -- Send 3 Gunships if player has more than 3, 2, 1 T2 units
    trigger = {3, 2, 1}
    opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Air_Attack_Chain_Middle',
                    'M1_Aeon_Air_Attack_Chain_West',
                    'M1_Aeon_Air_Attack_Chain_East',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('Gunships', 3)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.TECH2, '>='})

    -- Send 3, 3, 6 CombatFighters if player has more than 10, 8, 12 T2 units
    quantity = {3, 3, 6}
    trigger = {10, 8, 12}
    opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirAttack_6',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Air_Attack_Chain_Middle',
                    'M1_Aeon_Air_Attack_Chain_West',
                    'M1_Aeon_Air_Attack_Chain_East',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})

    -- Send 6, 6, 9 Gunships if player has more than 12, 10, 8 T2 units
    quantity = {6, 6, 9}
    trigger = {12, 10, 8}
    opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirAttack_7',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Air_Attack_Chain_Middle',
                    'M1_Aeon_Air_Attack_Chain_West',
                    'M1_Aeon_Air_Attack_Chain_East',
                },
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.TECH2, '>='})

    -- Mercy snipe on medium and hard difficulty
    if Difficulty >= 2 then
        quantity = {0, 3, 6}
        opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirAttack_8',
            {
                MasterPlatoonFunction = {CustomFunctions, 'MercyThread'},
                PlatoonData = {
                    Distance = 100,
                    Base = 'M1_Aeon_Base',
                    PatrolChain = 'M1_Aeon_Air_Attack_Chain_Middle',
                },
                Priority = 150,
            }
        )
        opai:SetChildQuantity('GuidedMissiles', quantity[Difficulty])
        opai:AddBuildCondition(CustomFunctions, 'PlayersACUsNearBase', {'default_brain', 'M1_Aeon_Base', 100})
    end

    ----------
    -- Defense
    ----------
    quantity = {1, 2, 2}
    for i = 1, quantity[Difficulty] do
        opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirDefense_1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M1_Aeon_Base_Air_Patrol_Chain',
                },
                Priority = 80 + 10 * i,
            }
        )
        opai:SetChildQuantity('Bombers', 3)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

        opai = AeonM1Base:AddOpAI('AirAttacks', 'M1_Aeon_AirDefense_2_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M1_Aeon_Base_Air_Patrol_Chain',
                },
                Priority = 80 + 10 * i,
            }
        )
        opai:SetChildQuantity('Interceptors', 3)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end
end

function AeonM1BaseLandAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    -- Engineer for reclaiming if there's less than 2000 Mass in the storage, starting after 5 minutes
    quantity = {3, 4, 5}
    opai = AeonM1Base:AddOpAI('EngineerAttack', 'M1_Aeon_Reclaim_Engineers_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Air_Attack_Chain_Middle',
                    'M1_Aeon_Naval_Atttack_Chain',
                    'M1_Aeon_Air_Attack_Chain_East',
                    'M1_Aeon_Base_EngineerChain',
                    'M1_Aeon_Base_Reclaim_Chain',
                },
            },
            Priority = 190,
        }
    )
    opai:SetChildQuantity('T1Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 2000})
    opai:AddBuildCondition('/lua/editor/miscbuildconditions.lua', 'GreaterThanGameTime', {'default_brain', 300})

    -- Engineer for reclaiming if there's less than 1000 Mass in the storage, starting after 5 minutes
    quantity = {3, 5, 6}
    opai = AeonM1Base:AddOpAI('EngineerAttack', 'M1_Aeon_Reclaim_Engineers_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Air_Attack_Chain_Middle',
                    'M1_Aeon_Naval_Atttack_Chain',
                    'M1_Aeon_Air_Attack_Chain_East',
                    'M1_Aeon_Base_EngineerChain',
                    'M1_Aeon_Base_Reclaim_Chain',
                },
            },
            Priority = 200,
        }
    )
    opai:SetChildQuantity('T1Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 1000})
    opai:AddBuildCondition('/lua/editor/miscbuildconditions.lua', 'GreaterThanGameTime', {'default_brain', 300})

    ----------
    -- Attacks
    ----------
    -- Sends 3, 6, 9 Labs
    quantity = {3, 6, 9}
    opai = AeonM1Base:AddOpAI('BasicLandAttack', 'M1_Aeon_LandAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Land_Atttack_Chain'
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('LightBots', quantity[Difficulty])

    -- Sends 3, 6, 9 Auroras if player has more than 8, 10, 12 units
    quantity = {3, 6, 9}
    trigger = {8, 10, 12}
    opai = AeonM1Base:AddOpAI('BasicLandAttack', 'M1_Aeon_LandAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M1_Aeon_Land_Atttack_Chain',
                    'M1_Aeon_Air_Attack_Chain_East',
                    'M1_Aeon_Air_Attack_Chain_West',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    -- Send 3, 6, 9 Arties if player has more than 16, 18, 20 units 
    quantity = {3, 6, 9}
    trigger = {16, 18, 20}
    opai = AeonM1Base:AddOpAI('BasicLandAttack', 'M1_Aeon_LandAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Land_Atttack_Chain'
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    -- Send 3 Obsidians if player has more than 50 units
    if Difficulty >= 3 then
        opai = AeonM1Base:AddOpAI('BasicLandAttack', 'M1_Aeon_LandAttack_4',
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M1_Aeon_Land_Atttack_Chain'
                },
                Priority = 120,
            }
        )
        opai:SetChildQuantity('HeavyTanks', 3)
        opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 50, categories.ALLUNITS - categories.WALL, '>='})
    end

    -- Sends 3 T1, T2 Tanks if player has more than 7, 5, 3 T2 units
    trigger = {7, 5, 3}
    opai = AeonM1Base:AddOpAI('BasicLandAttack', 'M1_Aeon_LandAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Land_Atttack_Chain'
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity({'LightTanks', 'HeavyTanks'}, 6)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.TECH2, '>='})

    -- Sends 3, 6, 6 T1, T2 Tanks if player has more than 7, 5, 3 T2 units
    quantity = {6, 12, 12}
    trigger = {10, 8, 6}
    opai = AeonM1Base:AddOpAI('BasicLandAttack', 'M1_Aeon_LandAttack_6',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Land_Atttack_Chain'
            },
            Priority = 140,
        }
    )
    opai:SetChildQuantity({'LightTanks', 'HeavyTanks'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.TECH2, '>='})

    -- Sends 3, 6, 6 MMLs if player has more than 7, 5, 3 T2 defenses
    quantity = {3, 6, 6}
    trigger = {7, 5, 3}
    opai = AeonM1Base:AddOpAI('BasicLandAttack', 'M1_Aeon_LandAttack_7',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Land_Atttack_Chain'
            },
            Priority = 140,
        }
    )
    opai:SetChildQuantity('MobileMissiles', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.TECH2 * categories.DEFENSE, '>='})

    -- Sends 3, 6, 6 MMLs if player has more than 7, 5, 3 T2 defenses
    quantity = {6, 9, 12}
    trigger = {18, 16, 14}
    opai = AeonM1Base:AddOpAI('BasicLandAttack', 'M1_Aeon_LandAttack_8',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Land_Atttack_Chain'
            },
            Priority = 140,
        }
    )
    opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.TECH2, '>='})
end

function AeonM1BaseNavalAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ----------
    -- Attacks
    ----------
    -- Send 2 Frigates if players have more than 1 Naval factory
    opai = AeonM1Base:AddOpAI('NavalAttacks', 'M1_Aeon_NavalAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Naval_Atttack_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Frigates', 2)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 1, categories.NAVAL * categories.FACTORY, '>='})

    -- Send 2, 2, 4 Frigates if players have mora than 4, 3, 2 T1 Naval units
    quantity = {2, 2, 4}
    trigger = {4, 3, 2}
    opai = AeonM1Base:AddOpAI('NavalAttacks', 'M1_Aeon_NavalAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Naval_Atttack_Chain',
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Frigates', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    -- Send 4, 4, 6 Frigates and 0, 2, 2 Submarines if players have mora than 8, 6, 4 T1 Naval units
    quantity = {4, {4, 2}, {6, 2}}
    trigger = {8, 6, 4}
    opai = AeonM1Base:AddOpAI('NavalAttacks', 'M1_Aeon_NavalAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Naval_Atttack_Chain',
            },
            Priority = 120,
        }
    )
    if Difficulty >= 2 then
        opai:SetChildQuantity({'Frigates', 'Submarines'}, quantity[Difficulty])
    else
        opai:SetChildQuantity('Frigates', quantity[Difficulty])
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    ----------
    -- Defense
    ----------
    -- Up to 3x 2 Frigates and 2 Submarines patrolling around AI base
    for i = 1, Difficulty do
        opai = AeonM1Base:AddOpAI('NavalAttacks', 'M1_Aeon_NavalDefense_1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M1_Aeon_Base_Naval_Patrol_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity({'Frigates', 'Submarines'}, 4)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    -- Patrols 2, 2, 4 AA Boats
    quantity = {2, 2, 4}
    opai = AeonM1Base:AddOpAI('NavalAttacks', 'M1_Aeon_NavalDefense_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M1_Aeon_Base_Naval_Patrol_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('AABoats', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
end

