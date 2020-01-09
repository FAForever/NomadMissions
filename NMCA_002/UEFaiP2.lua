local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local P2UBase1 = BaseManager.CreateBaseManager()
local P2UBase2 = BaseManager.CreateBaseManager()
local P2UBase3 = BaseManager.CreateBaseManager()

local UBase1Delay = {12*60, 10*60, 8*60}

function P2UEFBase1AI()
    P2UBase1:InitializeDifficultyTables(ArmyBrains[UEF], 'P2UEFBase1', 'P2UB1MK', 70, {P2UBase1 = 100})
    P2UBase1:StartNonZeroBase({{11, 15, 20}, {9, 13, 18}})

	P2UB1AirAttacks1()
	P2UB1NavalAttacks1()
	P2UB1LandAttacks1()
end

function P2UB1AirAttacks1()
	
	local Temp = {
		'P2UB1AirAttackTemp0',
		'NoPlan',
		{ 'dea0202', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uea0204', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uea0102', 1, 8, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2UB1AirAttackBuilder0',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 200,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase1',
		PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
		PlatoonData = {
			PatrolChain = 'P2UB1Airdefense1'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB1AirAttackTemp1',
		'NoPlan',
		{ 'dea0202', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uea0102', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB1AirAttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase1',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Airattack1','P2UB1Airattack2', 'P2UB1Airattack3', 'P2UB1Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB1AirAttackTemp2',
		'NoPlan',
		{ 'uea0203', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uea0103', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB1AirAttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase1',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Airattack1','P2UB1Airattack2', 'P2UB1Airattack3', 'P2UB1Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB1AirAttackTemp3',
		'NoPlan',
		{ 'uea0203', 1, 3, 'Attack', 'GrowthFormation' },
		{ 'dea0202', 1, 3, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB1AirAttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase1',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Airattack1','P2UB1Airattack2', 'P2UB1Airattack3', 'P2UB1Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB1AirAttackTemp4',
		'NoPlan',
		{ 'uea0103', 1, 5, 'Attack', 'GrowthFormation' },
		{ 'uea0102', 1, 5, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB1AirAttackBuilder4',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase1',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Airattack1','P2UB1Airattack2', 'P2UB1Airattack3', 'P2UB1Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
end

function P2UB1NavalAttacks1()
	
	local Temp = {
       'P2UB1NavalAttackTemp0',
       'NoPlan',
       { 'ues0103', 1, 6, 'Attack', 'GrowthFormation' }, --Frigates
	   { 'ues0203', 1, 4, 'Attack', 'GrowthFormation' }, --Subs
    }
    local Builder = {
       BuilderName = 'P2UB1NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 103,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Navalattack1','P2UB1Navalattack2', 'P2UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P2UB1NavalAttackTemp1',
       'NoPlan',
       { 'ues0201', 1, 1, 'Attack', 'GrowthFormation' }, --Destroyers
	   { 'ues0203', 1, 3, 'Attack', 'GrowthFormation' }, --Subs
    }
    Builder = {
       BuilderName = 'P2UB1NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 102,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Navalattack1','P2UB1Navalattack2', 'P2UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P2UB1NavalAttackTemp2',
       'NoPlan',
       { 'ues0202', 1, 1, 'Attack', 'GrowthFormation' }, --Crusiers
	   { 'ues0103', 1, 3, 'Attack', 'GrowthFormation' }, --Frigates
    }
    Builder = {
       BuilderName = 'P2UB1NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 101,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Navalattack1','P2UB1Navalattack2', 'P2UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P2UB1NavalAttackTemp3',
       'NoPlan',
       { 'xes0102', 1, 2, 'Attack', 'GrowthFormation' }, --Torp boats
	   { 'ues0203', 1, 4, 'Attack', 'GrowthFormation' }, --subs
    }
    Builder = {
       BuilderName = 'P2UB1NavalAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Navalattack1','P2UB1Navalattack2', 'P2UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P2UB1NavalAttackTemp4',
       'NoPlan',
       { 'ues0201', 1, 2, 'Attack', 'GrowthFormation' }, --Destroyers
	   { 'ues0203', 1, 5, 'Attack', 'GrowthFormation' }, --Subs
	   { 'ues0103', 1, 5, 'Attack', 'GrowthFormation' }, --Frigates
    }
    Builder = {
       BuilderName = 'P2UB1NavalAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 200,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P2UB1Navaldefense2'
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	
end

function P2UB1LandAttacks1()
	local opai = nil
    local quantity = {}

    -- Transport Builder
    opai = P2UBase1:AddOpAI('EngineerAttack', 'M2_UEF_TransportAttack_Builder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {

            TransportReturn = 'P2UB1MK',
        },
        Priority = 1000,
    })
    opai:SetChildQuantity('T2Transports', 4)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 2, categories.uea0104})

	quantity = {10, 12, 14}
		opai = P2UBase1:AddOpAI('BasicLandAttack', 'M2_UEF_TransportAttack_1',
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'P2UB1Dropattack1',
				LandingChain = 'P2UB1Drop1',
				TransportReturn = 'P2UB1MK',
			},
			Priority = 100,
		})
		opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
		
	quantity = {4, 4, 6}
	
		opai = P2UBase1:AddOpAI('BasicLandAttack', 'M2_UEF_TransportAttack_2',
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'P2UB1Dropattack1',
				LandingChain = 'P2UB1Drop1',
				TransportReturn = 'P2UB1MK',
			},
			Priority = 100,
		})
		opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 240})
	
	quantity = {10, 12, 14}
		opai = P2UBase1:AddOpAI('BasicLandAttack', 'M2_UEF_TransportAttack_3',
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'P2UB1Dropattack2',
				LandingChain = 'P2UB1Drop2',
				TransportReturn = 'P2UB1MK',
			},
			Priority = 100,
		})
		opai:SetChildQuantity('LightTanks', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 240})
	
	
	quantity = {4, 4, 6}
		opai = P2UBase1:AddOpAI('BasicLandAttack', 'M2_UEF_TransportAttack_4',
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'P2UB1Dropattack2',
				LandingChain = 'P2UB1Drop2',
				TransportReturn = 'P2UB1MK',
			},
			Priority = 100,
		})
		opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
	
    local Temp = {
		'P2UB1LandAttackTemp0',
		'NoPlan',
		{ 'uel0203', 1, 5, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2UB1LandAttackBuilder0',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 200,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase1',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB1Landattack1','P2UB1Landattack2'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
   
	
end

function P2UEFBase2AI()
    P2UBase2:InitializeDifficultyTables(ArmyBrains[UEF], 'P2UEFBase2', 'P2UB2MK', 70, {P2UBase2 = 100})
    P2UBase2:StartNonZeroBase({{9, 12, 16}, {7, 10, 14}})
    
	P2UB2LandAttacks1()
	P2UB2AirAttacks1()
	ForkThread(
        function()
        WaitSeconds(UBase1Delay[Difficulty])
		P2UB2LandAttacks2()
	end)
	
end

function P2UB2LandAttacks1()
    
	opai = P2UBase2:AddOpAI('EngineerAttack', 'M1_West_Reclaim_Engineers',
    {
        MasterPlatoonFunction = {SPAIFileName, 'SplitPatrolThread'},
        PlatoonData = {
            PatrolChains = {'P2UB2Landattack1', 'P2UB2Landattack2'},
        },
        Priority = 111,
    })
    opai:SetChildQuantity('T2Engineers', 2)
	
    local Temp = {
		'P2UB2LandAttackTemp0',
		'NoPlan',
		{ 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uel0201', 1, 4, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2UB2LandAttackBuilder0',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 110,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2LandAttackTemp1',
		'NoPlan',
		{ 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uel0103', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2LandAttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 109,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2LandAttackTemp2',
		'NoPlan',
		{ 'uel0307', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uel0201', 1, 8, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2LandAttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 108,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2LandAttackTemp3',
		'NoPlan',
		{ 'uel0111', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uel0201', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2LandAttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 107,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2LandAttackTemp4',
		'NoPlan',
		{ 'uel0202', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uel0103', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2LandAttackBuilder4',
		PlatoonTemplate = Temp,
		InstanceCount = 3,
		Priority = 106,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
   

end

function P2UB2LandAttacks2()

    local Temp = {
		'P2UB2LandAttackTemp5',
		'NoPlan',
		{ 'uel0307', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uel0201', 1, 6, 'Attack', 'GrowthFormation' },
		{ 'uel0202', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uel0104', 1, 4, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2UB2LandAttackBuilder5',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 200,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2LandAttackTemp6',
		'NoPlan',
		{ 'uel0307', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uel0201', 1, 6, 'Attack', 'GrowthFormation' },
		{ 'uel0111', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uel0104', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2LandAttackBuilder6',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 200,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2LandAttackTemp7',
		'NoPlan',
		{ 'uel0307', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uel0201', 1, 12, 'Attack', 'GrowthFormation' },
		{ 'uel0205', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2LandAttackBuilder7',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 200,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2LandAttackTemp8',
		'NoPlan',
		{ 'uel0307', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uel0202', 1, 8, 'Attack', 'GrowthFormation' },
		{ 'uel0205', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2LandAttackBuilder8',
		PlatoonTemplate = Temp,
		InstanceCount = 3,
		Priority = 200,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Landattack1','P2UB2Landattack2', 'P2UB2Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

end

function P2UB2AirAttacks1()
	
	local Temp = {
		'P2UB2AirAttackTemp0',
		'NoPlan',
		{ 'dea0202', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uea0203', 1, 3, 'Attack', 'GrowthFormation' },
		{ 'uea0102', 1, 8, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2UB2AirAttackBuilder0',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 200,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
		PlatoonData = {
			PatrolChain = 'P2UB2Airdefense1'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2AirAttackTemp1',
		'NoPlan',
		{ 'uea0102', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'uea0103', 1, 3, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2AirAttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Airattack1','P2UB2Airattack2', 'P2UB2Airattack3', 'P2UB2Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2AirAttackTemp2',
		'NoPlan',
		{ 'uea0103', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uea0203', 1, 2, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2AirAttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Airattack1','P2UB2Airattack2', 'P2UB2Airattack3', 'P2UB2Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2AirAttackTemp3',
		'NoPlan',
		{ 'uea0103', 1, 6, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2AirAttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Airattack1','P2UB2Airattack2', 'P2UB2Airattack3', 'P2UB2Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB2AirAttackTemp4',
		'NoPlan',
		{ 'uea0203', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB2AirAttackBuilder4',
		PlatoonTemplate = Temp,
		InstanceCount = 4,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase2',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB2Airattack1','P2UB2Airattack2', 'P2UB2Airattack3', 'P2UB2Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
end

function P2UEFBase3AI()
    P2UBase3:InitializeDifficultyTables(ArmyBrains[UEF], 'P2UEFBase3', 'P2UB3MK', 70, {P2UBase3 = 100})
    P2UBase3:StartEmptyBase({{11, 15, 20}, {9, 13, 18}})
	P2UBase3.MaximumConstructionEngineers = 9
	
	P2UB3AirAttacks1()
	P2UB3NavalAttacks1()
	P2UB3LandAttacks1()
end

function P2UB3AirAttacks1()
	
	local Temp = {
		'P2UB3AirAttackTemp0',
		'NoPlan',
		{ 'dea0202', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uea0203', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'uea0102', 1, 8, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2UB3AirAttackBuilder0',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 200,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase3',
		PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
		PlatoonData = {
			PatrolChain = 'P2UB3Airdefense1'
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB3AirAttackTemp1',
		'NoPlan',
		{ 'dea0202', 1, 6, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB3AirAttackBuilder1',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase3',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB3Airattack1','P2UB3Airattack2', 'P2UB3Airattack3', 'P2UB3Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB3AirAttackTemp2',
		'NoPlan',
		{ 'uea0203', 1, 6, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB3AirAttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 2,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase3',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB3Airattack1','P2UB3Airattack2', 'P2UB3Airattack3', 'P2UB3Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
		'P2UB3AirAttackTemp3',
		'NoPlan',
		{ 'uea0203', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'dea0202', 1, 4, 'Attack', 'GrowthFormation' },
	}
	Builder = {
		BuilderName = 'P2UB3AirAttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 4,
		Priority = 100,
		PlatoonType = 'Air',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase3',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB3Airattack1','P2UB3Airattack2', 'P2UB3Airattack3', 'P2UB3Airattack4'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
end

function P2UB3NavalAttacks1()
	
	local Temp = {
       'P2UB3NavalAttackTemp0',
       'NoPlan',
       { 'ues0103', 1, 3, 'Attack', 'GrowthFormation' }, --Frigates
	   { 'ues0202', 1, 2, 'Attack', 'GrowthFormation' }, 
    }
    local Builder = {
       BuilderName = 'P2UB3NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 102,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2UEFBase3',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB3Navalattack1','P2UB3Navalattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P2UB3NavalAttackTemp1',
       'NoPlan',
       { 'ues0203', 1, 3, 'Attack', 'GrowthFormation' }, --Frigates
	   { 'ues0201', 1, 2, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P2UB3NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 101,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2UEFBase3',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB3Navalattack1','P2UB3Navalattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P2UB3NavalAttackTemp2',
       'NoPlan',
       { 'ues0203', 1, 7, 'Attack', 'GrowthFormation' }, --Frigates
    }
    Builder = {
       BuilderName = 'P2UB3NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2UEFBase3',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB3Navalattack1','P2UB3Navalattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

end

function P2UB3LandAttacks1()

    local Temp = {
		'P2UB3LandAttackTemp0',
		'NoPlan',
		{ 'uel0203', 1, 6, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'P2UB3LandAttackBuilder0',
		PlatoonTemplate = Temp,
		InstanceCount = 3,
		Priority = 200,
		PlatoonType = 'Land',
		RequiresConstruction = true,
		LocationType = 'P2UEFBase3',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2UB3Landattack1','P2UB3Landattack2', 'P2UB3Landattack3'}
       },
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	local opai = nil
    local quantity = {}

    -- Transport Builder
    opai = P2UBase3:AddOpAI('EngineerAttack', 'M2B3_UEF_TransportAttack_Builder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {

            TransportReturn = 'P2UB3MK',
        },
        Priority = 1000,
    })
    opai:SetChildQuantity('T2Transports', 4)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 2, categories.uea0104})

	quantity = {10, 12, 14}
		opai = P2UBase3:AddOpAI('BasicLandAttack', 'M2B3_UEF_TransportAttack_1',
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'P2UB3Dropattack1',
				LandingChain = 'P2UB3Drop1',
				TransportReturn = 'P2UB3MK',
			},
			Priority = 100,
		})
		opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
		
	quantity = {4, 4, 6}
	
		opai = P2UBase3:AddOpAI('BasicLandAttack', 'M2B3_UEF_TransportAttack_2',
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'P2UB3Dropattack1',
				LandingChain = 'P2UB3Drop1',
				TransportReturn = 'P2UB3MK',
			},
			Priority = 100,
		})
		opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 160})
		
		quantity = {4, 4, 6}
	
		opai = P2UBase3:AddOpAI('BasicLandAttack', 'M2B3_UEF_TransportAttack_3',
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'P2UB3Dropattack2',
				LandingChain = 'P2UB3Drop2',
				TransportReturn = 'P2UB3MK',
			},
			Priority = 100,
		})
		opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
		opai:SetLockingStyle('DeathTimer', {LockTimer = 160})
	
end
	
	
	

