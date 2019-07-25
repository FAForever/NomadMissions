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

    ----------
    -- Defense
    ----------
end

function AeonM4ResearchBaseNorthNavalAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    ---------
    -- Attack
    ---------
    quantity = {2, 3, 4}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M4_Aeon_North_Base_Naval_Attack_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Frigates', quantity[Difficulty])

    quantity = {4, 5, 6}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M4_Aeon_North_Base_Naval_Attack_Chain',
            },
            Priority = 100,
        }
    )
    opai:SetChildQuantity('Submarines', quantity[Difficulty])

    trigger = {5, 4, 3}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M4_Aeon_North_Base_Naval_Attack_Chain',
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('Destroyers', 2)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    quantity = {2, 3, 4}
    trigger = {8, 7, 6}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_North_NavalAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M4_Aeon_North_Base_Naval_Attack_Chain',
            },
            Priority = 120,
        }
    )
    opai:SetChildQuantity('T2Submarines', quantity[Difficulty])
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
                    PatrolChain = 'M4_Aeon_Nortth_Base_Naval_Defense_Chain',
                },
                Priority = 100,
            }
        )
        opai:SetChildQuantity({'Destroyers', 'T2Submarines'}, 2)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    -- Patrols 2, 3, 4 AA Boats
    quantity = {1, 1, 2}
    opai = AeonM4ResearchBaseNorth:AddOpAI('NavalAttacks', 'M4_Aeon_North_Base_NavalDefense_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M4_Aeon_Nortth_Base_Naval_Defense_Chain',
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
    quantity = {2, 3, 4}
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
    opai:SetChildQuantity('Frigates', quantity[Difficulty])

    quantity = {4, 5, 6}
    opai = AeonM4ResearchBaseSouth:AddOpAI('NavalAttacks', 'M4_Aeon_Research_Base_South_NavalAttack_2',
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
    opai:SetChildQuantity('Submarines', quantity[Difficulty])

    trigger = {4, 3, 2}
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
    opai:SetChildQuantity('Destroyers', 2)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua',
        'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.NAVAL * categories.MOBILE * categories.TECH2, '>='})

    quantity = {2, 3, 4}
    trigger = {6, 5, 4}
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
    opai:SetChildQuantity('T2Submarines', quantity[Difficulty])
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

