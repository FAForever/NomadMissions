local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFPlateauBase = BaseManager.CreateBaseManager()

function UEFPlateauBaseFunction()
    UEFPlateauBase:Initialize(ArmyBrains[UEF], 'M2_UEF_Plateau_Base', 'M2_UEF_Plateau_Base_Marker', 20, {M2_UEF_Plateau_Base = 100})
    UEFPlateauBase:StartEmptyBase(8, 5)

	UEFArtilleryBase_Patrols()
end

function UEFArtilleryBase_Patrols()
	local opai = nil

	-- Construct some basic land patrols to guard the base that's being built.
	opai = UEFPlateauBase:AddOpAI('BasicLandAttack', 'M2_UEF_Plateau_Base_Patrol_1',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChains = {'M2_UEF_Plateau_Patrol_Chain'}
			},
			Priority = 100,
		}
	)
	opai:SetChildQuantity('MobileFlak', 4)

	opai = UEFPlateauBase:AddOpAI('BasicLandAttack', 'M2_UEF_Plateau_Base_Patrol_2',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChains = {'M2_UEF_Plateau_Patrol_Chain'}
			},
			Priority = 75,
		}
	)
	opai:SetChildQuantity('HeavyTanks', 6)
end

function DisableBase()
    if (UEFPlateauBase) then
        UEFPlateauBase:BaseActive(false)
    end
end