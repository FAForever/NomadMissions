local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFArtilleryBase = BaseManager.CreateBaseManager()

function UEFArtilleryBaseFunction()
    UEFArtilleryBase:Initialize(ArmyBrains[UEF], 'M2_Arty_Base_Units', 'M2_UEF_Artillery_Base_Marker', 75, {M2_Arty_Base_Units = 100})
    UEFArtilleryBase:StartNonZeroBase({{12, 10, 8}, {8, 6, 4}})

	UEFArtilleryBase:SetActive('AirScouting', true)

    UEFArtilleryBase:AddBuildGroup('M2_Arty_Base_Expansion_D' .. Difficulty, 100, false)
end

function UEFArtilleryBase_AirAttacks()

end

function UEFArtilleryBase_LandAttacks()

end

function DisableBase()
    if(UEFArtilleryBase) then
        UEFArtilleryBase:BaseActive(false)
    end
end