local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFM3FireBase_3 = BaseManager.CreateBaseManager()

function UEFM3FireBase3()
    UEFM3FireBase_3:Initialize(ArmyBrains[UEF], 'PowerBase', 'M3PBase', 25, {PowerBase = 100})
    UEFM3FireBase_3:StartNonZeroBase({3, 3})

    BuildAirAttacks()
end

function BuildAirAttacks()
	local opai = nil
	local quantity = {} 
    opai = UEFM3FireBase_3:AddOpAI('AirAttacks', 'M3_BaseAirAttack_3_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'CategoryHunterPlatoonAI'},
            PlatoonData = {
                CategoryList = { categories.AIR * categories.MOBILE },
            },
            Priority = 300,
        }
    )
    opai:SetChildQuantity('Interceptors', 6)
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
        {'default_brain', {'HumanPlayers'}, 6, categories.AIR * categories.MOBILE, '>='})

    quantity = {4, 5, 6}
    opai = UEFM3FireBase_3:AddOpAI('AirAttacks', 'M3_BaseAirAttack_3_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_LandAttack_Chain'
            },
            Priority = 275,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
end

function DisableBase()
    if(UEFM3FireBase_3) then
        UEFM3FireBase_3:BaseActive(false)
    end
end
