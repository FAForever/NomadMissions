local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local Cybran = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local CybranMainBase = BaseManager.CreateBaseManager()

function CybranMainBaseAI()
    CybranMainBase:Initialize(ArmyBrains[Cybran], 'M2_MainBase', 'M2_Cybran_Main_Base_Marker', 200, {M2_MainBase = 100})
    CybranMainBase:StartNonZeroBase({{14, 12, 10}, {12, 10, 8}})

	CybranMainBase:AddBuildGroup('M2_MainBase_Navy', 90, false)

	M2CybranLandAttacks()
	M2CybranNavalAttacks()
	M2CybranAirAttacks()
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

	opai = CybranMainBase:AddOpAI('BasicLandAttack', 'M2_Cybran_Land_Patrol_3', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_Extra_Land_Patrol_Chain'
           },
           Priority = 250,
		}
	)
	opai:SetChildQuantity('MobileFlak', 6)
	
	local Temp = {
		'CybranlandP2AttackTemp1',
		'NoPlan',
		{ 'url0202', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'url0107', 1, 6, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'CybranlandP2Builder1',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'M2_MainBase',
		PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
		PlatoonData = {
			PatrolChain = 'M2_Cybran_Artillery_Attack_Chain'
		},
	}
	ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function M2CybranAirAttacks()
	-- Send a couple of air attacks at the UEF, nothing major as we're not intending to do much damage.
	local opai = nil
	
	local Temp = {
       'CybranAirM2AttackTemp0',
       'NoPlan',
       { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships
       { 'ura0102', 1, 9, 'Attack', 'GrowthFormation' }, --Fighters  	   
    }
    local Builder = {
       BuilderName = 'CybranAirM2AttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 300,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M2_MainBase',
      PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'M2_Cybran_Main_Base_Air_Patrol_Chain'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
	
	opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_1', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_UEF_Air_Attack_Chain1'
           },
           Priority = 200,
		}
	)
	opai:SetChildQuantity('Bombers', 5)

	opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_2', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_UEF_Air_Attack_Chain2'
           },
           Priority = 175,
		}
	)
	opai:SetChildQuantity('Interceptors', 6)

	opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_3', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_UEF_Air_Attack_Chain3'
           },
           Priority = 150,
		}
	)
	opai:SetChildQuantity('Gunships', 3)
	
	opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_4', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_Artillery_Attack_Chain'
           },
           Priority = 150,
		}
	)
	opai:SetChildQuantity('Bombers', 5)
	
	opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_5', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_Cybran_Artillery_Attack_Chain'
           },
           Priority = 150,
		}
	)
	opai:SetChildQuantity('Interceptors', 6)

	quantity = {10, 8, 6}
    opai = CybranMainBase:AddOpAI('AirAttacks', 'M2_Cybran_Air_Attack_6',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
            PlatoonData = {
              CategoryList = { categories.NAVAL * categories.UEF },
            },
            Priority = 125,
        }
    )
    opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
end

function M3CybranAttacks()
    --Cybran attacks on Main UEF base, will hit a wall without Player support
    local Temp = {
       'CybranLandM3AttackTemp0',
       'NoPlan',
       { 'url0303', 1, 2, 'Attack', 'GrowthFormation' }, --Seige Bots
       { 'url0202', 1, 6, 'Attack', 'GrowthFormation' }, --Heavy tanks   	   
    }
    local Builder = {
       BuilderName = 'CybranLandM3AttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 300,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'M2_MainBase',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'M3_Cybran_Landattack1','M3_Cybran_Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
	
	Temp = {
       'CybranLandM3AttackTemp1',
       'NoPlan',
       { 'url0202', 1, 5, 'Attack', 'GrowthFormation' }, --Heavy tanks
       { 'url0111', 1, 5, 'Attack', 'GrowthFormation' }, --MML    	   
    }
    Builder = {
       BuilderName = 'CybranLandM3AttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 300,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'M2_MainBase',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'M3_Cybran_Landattack1','M3_Cybran_Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
	
	Temp = {
       'CybranAirM3AttackTemp0',
       'NoPlan',
       { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships
       { 'ura0102', 1, 6, 'Attack', 'GrowthFormation' }, --Fighters    
    }
    Builder = {
       BuilderName = 'CybranAirM3AttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 300,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M2_MainBase',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'M3_Cybran_Airattack1','M3_Cybran_Airattack2', 'M3_Cybran_Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
	
	Temp = {
       'CybranNavalM3AttackTemp0',
       'NoPlan',
       { 'urs0103', 1, 4, 'Attack', 'GrowthFormation' }, --Frigates
       { 'urs0203', 1, 4, 'Attack', 'GrowthFormation' }, --Subs   	   
    }
    Builder = {
       BuilderName = 'CybranNavalM3AttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 300,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'M2_MainBase',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'M3_Cybran_Navalattack1'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )


end
