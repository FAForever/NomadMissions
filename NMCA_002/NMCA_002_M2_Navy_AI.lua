local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 4
local Player1 = 1

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFNavyBase = BaseManager.CreateBaseManager()

function UEFNavyBaseFunction()
    UEFNavyBase:Initialize(ArmyBrains[UEF], 'M2_Naval_Base', 'M2_UEF_Naval_Base_Marker', 100, {M2_Naval_Base = 300})
    UEFNavyBase:StartNonZeroBase({{11, 15, 20}, {9, 13, 18}})

	UEFNavyBase:SetActive('AirScouting', true)

	UEFNavyBase_AirAttacks()
	UEFNavy_NavalAttacks()
	UEFNavy_TransportAttacks()
end

function UEFNavyBase_AirAttacks()
    
	local opai = nil
    local quantity = {}
	
	local Temp = {
		'P2AirAttackTemp1',
		'NoPlan',
		{ 'uea0103', 1, 7, 'Attack', 'GrowthFormation' },
		{ 'uea0102', 1, 5, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2AirAttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2', 'M2_UEF_Player_Air_Attack_Chain_3'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	Temp = {
		'P2AirAttackTemp2',
		'NoPlan',
		{ 'uea0102', 1, 7, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2AirAttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2', 'M2_UEF_Player_Air_Attack_Chain_3'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2AirAttackTemp3',
		'NoPlan',
		{ 'uea0203', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uea0103', 1, 2, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2AirAttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2', 'M2_UEF_Player_Air_Attack_Chain_3'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2AirAttackTemp4',
		'NoPlan',
		{ 'dea0202', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uea0102', 1, 2, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2AirAttackBuilder4',
		PlatoonTemplate = Temp,
		InstanceCount = 3,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2', 'M2_UEF_Player_Air_Attack_Chain_3'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	quantity = {6, 8, 10}
    opai = UEFNavyBase:AddOpAI('AirAttacks', 'M2_UEF_Air_Attack_6',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
            PlatoonData = {
              CategoryList = { categories.NAVAL - categories.CYBRAN },
            },
            Priority = 125,
        }
    )
    opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
	opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
            {'default_brain', {'HumanPlayers'}, 20, categories.NAVAL * categories.MOBILE, '>='})
	
end

function UEFNavy_NavalAttacks()
    
	local Temp = {
		'NavalAttackTemp',
		'NoPlan',
		{ 'ues0103', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'ues0203', 1, 4, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'NavyAttackBuilder',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 200,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	Temp = {
		'NavalAttackTemp2',
		'NoPlan',
		{ 'ues0203', 1, 5, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'NavyAttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 150,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	Temp = {
		'NavalAttackTemp3',
		'NoPlan',
		{ 'ues0202', 1, 1, 'Attack', 'GrowthFormation' },
		{ 'ues0203', 1, 3, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'NavyAttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 175,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'NavalAttackTemp4',
		'NoPlan',
		{ 'ues0201', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'ues0103', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'ues0203', 1, 3, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'NavyAttackBuilder4',
		PlatoonTemplate = Temp,
		InstanceCount = 3,
		Priority = 125,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

end

function UEFNavy_TransportAttacks()
	local opai = nil
    local quantity = {}

    -- Transport Builder
    opai = UEFNavyBase:AddOpAI('EngineerAttack', 'M2_NavalBase_Transport_Builder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {
            AttackChain = 'M2_UEF_Transport_Troops_Chain',
            LandingChain = 'M2_UEF_Transport_Player_Drop_Chain2',
            TransportReturn = 'M2_UEF_Naval_Base_Marker',
        },
        Priority = 1000,
    })
    opai:SetChildQuantity('T2Transports', 2)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 2, categories.uea0104})

    -- Drops
	quantity = {8, 12, 14}
	for i = 2, Difficulty do
		opai = UEFNavyBase:AddOpAI('BasicLandAttack', 'M2_UEF_NavalBase_Drop_' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M2_UEF_Transport_Troops_Chain',
				LandingChain = 'M2_UEF_Transport_Player_Drop_Chain2',
				TransportReturn = 'M2_UEF_Naval_Base_Marker',
			},
			Priority = 250,
		})
		opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 120})
	end
	
	quantity = {8, 12, 14}
	for i = 1, Difficulty do
		opai = UEFNavyBase:AddOpAI('BasicLandAttack', 'M2_UEF_NavalBase_Drop2_' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M1_UEF_Transport_Troops_Chain',
				LandingChain = 'M2_UEF_Transport_Player_Drop_Chain',
				TransportReturn = 'M2_UEF_Naval_Base_Marker',
			},
			Priority = 250,
		})
		opai:SetChildQuantity('LightTanks', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 150})
	end

	quantity = {6, 9, 12}
	for i = 3, Difficulty do
		opai = UEFNavyBase:AddOpAI('BasicLandAttack', 'M2_UEF_NavalBase_Drop3_' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M1_UEF_Transport_Troops_Chain',
				LandingChain = 'M2_UEF_Transport_Player_Drop_Chain',
				TransportReturn = 'M2_UEF_Naval_Base_Marker',
			},
			Priority = 225,
		})
		opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
	end
	
	local Temp = {
		'P2landB1AttackTemp1',
		'NoPlan',
		{ 'uel0203', 1, 6, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2landB1AttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

end

function DisableBase()
    if (UEFNavyBase) then
        UEFNavyBase:BaseActive(false)
    end
end