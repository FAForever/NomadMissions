local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFM3FireBase_2 = BaseManager.CreateBaseManager()

function UEFM3FireBase2()
    UEFM3FireBase_2:Initialize(ArmyBrains[UEF], 'M3Firebase_2', 'M3_Firebase_2_Marker', 25, {M3Firebase_2 = 100})
    UEFM3FireBase_2:StartNonZeroBase({3, 1})

    BuildPatrols()
end

function BuildPatrols()
    local opai = nil
    local quantity = {}

    Temp = {
         'TempPatrol1',
         'NoPlan',
         { 'uel0201', 1, 6, 'Attack', 'GrowthFormation' },   # Tanks
         { 'uel0104', 1, 2, 'Attack', 'GrowthFormation' },   # AA
         { 'uel0103', 1, 2, 'Attack', 'GrowthFormation' },   # Artillery
    }
     Builder = {
         BuilderName = 'PatrolBuilder1',
         PlatoonTemplate = Temp,
         InstanceCount = 1,
         Priority = 350,
         PlatoonType = 'Land',
         RequiresConstruction = true,
         LocationType = 'M3Firebase_2',
         PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
         PlatoonData = {
             PatrolChains = {'M3_Patrol_1_Chain', 'M3_Patrol_2_Chain'}
         },
     }
     ArmyBrains[UEF]:PBMAddPlatoon( Builder )

      Temp = {
         'TempPatrol2',
         'NoPlan',
         { 'uel0201', 1, 6, 'Attack', 'GrowthFormation' },   # Tanks
         { 'uel0104', 1, 2, 'Attack', 'GrowthFormation' },   # AA
         { 'uel0103', 1, 2, 'Attack', 'GrowthFormation' },   # Artillery
      }
     Builder = {
         BuilderName = 'PatrolBuilder2',
         PlatoonTemplate = Temp,
         InstanceCount = 1,
         Priority = 325,
         PlatoonType = 'Land',
         RequiresConstruction = true,
         LocationType = 'M3Firebase_2',
         PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
         PlatoonData = {
             PatrolChains = {'M3_Patrol_1_Chain', 'M3_Patrol_2_Chain'}
         },
     }
     ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {6, 8, 10}
    opai = UEFM3FireBase_2:AddOpAI('BasicLandAttack', 'M3Patrol3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_Patrol_1_Chain'
            },
            Priority = 250,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])

    -- Attacks
    quantity = {8, 10, 12}
    opai = UEFM3FireBase_2:AddOpAI('BasicLandAttack', 'M3Attack_Base2_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_LandAttack_Chain'
            },
            Priority = 225,
        }
    )
    opai:SetChildQuantity('LightTanks', quantity[Difficulty])

    quantity = {3, 4, 6}
    opai = UEFM3FireBase_2:AddOpAI('BasicLandAttack', 'M3Attack_Base2_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_LandAttack_Chain'
            },
            Priority = 200,
        }
    )
    opai:SetChildQuantity('LightArtillery', quantity[Difficulty])

    quantity = {4, 5, 6}
    opai = UEFM3FireBase_2:AddOpAI('BasicLandAttack', 'M3Attack_Base2_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_LandAttack_Chain'
            },
            Priority = 175,
        }
    )
    opai:SetChildQuantity('MobileAntiAir', quantity[Difficulty])

    quantity = {6, 8, 10}
    opai = UEFM3FireBase_2:AddOpAI('BasicLandAttack', 'M3Attack_Base2_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_LandAttack_Chain'
            },
            Priority = 150,
        }
    )
    opai:SetChildQuantity('LightBots', quantity[Difficulty])
end

function DisableBase()
    if(UEFM3FireBase_2) then
        UEFM3FireBase_2:BaseActive(false)
    end
end
