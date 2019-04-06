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
local AeonM3MainBase = BaseManager.CreateBaseManager()

---------------
-- Aeon M3 Base
---------------
function AeonM3MainBaseAI()
    AeonM3MainBase:Initialize(ArmyBrains[Aeon], 'M3_Aeon_Main_Base', 'M3_Aeon_Main_Base_Marker', 100,
        {
            M3_Aeon_Main_Base_1 = 200,
            M3_Aeon_Main_Base_2 = 190,
            M3_Aeon_Main_Base_3 = 180,
            M3_Aeon_Main_Base_4 = 170,
            M3_Aeon_Main_Base_5 = 160,
            M3_Aeon_Main_Base_9 = 130,
            M3_Aeon_Main_Base_Def_1 = 120,
            M3_Aeon_Main_Base_Def_2 = 110,
            M3_Aeon_Main_Base_Def_3 = 100,
        }
    )
    local count = {7, 10, 13}
    AeonM3MainBase:StartEmptyBase({7, 10, 13})
    AeonM3MainBase:SetMaximumConstructionEngineers(count[Difficulty] + 1)
    
    AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_Spawn_1', 200, true)

    AeonM3MainBaseAirPatrols()
    AeonM3MainBaseLandPatrols()
    AeonM3MainBaseNavalPatrols()
end

function SpawnGate()
    AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_Spawn_2', 100, true)

    AeonM3MainBase:SetEngineerCount({{8, 11, 14}, {7, 9, 11}})
    AeonM3MainBase:SetMaximumConstructionEngineers(4)
end

function AddLandFactories()
    AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_8', 140)

    AeonM3MainBase:SetEngineerCount({{10, 13, 16}, {9, 11, 13}})
end

function AddAirFactories()
    AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_7', 150)

    AeonM3MainBase:SetEngineerCount({{11, 14, 19}, {10, 12, 16}})
end

function AddNavalFactories()
    AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_10', 150)
    -- And few more land on hard difficulty
    if Difficulty >= 3 then
        AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_6', 140)
        AeonM3MainBase:SetEngineerCount({{14, 18, 23}, {13, 16, 20}})
    else
        AeonM3MainBase:SetEngineerCount({{13, 17, 21}, {12, 15, 18}})
    end
end

function AddDefenses()
    AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_Def_4', 90)
    AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_Def_5', 80)
end

function AddResources()
    AeonM3MainBase:AddBuildGroup('M3_Aeon_Main_Base_11', 120)
end

function DisableBase()
    AeonM3MainBase:BaseActive(false)
end

----------
-- Patrols
----------
function AeonM3MainBaseAirPatrols()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ----------
    -- Defense
    ----------
    -- Maintains 2x {4, 5, 6} CombatFighters, rebuild if half is destroyed
    quantity = {4, 5, 6}
    for i = 1, 2 do
        opai = AeonM3MainBase:AddOpAI('AirAttacks', 'M3_Aeon_Main_Base_AirDefense_1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M3_Aeon_Main_Base_Air_Patrol_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    -- Maintains {4, 5, 6} Gunships, rebuild if half is destroyed
    opai = AeonM3MainBase:AddOpAI('AirAttacks', 'M3_Aeon_Main_Base_AirDefense_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_Aeon_Main_Base_Air_Patrol_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

    -- Maintains {4, 5, 6} TorpedoBombers, rebuild if half is destroyed
    opai = AeonM3MainBase:AddOpAI('AirAttacks', 'M3_Aeon_Main_Base_AirDefense_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_Aeon_Main_Base_Air_Patrol_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
end

function AeonM3MainBaseLandPatrols()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ----------
    -- Defense
    ----------
end

function AeonM3MainBaseNavalPatrols()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ----------
    -- Defense
    ----------
    -- Up to 4x 2 Destroyers and 2 T2Submarines patrolling around AI base
    for i = 1, Difficulty + 1 do
        opai = AeonM3MainBase:AddOpAI('NavalAttacks', 'M3_Aeon_Main_Base_NavalDefense_1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M3_Aeon_Main_Base_Naval_Patrol_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity({'Destroyers', 'T2Submarines'}, 4)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    -- Patrols 2, 3, 4 Cruisers
    quantity = {2, 3, 4}
    opai = AeonM3MainBase:AddOpAI('NavalAttacks', 'M3_Aeon_Main_Base_NavalDefense_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_Aeon_Main_Base_Naval_Patrol_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Cruisers', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
end

-- Build a support commander
function M3sACUMainBase()
    AeonM3MainBase:SetSupportACUCount(1)
    AeonM3MainBase:SetSACUUpgrades({'EngineeringFocusingModule', 'ResourceAllocation'})
end

-- Start scouting and sending attacks from the base
function StartAttacks()
    AeonM3MainBaseAirAttacks()
    AeonM3MainBaseLandAttacks()
    AeonM3MainBaseNavalAttacks()
end

----------
-- Attacks
----------
function AeonM3MainBaseAirAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    AeonM3MainBase:SetActive('AirScouting', true)

    ---------
    -- Attack
    ---------
    -- Send 3, 3, 6 CombatFighters if player has more than 10, 8, 12 T2 units
    quantity = {4, 5, 6}
    opai = AeonM3MainBase:AddOpAI('AirAttacks', 'M3_Aeon_Main_Base_AirAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Air_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])

    -- Send 6, 6, 9 Gunships if player has more than 12, 10, 8 T2 units
    quantity = {4, 5, 6}
    trigger = {120, 110, 100}
    opai = AeonM3MainBase:AddOpAI('AirAttacks', 'M3_Aeon_Main_Base_AirAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Air_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_3',
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
    opai = AeonM3MainBase:AddOpAI('AirAttacks', 'M3_Aeon_Main_Base_AirAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Air_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_3',
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
    opai = AeonM3MainBase:AddOpAI('AirAttacks', 'M3_Aeon_Main_Base_AirAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Air_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_3',
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
    opai = AeonM3MainBase:AddOpAI('AirAttacks', 'M3_Aeon_Main_Base_AirAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Air_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})
end

function AeonM3MainBaseLandAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    AeonM3MainBase:SetActive('LandScouting', true)

    -- Engineer for reclaiming if there's less than 4000 Mass in the storage, starting after 5 minutes
    quantity = {4, 6, 8}
    opai = AeonM3MainBase:AddOpAI('EngineerAttack', 'M3_Aeon_Main_Reclaim_Engineers_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Air_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_3',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_1',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_2',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_3',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Reclaim_Chain_1',
                },
            },
            Priority = 190,
        }
    )
    opai:SetChildQuantity('T2Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 4000})

    -- Engineer for reclaiming if there's less than 2000 Mass in the storage, starting after 5 minutes
    quantity = {6, 8, 10}
    opai = AeonM3MainBase:AddOpAI('EngineerAttack', 'M3_Aeon_Main_Reclaim_Engineers_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Air_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Air_Attack_Chain_3',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_1',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_2',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_3',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_2',
                    'M3_Aeon_Main_Base_Reclaim_Chain_1',
                },
            },
            Priority = 200,
        }
    )
    opai:SetChildQuantity('T2Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 2000})

    ---------
    -- Attack
    ---------
    quantity = {6, 9, 12}
    opai = AeonM3MainBase:AddOpAI('BasicLandAttack', 'M3_Aeon_Main_Base_AmphibiousAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_1',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_2',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_3',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('AmphibiousTanks', quantity[Difficulty])

    quantity = {{6, 2}, {8, 2}, {12, 3}}
    opai = AeonM3MainBase:AddOpAI('BasicLandAttack', 'M3_Aeon_Main_Base_AmphibiousAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_1',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_2',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_3',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileFlak'}, quantity[Difficulty])

    quantity = {{5, 1}, {6, 2}, {10, 2}}
    opai = AeonM3MainBase:AddOpAI('BasicLandAttack', 'M3_Aeon_Main_Base_AmphibiousAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_1',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_2',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_3',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileShields'}, quantity[Difficulty])

    quantity = {{6, 2, 1}, {8, 2, 2}, {10, 2, 3}}
    opai = AeonM3MainBase:AddOpAI('BasicLandAttack', 'M3_Aeon_Main_Base_AmphibiousAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_1',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_2',
                    'M3_Aeon_Main_Base_Base_Amphibious_Chain_3',
                },
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileFlak', 'MobileShields'}, quantity[Difficulty])
end

function AeonM3MainBaseNavalAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ---------
    -- Attack
    ---------
    quantity = {3, 4, 5}
    opai = AeonM3MainBase:AddOpAI('NavalAttacks', 'M3_Aeon_Main_Base_NavalAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Frigates', quantity[Difficulty])

    quantity = {5, 8, 10}
    trigger = {4, 6, 8}
    opai = AeonM3MainBase:AddOpAI('NavalAttacks', 'M3_Aeon_Main_Base_NavalAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 110,
        }
    )
    if Difficulty >= 2 then
        opai:SetChildQuantity({'Frigates', 'Submarines'}, quantity[Difficulty])
    else
        opai:SetChildQuantity('Frigates', quantity[Difficulty])
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    quantity = {4, 6, 8}
    opai = AeonM3MainBase:AddOpAI('NavalAttacks', 'M3_Aeon_Main_Base_NavalAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity({'Destroyers', 'Frigates'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 3, categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    quantity = {3, 4, {1, 4}}
    trigger = {7, 6, 5}
    opai = AeonM3MainBase:AddOpAI('NavalAttacks', 'M3_Aeon_Main_Base_NavalAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 130,
        }
    )
    if Difficulty >= 3 then
        opai:SetChildQuantity({'Cruisers', 'T2Submarines'}, quantity[Difficulty])
    else
        opai:SetChildQuantity('T2Submarines', quantity[Difficulty])
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    quantity = {6, 8, 10}
    trigger = {10, 8, 8}
    opai = AeonM3MainBase:AddOpAI('NavalAttacks', 'M3_Aeon_Main_Base_NavalAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 140,
        }
    )
    opai:SetChildQuantity({'Destroyers', 'T2Submarines'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    quantity = {{4, 1, 1}, {5, 1, 2}, {7, 1, 2}}
    trigger = {12, 10, 10}
    opai = AeonM3MainBase:AddOpAI('NavalAttacks', 'M3_Aeon_Main_Base_NavalAttack_6',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_1',
                    'M3_Aeon_Main_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 150,
        }
    )
    opai:SetChildQuantity({'Destroyers', 'Cruisers', 'T2Submarines'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})
end

