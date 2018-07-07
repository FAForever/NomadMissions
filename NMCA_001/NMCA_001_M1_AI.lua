local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFOutpost = BaseManager.CreateBaseManager()

function UEFOutpostAI()
    UEFOutpost:Initialize(ArmyBrains[UEF], 'M1_Outpost', 'M1_UEF_Outpost_Marker', 100, {Outpost = 100})
    UEFOutpost:StartNonZeroBase({{8, 10, 12}, {6, 8, 10}})

    if Difficulty > 1 then
        UEFOutpost:AddBuildGroup('Outpost_D'..Difficulty, 90, true)
    end

    UEFOutpost:SetActive('TML', false)
end

function M1LandAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    quantity = {5, 10, 15}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M2_OutpostAttack_2'
            },
            Priority = 500,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

    quantity = {4, 5, 6}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 
                                'M2_OutpostAttack_2',
                                'M2_OutpostAttack_3'},
            },
            Priority = 475,
        }
    )
    opai:SetChildQuantity('MobileAntiAir', quantity[Difficulty])

    quantity = {8, 12, 16}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 
                                'M2_OutpostAttack_2',
                                'M2_OutpostAttack_3'},
            },
            Priority = 450,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

    quantity = {5, 8, 12}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 
                                'M2_OutpostAttack_2',
                                'M2_OutpostAttack_3'},
            },
            Priority = 425,
        }
    )
    opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

    quantity = {16, 20, 24}
    trigger = {40, 32, 24}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M2_OutpostAttack_2',
            },
            Priority = 400,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.LAND * categories.MOBILE, '>='})

    quantity = {6, 8, 10}
    trigger = {48, 40, 32}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_6',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 
                                'M2_OutpostAttack_2',
                                'M2_OutpostAttack_3'},
            },
            Priority = 375,
        }
    )
    opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
        {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.DIRECTFIRE + categories.INDIRECTFIRE, '>='})

    quantity = {4, 6, 8}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_7',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1',
                                'M2_OutpostAttack_2',
                                'M2_OutpostAttack_3'},
            },
            Priority = 350,
        }
    )
    opai:SetChildQuantity('LightBots', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

    quantity = {6, 8, 10}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_8',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 
                                'M2_OutpostAttack_2', 
                                'M2_OutpostAttack_3'},
            },
            Priority = 325,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])

    quantity = {4, 6, 8}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_9',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
            PlatoonData = {
              CategoryList = { categories.inb2101 },
            },
            Priority = 300,
        }
    )
    opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
    {'default_brain', 'Player', 1, categories.inb2101})

    quantity = {12, 16, 20}
    opai = UEFOutpost:AddOpAI('BasicLandAttack', 'M1_OutpostLandAttack_10',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 
                                'M2_OutpostAttack_2', 
                                'M2_OutpostAttack_3'},
            },
            Priority = 275,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

    if (Difficulty > 1) then
        Temp = {
            'TempAttack_Land_1',
            'NoPlan',
            { 'uel0201', 1, 12, 'Attack', 'GrowthFormation' },
            { 'uel0103', 1, 6, 'Attack', 'GrowthFormation' },
            { 'uel0104', 1, 4, 'Attack', 'GrowthFormation' },
        }
        Builder = {
            BuilderName = 'M1_OutpostLandAttack_11',
            PlatoonTemplate = Temp,
            InstanceCount = 1,
            Priority = 1000,
            PlatoonType = 'Land',
            RequiresConstruction = true,
            LocationType = 'M1_Outpost',
            PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 'M2_OutpostAttack_2', 'M2_OutpostAttack_3'}
            },
        }
        ArmyBrains[UEF]:PBMAddPlatoon( Builder )

        Temp = {
            'TempAttack_Land_2',
            'NoPlan',
            { 'uel0201', 1, 16, 'Attack', 'GrowthFormation' },
            { 'uel0103', 1, 4, 'Attack', 'GrowthFormation' },
            { 'uel0104', 1, 2, 'Attack', 'GrowthFormation' },
            { 'uel0106', 1, 6, 'Attack', 'GrowthFormation' },
        }
        Builder = {
            BuilderName = 'M1_OutpostLandAttack_12',
            PlatoonTemplate = Temp,
            InstanceCount = 1,
            Priority = 975,
            PlatoonType = 'Land',
            RequiresConstruction = true,
            LocationType = 'M1_Outpost',
            PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 'M2_OutpostAttack_2', 'M2_OutpostAttack_3'}
            },
        }
        ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    end
end


function M1AirAttacks()
   local opai = nil
   local quantity = {}

    quantity = {4, 6, 8}
    opai = UEFOutpost:AddOpAI('AirAttacks', 'M1_OutpostAirAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M2_OutpostAttack_1'
            },
            Priority = 450,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])

    quantity = {6, 8, 10}
    opai = UEFOutpost:AddOpAI('AirAttacks', 'M1_OutpostAirAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M2_OutpostAttack_1'
            },
            Priority = 425,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])

    quantity = {8, 12, 16}
    trigger = {20, 15, 10}
    opai = UEFOutpost:AddOpAI('AirAttacks', 'M1_EastAirAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 
                                'M2_OutpostAttack_2', 
                                'M2_OutpostAttack_3'},
            },
            Priority = 400,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
        {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})

    quantity = {3, 5, 7}
    opai = UEFOutpost:AddOpAI('AirAttacks', 'M1_OutpostAirAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M2_OutpostAttack_1', 
                                'M2_OutpostAttack_2', 
                                'M2_OutpostAttack_3'},
            },
            Priority = 375,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])

    -- High priority hunting platoons
    quantity = {2, 4, 6}
    opai = UEFOutpost:AddOpAI('AirAttacks', 'M1_OutpostAirAttack_5',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
            PlatoonData = {
              CategoryList = { categories.inb2101 },
            },
            Priority = 1000,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
    {'default_brain', 'Player', 1, categories.inb2101})

    quantity = {4, 6, 8}
    opai = UEFOutpost:AddOpAI('AirAttacks', 'M1_OutpostAirAttack_6',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
            PlatoonData = {
              CategoryList = { categories.inb2101 },
            },
            Priority = 975,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
    {'default_brain', 'Player', 3, categories.inb2101})
end

function DisableBase()
    if(UEFOutpost) then
        UEFOutpost:BaseActive(false)
    end
end
