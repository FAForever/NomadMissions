local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local Cybran = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local CybranMainBase = BaseManager.CreateBaseManager()

function CybranMainBaseAI()
    CybranMainBase:Initialize(ArmyBrains[Cybran], 'M2_MainBase', 'M2_Cybran_Main_Base_Marker', 100, {M2_MainBase = 100})
    CybranMainBase:StartNonZeroBase({{12, 10, 8}, {10, 8, 6}})
end