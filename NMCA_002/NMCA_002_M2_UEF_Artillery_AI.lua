local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFArtilleryBase = BaseManager.CreateBaseManager()

function UEFArtilleryBaseFunction()
    UEFArtilleryBase:Initialize(ArmyBrains[UEF], 'M2_Arty_Base_Units', 'M2_UEF_Artillery_Base_Marker', 100, {M2_Arty_Base_Units = 100})
    UEFArtilleryBase:StartNonZeroBase({{10, 12, 16}, {4, 6, 8}})
    UEFArtilleryBase.MaximumConstructionEngineers = 5
	UEFArtilleryBase:SetActive('AirScouting', true)

    UEFArtilleryBase:AddBuildGroup('M2_Arty_Base_Expansion_D' .. Difficulty, 100, false)

	UEFArtilleryBase_LandAttacks()
	UEFArtilleryBase_AirAttacks()
	UEFArtilleryBase_TransportAttacks()
end

function UEFArtilleryBase_AirAttacks()
	
	local Temp = {
		'P2AirB2AttackTemp1',
		'NoPlan',
		{ 'dea0202', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uea0102', 1, 6, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2AirB2AttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'M2_Arty_Base_Units',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Artillery_Base_Air_Attack_1', 'M2_UEF_Artillery_Base_Air_Attack_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2AirB2AttackTemp2',
		'NoPlan',
		{ 'uea0203', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uea0103', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2AirB2AttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'M2_Arty_Base_Units',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Artillery_Base_Air_Attack_1', 'M2_UEF_Artillery_Base_Air_Attack_2', 'M2_UEF_Artillery_Base_Air_Attack_3'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	Temp = {
		'P2AirB2AttackTemp3',
		'NoPlan',
		{ 'uea0103', 1, 8, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2AirB2AttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'M2_Arty_Base_Units',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Artillery_Base_Air_Attack_1', 'M2_UEF_Artillery_Base_Air_Attack_2', 'M2_UEF_Artillery_Base_Air_Attack_3'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'UEFAirM2AttackTemp0',
       'NoPlan',
       { 'uea0103', 1, 5, 'Attack', 'GrowthFormation' }, --Bombers
       { 'uea0102', 1, 9, 'Attack', 'GrowthFormation' }, --Fighters
       { 'uea0203', 1, 4, 'Attack', 'GrowthFormation' }, --Gunships 	 	   
    }
    Builder = {
       BuilderName = 'UEFAirM2AttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 300,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M2_Arty_Base_Units',
      PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'M2_UEF_Air_Base_Patrol_Chain_1'
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
end

function UEFArtilleryBase_LandAttacks()
	
	local Temp = {
		'P2landB2AttackTemp1',
		'NoPlan',
		{ 'uel0202', 1, 6, 'Attack', 'GrowthFormation' },
		{ 'uel0205', 1, 2, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2landB2AttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 200,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_Arty_Base_Units',
		PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_UEF_Air_Base_Patrol_Chain_1'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	Temp = {
		'P2landB2AttackTemp2',
		'NoPlan',
		{ 'uel0201', 1, 6, 'Attack', 'GrowthFormation' },
		{ 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2landB2AttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_Arty_Base_Units',
		PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_UEF_Artillery_Base_Land_Attack_1'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2landB2AttackTemp3',
		'NoPlan',
		{ 'uel0201', 1, 6, 'Attack', 'GrowthFormation' },
		{ 'uel0202', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2landB2AttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_Arty_Base_Units',
		PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_UEF_Artillery_Base_Cybran_Attack'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2landB2AttackTemp4',
		'NoPlan',
		{ 'uel0103', 1, 6, 'Attack', 'GrowthFormation' },
		{ 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2landB2AttackBuilder4',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_Arty_Base_Units',
		PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_UEF_Artillery_Base_Land_Attack_1'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2landB2AttackTemp5',
		'NoPlan',
		{ 'uel0103', 1, 6, 'Attack', 'GrowthFormation' },
		{ 'uel0202', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2landB2AttackBuilder5',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_Arty_Base_Units',
		PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_UEF_Artillery_Base_Cybran_Attack'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	
end

function UEFArtilleryBase_TransportAttacks()
	local opai = nil
    local quantity = {}

    -- Transport Builder
    opai = UEFArtilleryBase:AddOpAI('EngineerAttack', 'M2_Artillery_Base_Transport_Builder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {
            AttackChain = 'M1_UEF_Transport_Troops_Chain',
            LandingChain = 'M2_UEF_Artillery_Drop_Chain',
            TransportReturn = 'M2_UEF_Artillery_Base_Marker',
        },
        Priority = 1000,
    })
    opai:SetChildQuantity('T2Transports', 2)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 2, categories.uea0104})

	quantity = {10, 12, 14}
	for i = 1, Difficulty do
		opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_ArtilleryBase_Drop_' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M1_UEF_Transport_Troops_Chain',
				LandingChain = 'M2_UEF_Artillery_Drop_Chain',
				TransportReturn = 'M2_UEF_Artillery_Base_Marker',
			},
			Priority = 150,
		})
		opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
	
	end
	
	quantity = {10, 12, 14}
	for i = 1, Difficulty do
		opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_ArtilleryBase_Drop2_' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M1_UEF_Transport_Troops_Chain',
				LandingChain = 'M2_UEF_Artillery_Drop_Chain',
				TransportReturn = 'M2_UEF_Artillery_Base_Marker',
			},
			Priority = 150,
		})
		opai:SetChildQuantity('LightTanks', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 240})
	
	end

	
end

function DisableBase()
    if(UEFArtilleryBase) then
        UEFArtilleryBase:BaseActive(false)
    end
end