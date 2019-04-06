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
local AeonM2NorthBase = BaseManager.CreateBaseManager()
local AeonM2SouthBase = BaseManager.CreateBaseManager()

----------------
-- Attack Chains
----------------
local SouthNavalLoc = false
local NavalAttackChains = {
    AeonM2NorthBase = {
        {
            'M2_Aeon_North_Base_Naval_Attack_Chain_1',
            'M2_Aeon_North_Base_Naval_Attack_Chain_2',
            'M2_Aeon_North_Base_Naval_Attack_Chain_3',
        },
        {
            'M2_Aeon_North_Base_Naval_Attack_Chain_4',
            'M2_Aeon_North_Base_Naval_Attack_Chain_5',
        },  
    },
    AeonM2SouthBase = {
        {
            'M2_Aeon_South_Base_Naval_Attack_Chain_1',
            'M2_Aeon_South_Base_Naval_Attack_Chain_2',
        },
        {
            'M2_Aeon_South_Base_Naval_Attack_Chain_3',
            'M2_Aeon_South_Base_Naval_Attack_Chain_4',
            'M2_Aeon_South_Base_Naval_Attack_Chain_5',
        },  
    },
}

---------------------
-- Aeon M2 North Base
---------------------
function AeonM2NorthBaseAI(location)
    AeonM2NorthBase:InitializeDifficultyTables(ArmyBrains[Aeon], 'M2_Aeon_North_Base', 'M2_Aeon_North_Base_Marker', 120, {M2_Aeon_North_Base = 100, M2_North_Base_Defenses = 90})
    AeonM2NorthBase:StartNonZeroBase({{9, 12, 15}, {8, 10, 12}})
    AeonM2NorthBase:SetMaximumConstructionEngineers(3)
    AeonM2NorthBase:SetActive('AirScouting', true)
    AeonM2NorthBase:SetActive('LandScouting', true)

    -- Naval factories are either west (1) or south (2) of the main base
    local num = 1
    if location == 'SouthNaval' then
        num = 2
    end

    AeonM2NorthBase:AddBuildGroup('M2_North_Naval_Base_' .. num, 100, true)
    AeonM2NorthBase:AddBuildGroupDifficulty('M2_North_Naval_Base_' .. num .. '_Defenses', 90, true)

    AeonM2NorthBaseAirAttacks()
    AeonM2NorthBaseLandAttacks()
    AeonM2NorthBaseNavalAttacks(num)
end

function AeonM2NorthBaseAirAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ---------
    -- Attack
    ---------
    -- Send 3, 3, 6 CombatFighters if player has more than 10, 8, 12 T2 units
    quantity = {4, 5, 6}
    opai = AeonM2NorthBase:AddOpAI('AirAttacks', 'M2_Aeon_North_Base_AirAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Air_Attack_Chain_1',
                    'M2_Aeon_North_Base_Air_Attack_Chain_2',
                    'M2_Aeon_North_Base_Air_Attack_Chain_3',
                    'M2_Aeon_North_Base_Air_Attack_Chain_4',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])

    -- Send 6, 6, 9 Gunships if player has more than 12, 10, 8 T2 units
    quantity = {4, 5, 6}
    trigger = {120, 110, 100}
    opai = AeonM2NorthBase:AddOpAI('AirAttacks', 'M2_Aeon_North_Base_AirAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Air_Attack_Chain_1',
                    'M2_Aeon_North_Base_Air_Attack_Chain_2',
                    'M2_Aeon_North_Base_Air_Attack_Chain_3',
                    'M2_Aeon_North_Base_Air_Attack_Chain_4',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    -- Send 6, 6, 9 Gunships if player has more than 12, 10, 8 T2 units
    quantity = {4, 5, 6}
    trigger = {10, 11, 12}
    opai = AeonM2NorthBase:AddOpAI('AirAttacks', 'M2_Aeon_North_Base_AirAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Air_Attack_Chain_1',
                    'M2_Aeon_North_Base_Air_Attack_Chain_2',
                    'M2_Aeon_North_Base_Air_Attack_Chain_3',
                    'M2_Aeon_North_Base_Air_Attack_Chain_4',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})

    -- Send 6, 6, 9 Gunships if player has more than 12, 10, 8 T2 units
    quantity = {8, 10, 12}
    trigger = {130, 140, 150}
    opai = AeonM2NorthBase:AddOpAI('AirAttacks', 'M2_Aeon_North_Base_AirAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Air_Attack_Chain_1',
                    'M2_Aeon_North_Base_Air_Attack_Chain_2',
                    'M2_Aeon_North_Base_Air_Attack_Chain_3',
                    'M2_Aeon_North_Base_Air_Attack_Chain_4',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity({'CombatFighters', 'Gunships'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    -- Send 6, 6, 9 Gunships if player has more than 12, 10, 8 T2 units
    quantity = {4, 5, 6}
    trigger = {5, 4, 3}
    opai = AeonM2NorthBase:AddOpAI('AirAttacks', 'M2_Aeon_North_Base_AirAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Air_Attack_Chain_1',
                    'M2_Aeon_North_Base_Air_Attack_Chain_2',
                    'M2_Aeon_North_Base_Air_Attack_Chain_3',
                    'M2_Aeon_North_Base_Air_Attack_Chain_4',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    ----------
    -- Defense
    ----------
    -- Maintains 2x {4, 5, 6} CombatFighters, rebuild if half is destroyed
    quantity = {4, 5, 6}
    for i = 1, 2 do
        opai = AeonM2NorthBase:AddOpAI('AirAttacks', 'M2_Aeon_North_AirDefense_1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M2_Aeon_North_Base_Air_Patrol_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    -- Maintains {4, 5, 6} Gunships, rebuild if half is destroyed
    opai = AeonM2NorthBase:AddOpAI('AirAttacks', 'M2_Aeon_North_AirDefense_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
            PlatoonData = {
                PatrolChain = 'M2_Aeon_North_Base_Air_Patrol_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

    -- Maintains {4, 5, 6} TorpedoBombers, rebuild if half is destroyed
    opai = AeonM2NorthBase:AddOpAI('AirAttacks', 'M2_Aeon_North_AirDefense_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
            PlatoonData = {
                PatrolChain = 'M2_Aeon_North_Base_Air_Patrol_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
end

function AeonM2NorthBaseLandAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    -- Engineer for reclaiming if there's less than 5000 Mass in the storage, starting after 5 minutes
    quantity = {3, 4, 6}
    opai = AeonM2NorthBase:AddOpAI('EngineerAttack', 'M2_Aeon_North_Reclaim_Engineers_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Reclaim_Chain_1',
                    'M2_Aeon_North_Base_Reclaim_Chain_2',
                    'M2_Aeon_North_Base_Amphibious_Chain_1',
                    'M2_Aeon_North_Base_Amphibious_Chain_2',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_2',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_3',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_4',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_5',
                },
            },
            Priority = 190,
        }
    )
    opai:SetChildQuantity('T1Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 5000})

    -- Engineer for reclaiming if there's less than 2000 Mass in the storage, starting after 5 minutes
    quantity = {6, 7, 9}
    opai = AeonM2NorthBase:AddOpAI('EngineerAttack', 'M2_Aeon_North_Reclaim_Engineers_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Reclaim_Chain_1',
                    'M2_Aeon_North_Base_Reclaim_Chain_2',
                    'M2_Aeon_North_Base_Amphibious_Chain_1',
                    'M2_Aeon_North_Base_Amphibious_Chain_2',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_2',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_3',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_4',
                    'M2_Aeon_North_Base_Naval_Attack_Chain_5',
                },
            },
            Priority = 200,
        }
    )
    opai:SetChildQuantity('T1Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 2000})

    ---------
    -- Attack
    ---------
    quantity = {6, 9, 12}
    opai = AeonM2NorthBase:AddOpAI('BasicLandAttack', 'M2_Aeon_North_AmphibiousAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Amphibious_Chain_1',
                    'M2_Aeon_North_Base_Amphibious_Chain_2',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('AmphibiousTanks', quantity[Difficulty])

    quantity = {{6, 2}, {8, 2}, {12, 3}}
    opai = AeonM2NorthBase:AddOpAI('BasicLandAttack', 'M2_Aeon_North_AmphibiousAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Amphibious_Chain_1',
                    'M2_Aeon_North_Base_Amphibious_Chain_2',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileFlak'}, quantity[Difficulty])

    quantity = {{5, 1}, {6, 2}, {10, 2}}
    opai = AeonM2NorthBase:AddOpAI('BasicLandAttack', 'M2_Aeon_North_AmphibiousAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Amphibious_Chain_1',
                    'M2_Aeon_North_Base_Amphibious_Chain_2',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileShields'}, quantity[Difficulty])

    quantity = {{6, 2, 1}, {8, 2, 2}, {10, 2, 3}}
    opai = AeonM2NorthBase:AddOpAI('BasicLandAttack', 'M2_Aeon_North_AmphibiousAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_North_Base_Amphibious_Chain_1',
                    'M2_Aeon_North_Base_Amphibious_Chain_2',
                },
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileFlak', 'MobileShields'}, quantity[Difficulty])
end

function AeonM2NorthBaseNavalAttacks(indexTable)
    local opai = nil
    local quantity = {}
    local trigger = {}

    ----------
    -- Attack
    ----------
    opai = AeonM2NorthBase:AddOpAI('NavalAttacks', 'M2_Aeon_North_Base_NavalAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2NorthBase[indexTable]
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Frigates', 3)

    quantity = {6, 8, 10}
    trigger = {12, 10, 8}
    opai = AeonM2NorthBase:AddOpAI('NavalAttacks', 'M2_Aeon_North_Base_NavalAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2NorthBase[indexTable]
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity({'Frigates', 'Submarines'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    quantity = {6, {6, 3}, {8, 4}}
    trigger = {16, 14, 12}
    opai = AeonM2NorthBase:AddOpAI('NavalAttacks', 'M2_Aeon_North_Base_NavalAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2NorthBase[indexTable]
            },
            Priority = 120,
        }
    )
    if Difficulty <= 1 then
        opai:SetChildQuantity('Frigates', quantity[Difficulty])
    else
        opai:SetChildQuantity({'Frigates', 'Submarines'}, quantity[Difficulty])
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    trigger = {4, 3, 2}
    opai = AeonM2NorthBase:AddOpAI('NavalAttacks', 'M2_Aeon_North_Base_NavalAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2NorthBase[indexTable]
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity('Destroyers', 3)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    opai = AeonM2NorthBase:AddOpAI('NavalAttacks', 'M2_Aeon_North_Base_NavalAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2NorthBase[indexTable]
            },
            Priority = 140,
        }
    )
    if Difficulty >= 3 then
        opai:SetChildQuantity({'Cruisers', 'T2Submarines'}, {1, 4})
    else
        opai:SetChildQuantity('T2Submarines', 3)
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 7, categories.NAVAL * categories.MOBILE, '>='})

    trigger = {70, 60, 50}
    opai = AeonM2NorthBase:AddOpAI('NavalAttacks', 'M2_Aeon_North_Base_NavalAttack_6',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2NorthBase[indexTable]
            },
            Priority = 140,
        }
    )
    opai:SetChildQuantity('Cruisers', 3)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})

    trigger = {7, 6, 5}
    opai = AeonM2NorthBase:AddOpAI('NavalAttacks', 'M2_Aeon_North_Base_NavalAttack_7',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2NorthBase[indexTable]
            },
            Priority = 150,
        }
    )
    if Difficulty >= 3 then
        opai:SetChildQuantity({'Destroyers', 'Cruisers', 'T2Submarines'}, {4, 1, 2})
    else
        opai:SetChildQuantity({'Destroyers', 'T2Submarines'}, {4, 2})
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    quantity = {{4, 4}, {5, 3}, {6, 6}}
    trigger = {14, 12, 10}
    opai = AeonM2NorthBase:AddOpAI('NavalAttacks', 'M2_Aeon_North_Base_NavalAttack_8',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2NorthBase[indexTable]
            },
            Priority = 160,
        }
    )
    opai:SetChildQuantity({'T2Submarines', 'Submarines'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    ----------
    -- Defense
    ----------
    -- M2_Aeon_North_Base_Naval_Defense_Chain
end

---------------------
-- Aeon M2 South Base
---------------------
function AeonM2SouthBaseAI(location)
    AeonM2SouthBase:InitializeDifficultyTables(ArmyBrains[Aeon], 'M2_Aeon_South_Base', 'M2_Aeon_South_Base_Marker', 120, {M2_Aeon_South_Base = 100})
    AeonM2SouthBase:StartNonZeroBase({{7, 9, 11}, {6, 7, 9}})
    AeonM2SouthBase:SetActive('AirScouting', true)
    AeonM2SouthBase:SetActive('LandScouting', true)

    -- Save naval location for later
    SouthNavalLoc = location

    AeonM2SouthBaseAirAttacks()
    AeonM2SouthBaseLandAttacks()
end

function AeonM2SouthBaseStartNavalAttacks()
    local num = 1
    if SouthNavalLoc == 'SouthNaval' then
        num = 2
    end
    AeonM2SouthBase:AddBuildGroup('M2_South_Naval_Base_' .. num, 100)
    --AeonM2SouthBase:AddBuildGroupDifficulty('M2_South_Naval_Base_' .. num .. '_Defenses', 90, true)

    AeonM2SouthBaseNavalAttacks(num)
end

function AeonM2SouthBaseAirAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    opai = AeonM2SouthBase:AddOpAI('EngineerAttack', 'M2_TransportBuilder_South',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                TransportReturn = 'M2_Transport_Return_South',
            },
            Priority = 1000,
        }
    )
    opai:SetChildQuantity('T2Transports', 3)
    opai:SetLockingStyle('None')
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 3, categories.uaa0104})

    ----------
    -- Attacks
    ----------
    quantity = {3, 4, 6}
    opai = AeonM2SouthBase:AddOpAI('AirAttacks', 'M2_Aeon_South_AirAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_South_Base_Land_Attack_Chain',
                    'M2_Aeon_South_Base_Amphibious_Chain_1',

                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])

    quantity = {5, 6, 9}
    opai = AeonM2SouthBase:AddOpAI('AirAttacks', 'M2_Aeon_South_AirAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_South_Base_Land_Attack_Chain',
                    'M2_Aeon_South_Base_Amphibious_Chain_1',

                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])

    ----------
    -- Defense
    ----------
end

function AeonM2SouthBaseLandAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    -- Engineer for reclaiming if there's less than 4000 Mass in the storage, starting after 5 minutes
    quantity = {4, 5, 6}
    opai = AeonM2SouthBase:AddOpAI('EngineerAttack', 'M2_Aeon_South_Reclaim_Engineers_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_South_Base_Reclaim_Chain_1',
                    'M2_Aeon_South_Base_Reclaim_Chain_2',
                    'M2_Aeon_South_Base_Land_Attack_Chain',
                    'M2_Aeon_South_Base_Amphibious_Chain_1',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_2',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_3',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_4',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_5',
                },
            },
            Priority = 190,
        }
    )
    opai:SetChildQuantity('T1Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 4000})

    -- Engineer for reclaiming if there's less than 1000 Mass in the storage, starting after 5 minutes
    quantity = {8, 10, 12}
    opai = AeonM2SouthBase:AddOpAI('EngineerAttack', 'M2_Aeon_South_Reclaim_Engineers_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_South_Base_Reclaim_Chain_1',
                    'M2_Aeon_South_Base_Reclaim_Chain_2',
                    'M2_Aeon_South_Base_Land_Attack_Chain',
                    'M2_Aeon_South_Base_Amphibious_Chain_1',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_2',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_3',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_4',
                    'M2_Aeon_South_Base_Naval_Attack_Chain_5',
                },
            },
            Priority = 200,
        }
    )
    opai:SetChildQuantity('T1Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 1000})

    ----------
    -- Attacks
    ----------
    quantity = {8, 10, 12}
    opai = AeonM2SouthBase:AddOpAI('BasicLandAttack', 'M2_Aeon_South_AmphibiousAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_South_Base_Land_Attack_Chain',
                    'M2_Aeon_South_Base_Amphibious_Chain_1',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('AmphibiousTanks', quantity[Difficulty])

    quantity = {{6, 2}, {8, 2}, {10, 2}}
    opai = AeonM2SouthBase:AddOpAI('BasicLandAttack', 'M2_Aeon_South_AmphibiousAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_South_Base_Land_Attack_Chain',
                    'M2_Aeon_South_Base_Amphibious_Chain_1',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileFlak'}, quantity[Difficulty])

    quantity = {{6, 1}, {8, 2}, {10, 2}}
    opai = AeonM2SouthBase:AddOpAI('BasicLandAttack', 'M2_Aeon_South_AmphibiousAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_South_Base_Land_Attack_Chain',
                    'M2_Aeon_South_Base_Amphibious_Chain_1',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileShields'}, quantity[Difficulty])

    quantity = {{9, 2, 1}, {11, 2, 2}, {14, 2, 2}}
    opai = AeonM2SouthBase:AddOpAI('BasicLandAttack', 'M2_Aeon_South_AmphibiousAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M2_Aeon_South_Base_Land_Attack_Chain',
                    'M2_Aeon_South_Base_Amphibious_Chain_1',
                },
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileFlak', 'MobileShields'}, quantity[Difficulty])

    ----------
    -- Defense
    ----------
end

function AeonM2SouthBaseNavalAttacks(indexTable)
    local opai = nil
    local quantity = {}
    local trigger = {}

    ----------
    -- Attacks
    ----------
    -- Send 3 Frigates
    opai = AeonM2SouthBase:AddOpAI('NavalAttacks', 'M2_Aeon_SouthBase_NavalAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2SouthBase[indexTable],
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Frigates', 3)

    -- Send {2, 1}, {3, 2}, {4, 2} Frigates if players have mora than 4, 6, 8 Naval units
    quantity = {{2, 1}, {3, 2}, {4, 2}}
    trigger = {4, 6, 8}
    opai = AeonM2SouthBase:AddOpAI('NavalAttacks', 'M2_Aeon_SouthBase_NavalAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2SouthBase[indexTable],
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity({'Frigates', 'Submarines'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    -- Send 2, 4, 6 Frigates if players have mora than 4, 6, 8 Naval units
    quantity = {2, 4, 6}
    trigger = {250, 200, 150}
    opai = AeonM2SouthBase:AddOpAI('NavalAttacks', 'M2_Aeon_SouthBase_NavalAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = NavalAttackChains.AeonM2SouthBase[indexTable],
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Frigates', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    ----------
    -- Defense
    ----------
    -- M2_Aeon_South_Base_Naval_Defense_Chain
end

function AeonM2SouthBaseEngineerDrop()
    -- Engineers for bonus objective
    local opai = AeonM2SouthBase:AddOpAI('EngineerAttack', 'M2_AeonOffMapEngineers',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'M4_Aeon_Orbital_Base_South_EngineerChain',
                MovePath = 'M2_Aeon_EngieDrop_Move_Chain',
                LandingList = {'M2_Aeon_Engineers_Drop_Marker'},
            },
            Priority = 500,
        }
    )
    opai:SetChildQuantity('T2Engineers', 4)
    opai:AddFormCallback('/maps/NMCA_003/NMCA_003_script.lua', 'M2DropEngineersPlatoonFormed')
end

