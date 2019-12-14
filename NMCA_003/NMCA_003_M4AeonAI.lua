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
local AeonM4ResearchBaseNorth = BaseManager.CreateBaseManager()
local AeonM4ResearchBaseSouth = BaseManager.CreateBaseManager()

------------------------------
-- Aeon M4 Research Base North
------------------------------
function AeonM4ResearchBaseNorthAI()
    AeonM4ResearchBaseNorth:InitializeDifficultyTables(ArmyBrains[Aeon], 'M4_Aeon_Research_Base_North', 'M4_Aeon_Research_Base_North_Marker', 70, {M4_Aeon_Research_Base_North = 100})
    AeonM4ResearchBaseNorth:StartNonZeroBase({{3, 4, 5}, {3, 4, 5}})
    AeonM4ResearchBaseNorth:SetActive('AirScouting', true)

    AeonM4ResearchBaseNorthAirAttacks()
    AeonM4ResearchBaseNorthNavalAttacks()
end

function AeonM4ResearchBaseNorthAirAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ---------
    -- Attack
    ---------
    -- Always send 3 bombers.
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Bombers', 3)

    -- Send {5, 7, 9} Bombers if players have more than {280, 260, 240} units.
    quantity = {5, 7, 9}
    trigger = {280, 260, 240}
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    -- Send {5, 7, 9} Bombers if players have more than {350, 330, 310} units.
    quantity = {5, 7, 9}
    trigger = {350, 330, 310}
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    -- Send {5, 7, 9} Bombers if players have more than {16, 14, 12} T2 Naval units.
    quantity = {5, 7, 9}
    trigger = {16, 14, 12}
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    -- Send {5, 7, 9} Bombers if players have more than {54, 42, 30} air units.
    quantity = {5, 7, 9}
    trigger = {54, 42, 30}
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})

    -- Send {9, 12, 15} Bombers if players have more than {380, 350, 320} units.
    quantity = {9, 12, 15}
    trigger = {380, 350, 320}
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_6',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.ALLUNITS - categories.WALL, '>='})

    -- Send {8, 10, 12} Bombers if players have more than {16, 14, 12} T2 Mexes.
    quantity = {8, 10, 12}
    trigger = {16, 14, 12}
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_7',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 140,
        }
    )
    opai:SetChildQuantity('Gunships', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.MASSEXTRACTION * categories.TECH2, '>='})

    -- Send {8, 10, 12} Bombers if players have more than {45, 40, 35} naval units.
    quantity = {8, 10, 12}
    trigger = {45, 40, 35}
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_8',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 150,
        }
    )
    opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    -- Send {8, 10, 12} Bombers if players have more than {60, 50, 40} T2 Air units.
    quantity = {8, 10, 12}
    trigger = {60, 50, 40}
    opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_Research_Base_North_AirAttack_9',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_1',
                    'M4_Aeon_North_Base_Air_Attack_Chain_2',
                    'M4_Aeon_North_Base_Air_Attack_Chain_3',
                },
            },
            Priority = 150,
        }
    )
    opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE * categories.TECH2, '>='})

    ----------
    -- Defense
    ----------
    -- Maintains 2x {3, 4, 5} CombatFighters, Gunships and TorpedoBombers, rebuild if half is destroyed
    quantity = {3, 4, 5}
    for i = 1, 2 do
        opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_North_Base_AirDefense_1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M4_Aeon_North_Base_Air_Defense_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

        opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_North_Base_AirDefense_2_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M4_Aeon_North_Base_Air_Defense_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity('Gunships', quantity[Difficulty])
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

        opai = AeonM4ResearchBaseNorth:AddOpAI('AirAttacks', 'M4_Aeon_North_Base_AirDefense_3_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'RandomDefensePatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M4_Aeon_North_Base_Air_Defense_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end
end

function AeonM4ResearchBaseNorthNavalAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ---------
    -- Attack
    ---------
    -- Always send 2 Frigates and 2 Submarines.
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity({'Frigates', 'Submarines'}, 4)

    -- Send {4, 5, 6} Frigates if players have more than {12, 10, 8} naval units.
    quantity = {4, 5, 6}
    trigger = {12, 10, 8}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Frigates', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    -- Send 4, 5, 6 Submarines if players have more than {14, 12, 10} T1, T2 subs and Rail boats combined.
    quantity = {4, 5, 6}
    trigger = {14, 12, 10}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Submarines', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.T1SUBMARINE + categories.T2SUBMARINE + categories.xns0102, '>='})

    -- Send 2 Destroyers if players have more than {8, 6, 4} T2 ships.
    trigger = {9, 7, 5}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('Destroyers', 2)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    -- Send {4, 4, 6} {'T2Submarines', 'Submarines'} if players have more than {13, 11, 9} T2 ships.
    quantity = {4, 4, 6}
    trigger = {13, 11, 9}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity({'T2Submarines', 'Submarines'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    -- Send 2 Cruisers if players have more than {70, 60, 50} T2 air units.
    trigger = {70, 60, 50}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_6',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('Cruisers', 2)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE * categories.TECH2, '>='})

    -- Send Frigates and Submarines if players have more than {30, 25, 20} ships.
    quantity = {{6, 4}, {8, 4}, {10, 4}}
    trigger = {30, 25, 20}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_7',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M4_Aeon_North_Base_Naval_Attack_Chain_1',
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity({'Frigates', 'Submarines'}, quantity[Difficulty])
    opai:SetFormation('AttackFormation')
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    -- Send Destroyers, Cruisers and T2Submarines if players have more than {18, 16, 14} T2 Ships.
    quantity = {{3, 1}, {3, 1}, {3, 1, 2}}
    trigger = {18, 16, 14}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_8',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_North_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_North_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 130,
        }
    )
    if Difficulty <= 2 then
        opai:SetChildQuantity({'Destroyers', 'Cruisers'}, quantity[Difficulty])
    else
        opai:SetChildQuantity({'Destroyers', 'Cruisers', 'T2Submarines'}, quantity[Difficulty])
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    ----------
    -- Defense
    ----------
    -- Up to 2x Destroyer and T2Submarine patrolling around AI base
    for i = 1, 2 do
        opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_North_Base_NavalDefense_1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M4_Aeon_North_Base_Naval_Defense_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity({'Destroyers', 'T2Submarines'}, 2)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    -- Patrols 1, 1, 2 Cruisers
    quantity = {1, 1, 2}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_North_Base_NavalDefense_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M4_Aeon_North_Base_Naval_Defense_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Cruisers', quantity[Difficulty])
    if Difficulty >= 3 then
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end
end

------------------------------
-- Aeon M4 Research Base South
------------------------------
function AeonM4ResearchBaseSouthAI()
    AeonM4ResearchBaseSouth:InitializeDifficultyTables(ArmyBrains[Aeon], 'M4_Aeon_Research_Base_South', 'M4_Aeon_Research_Base_South_Marker', 65, {M4_Aeon_Research_Base_South = 100, M4_Aeon_Research_Base_South_Extended = 100})
    AeonM4ResearchBaseSouth:StartNonZeroBase({{2, 3, 4}, {2, 2, 2}})
    AeonM4ResearchBaseSouth:SetActive('LandScouting', true)

    AeonM4ResearchBaseSouthLandAttacks()
    AeonM4ResearchBaseSouthNavalAttacks()
end

function AeonM4ResearchBaseSouthLandAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    -- Engineer for reclaiming if there's less than 3000 Mass in the storage, starting after 5 minutes
    quantity = {3, 4, 6}
    opai = AeonM4ResearchBaseSouth:AddOpAI('EngineerAttack', 'M4_Aeon_South_Reclaim_Engineers',
        {
            MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Amphibious_Chain_1',
                    'M4_Aeon_South_Base_Amphibious_Chain_2',
                    'M4_Aeon_South_Base_Amphibious_Chain_3',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 200,
        }
    )
    opai:SetChildQuantity('T1Engineers', quantity[Difficulty])
    opai:AddBuildCondition(CustomFunctions, 'LessMassStorageCurrent', {'default_brain', 3000})

    ---------
    -- Attack
    ---------
    quantity = {6, 9, 12}
    opai = AeonM4ResearchBaseSouth:AddOpAI('BasicLandAttack', 'M4_Aeon_South_Base_AmphibiousAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Amphibious_Chain_1',
                    'M4_Aeon_South_Base_Amphibious_Chain_2',
                    'M4_Aeon_South_Base_Amphibious_Chain_3',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('AmphibiousTanks', quantity[Difficulty])

    quantity = {{6, 2}, {8, 2}, {12, 3}}
    opai = AeonM4ResearchBaseSouth:AddOpAI('BasicLandAttack', 'M4_Aeon_South_Base_AmphibiousAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Amphibious_Chain_1',
                    'M4_Aeon_South_Base_Amphibious_Chain_2',
                    'M4_Aeon_South_Base_Amphibious_Chain_3',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileFlak'}, quantity[Difficulty])

    quantity = {{5, 1}, {6, 2}, {10, 2}}
    opai = AeonM4ResearchBaseSouth:AddOpAI('BasicLandAttack', 'M4_Aeon_South_Base_AmphibiousAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Amphibious_Chain_1',
                    'M4_Aeon_South_Base_Amphibious_Chain_2',
                    'M4_Aeon_South_Base_Amphibious_Chain_3',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity({'AmphibiousTanks', 'MobileShields'}, quantity[Difficulty])

    quantity = {{6, 2, 1}, {8, 2, 2}, {10, 2, 3}}
    opai = AeonM4ResearchBaseSouth:AddOpAI('BasicLandAttack', 'M4_Aeon_South_Base_AmphibiousAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Amphibious_Chain_1',
                    'M4_Aeon_South_Base_Amphibious_Chain_2',
                    'M4_Aeon_South_Base_Amphibious_Chain_3',
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

function AeonM4ResearchBaseSouthNavalAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ---------
    -- Attack
    ---------
    -- Always send 2 Frigates and 2 Submarines.
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity({'Frigates', 'Submarines'}, 4)

    -- Send {4, 5, 6} Frigates if players have more than {14, 12, 10} naval units.
    quantity = {4, 5, 6}
    trigger = {14, 12, 10}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Frigates', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    -- Send 4, 5, 6 Submarines if players have more than {18, 16, 14} T1, T2 subs and Rail boats combined.
    quantity = {4, 5, 6}
    trigger = {18, 16, 14}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Submarines', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.T1SUBMARINE + categories.T2SUBMARINE + categories.xns0102, '>='})

    -- Send 2 Destroyers if players have more than {0, 8, 6} T2 ships.
    trigger = {10, 8, 6}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('Destroyers', 2)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    -- Send {4, 4, 6} {'T2Submarines', 'Submarines'} if players have more than {15, 13, 11} T2 ships.
    quantity = {4, 4, 6}
    trigger = {15, 13, 11}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity({'T2Submarines', 'Submarines'}, quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    -- Send 2 Cruisers if players have more than {80, 70, 60} T2 air units.
    trigger = {80, 70, 60}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_6',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('Cruisers', 2)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE * categories.TECH2, '>='})

    -- Send Frigates and Submarines if players have more than {35, 30, 25} ships.
    quantity = {{6, 4}, {8, 4}, {10, 4}}
    trigger = {35, 30, 25}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_7',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 130,
        }
    )
    opai:SetChildQuantity({'Frigates', 'Submarines'}, quantity[Difficulty])
    opai:SetFormation('AttackFormation')
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE, '>='})

    -- Send Destroyers, Cruisers and T2Submarines if players have more than {18, 16, 14} T2 Ships.
    quantity = {{3, 1}, {3, 1}, {3, 1, 2}}
    trigger = {12, 10, 8}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_8',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {
                    'M4_Aeon_South_Base_Naval_Attack_Chain_1',
                    'M4_Aeon_South_Base_Naval_Attack_Chain_2',
                },
            },
            Priority = 130,
        }
    )
    if Difficulty <= 2 then
        opai:SetChildQuantity({'Destroyers', 'Cruisers'}, quantity[Difficulty])
    else
        opai:SetChildQuantity({'Destroyers', 'Cruisers', 'T2Submarines'}, quantity[Difficulty])
    end
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    ----------
    -- Defense
    ----------
    -- Up to 2x Destroyer and T2Submarine patrolling around AI base
    for i = 1, 2 do
        opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_South_Base_NavalDefense_1_' .. i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M4_Aeon_South_Base_Naval_Defense_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity({'Destroyers', 'T2Submarines'}, 2)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    -- Patrols 2, 3, 4 AA Boats
    quantity = {1, 1, 2}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_South_Base_NavalDefense_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M4_Aeon_South_Base_Naval_Defense_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Cruisers', quantity[Difficulty])
    if Difficulty >= 3 then
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end
end
