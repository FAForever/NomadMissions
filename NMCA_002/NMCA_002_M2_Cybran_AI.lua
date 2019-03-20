local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local Cybran = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local CybranMainBase = BaseManager.CreateBaseManager()

function CybranMainBaseAI()
    CybranMainBase:Initialize(ArmyBrains[Cybran], 'M2_MainBase', 'M2_Cybran_Main_Base_Marker', 150, {M2_MainBase = 100})
    CybranMainBase:StartNonZeroBase({{14, 12, 10}, {10, 8, 6}})

	CybranMainBase:AddBuildGroup('M2_MainBase_Navy', 90, false)

	M2CybranLandAttacks()
	M2CybranNavalAttacks()
end

function M2CybranNavalAttacks()
	-- Providing we have a Naval Factory, we should send some basic attacks at the UEF naval base.
	Temp = {
       'CybranNavalAttack1',
       'NoPlan',
       { 'urs0103', 1, 6, 'Attack', 'GrowthFormation' },
       { 'urs0203', 1, 2, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'CybranNavalBuild1',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 400,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_MainBase',
		BuildConditions = {
			{ '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
			{'default_brain', 'Cybran', 1, categories.NAVAL * categories.FACTORY}},
		},
		PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_Cybran_UEF_Naval_Attack_Chain'
		},
	}
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function M2CybranLandAttacks()
	-- We should focus on building extra units that will Patrol around the Cybran main base to stop the UEF from breaking through the defenses.
	local opai = nil
	
	opai = CybranMainBase:AddOpAI('BasicLandAttack', 'M2_Cybran_Land_Patrol_1', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_Extra_Land_Patrol_Chain'
           },
           Priority = 250,
		}
	)
	opai:SetChildQuantity('HeavyTanks', 8)

	Temp = {
		'CybranLandPatrol2',
		'NoPlan',
		{ 'url0107', 1, 8, 'Attack', 'GrowthFormation' },
		{ 'url0303', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'url0202', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'CybranLandPatrolBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 225,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_MainBase',
		PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_Cybran_Extra_Land_Patrol_Chain'
		},
	}
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function M2CybranAirAttacks()
	-- Send a couple of air attacks at the UEF, nothing major as we're not intending to do much damage.
	local opai = nil
	
	opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_1', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_UEF_Air_Attack_Chain'
           },
           Priority = 200,
		}
	)
	opai:SetChildQuantity('Bombers', 6)

	opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_2', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_UEF_Air_Attack_Chain'
           },
           Priority = 175,
		}
	)
	opai:SetChildQuantity('Interceptors', 8)

	opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_3', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_UEF_Air_Attack_Chain'
           },
           Priority = 150,
		}
	)
	opai:SetChildQuantity('Gunships', 3)
end