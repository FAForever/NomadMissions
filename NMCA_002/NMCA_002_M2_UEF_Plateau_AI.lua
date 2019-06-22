local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFPlateauBase = BaseManager.CreateBaseManager()

function UEFPlateauBaseFunction()
    UEFPlateauBase:Initialize(ArmyBrains[UEF], 'M2_UEF_Plateau_Base', 'M2_UEF_Plateau_Base_Marker', 20, {M2_UEF_Plateau_Base = 100})
    UEFPlateauBase:StartEmptyBase(8, 5)
    UEFPlateauBase.MaximumConstructionEngineers = 8
	UEFArtilleryBase_Patrols()
end

function UEFArtilleryBase_Patrols()
	
	-- Construct some basic land patrols to guard the base that's being built.
	local Temp = {
		'P2landB3AttackTemp1',
		'NoPlan',
		{ 'uel0202', 1, 3, 'Attack', 'GrowthFormation' },
		{ 'uel0205', 1, 2, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2landB3AttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 300,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_UEF_Plateau_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChain = 'M2_UEF_Plateau_Patrol_Chain'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	 Temp = {
		'P2landB3AttackTemp2',
		'NoPlan',
		{ 'uea0102', 1, 5, 'Attack', 'GrowthFormation' },
		{ 'uea0103', 1, 2, 'Attack', 'GrowthFormation' },
	}
	 Builder = {
		BuilderName = 'P2landB3AttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 300,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'M2_UEF_Plateau_Base',
		PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_UEF_Plateau_Patrol_Chain'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
	opai = UEFPlateauBase:AddOpAI('EngineerAttack', 'M2_Plateau_Base_Transport_Builder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {
            AttackChain = 'M2_UEF_Plateau_Drop_Chainattack1',
            LandingChain = 'M2_UEF_Plateau_Drop_Chain',
            TransportReturn = 'M2_UEF_Plateau_Base_Marker',
        },
        Priority = 1000,
    })
    opai:SetChildQuantity('T1Transports', 2)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 2, categories.uea0107})

	quantity = {6, 10, 12}
	for i = 1, Difficulty do
		opai = UEFPlateauBase:AddOpAI('BasicLandAttack', 'M2_UEF_Plateau_Drop_Chain' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M2_UEF_Plateau_Drop_Chainattack1',
				LandingChain = 'M2_UEF_Plateau_Drop_Chain',
				TransportReturn = 'M2_UEF_Plateau_Base_Marker',
			},
			Priority = 250,
		})
		opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
		opai:SetLockingStyle('BuildTimer', {LockTimer = 60})
	
	end
	
end

function DisableBase()
    if (UEFPlateauBase) then
        UEFPlateauBase:BaseActive(false)
    end
end