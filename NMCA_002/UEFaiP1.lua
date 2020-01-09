local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local P1UBase1 = BaseManager.CreateBaseManager()
local P1UBase2 = BaseManager.CreateBaseManager()

local UBase1Delay = {7*60, 6*60, 5*60}

function P1UEFBase1AI()
    P1UBase1:InitializeDifficultyTables(ArmyBrains[UEF], 'P1UEFBase1', 'P1UB1MK', 70, {P1UBase1 = 100})
    P1UBase1:StartNonZeroBase({{5, 7, 9}, {4, 6, 8}})
    
	ForkThread(
        function()
        WaitSeconds(UBase1Delay[Difficulty])
	P1UB1AirAttacks()
	P1UB1NavalAttacks()
	end)
end

function P1UEFBase2AI()
    P1UBase2:InitializeDifficultyTables(ArmyBrains[UEF], 'P1UEFBase2', 'P1UB2MK', 40, {P1UBase2 = 100})
    P1UBase2:StartNonZeroBase({{4, 6, 8}, {2, 4, 6}})
	
	P1UB2LandAttacks()
end

function P1UB1AirAttacks()

    local quantity = {}

	quantity = {2, 3, 3}
	local Temp = {
       'P1UB1AirAttackTemp0',
       'NoPlan',
       { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters  
    }
    local Builder = {
       BuilderName = 'P1UB1AirAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1UB1Airattack1','P1UB1Airattack2', 'P1UB1Airattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	quantity = {2, 2, 3}
	Temp = {
       'P1UB1AirAttackTemp1',
       'NoPlan',
       { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters  
    }
    Builder = {
       BuilderName = 'P1UB1AirAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1UB1Airattack1','P1UB1Airattack2', 'P1UB1Airattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1UB1AirAttackTemp2',
       'NoPlan',
       { 'uea0103', 1, 6, 'Attack', 'GrowthFormation' }, --Bombers
       { 'uea0102', 1, 9, 'Attack', 'GrowthFormation' }, --Fighters 	   
    }
    Builder = {
       BuilderName = 'P1UB1AirAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase1',
      PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P1UB1AirPatrol'
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function P1UB1NavalAttacks()

    local quantity = {}

	quantity = {2, 3, 4}
	local Temp = {
       'P1UB1NavalAttackTemp0',
       'NoPlan',
       { 'ues0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Frigates 
    }
    local Builder = {
       BuilderName = 'P1UB1NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1UB1Navalattack1','P1UB1Navalattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	quantity = {2, 3, 4}
	Temp = {
       'P1UB1NavalAttackTemp1',
       'NoPlan',
       { 'ues0203', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Subs  
    }
    Builder = {
       BuilderName = 'P1UB1NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1UB1Navalattack1','P1UB1Navalattack2'}
		    },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1UB1NavalAttackTemp2',
       'NoPlan',
       { 'ues0103', 1, 6, 'Attack', 'GrowthFormation' }, --Frigates
       { 'ues0203', 1, 6, 'Attack', 'GrowthFormation' }, --Subs 	   
    }
    Builder = {
       BuilderName = 'P1UB1NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 200,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase1',
      PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P1UB1NavalPatrol1'
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	quantity = {2, 3, 4}
	Temp = {
       'P1UB1NavalAttackTemp3',
       'NoPlan',
       { 'ues0203', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Subs
	   { 'ues0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Subs  
    }
    Builder = {
       BuilderName = 'P1UB1NavalAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1UB1Navalattack1','P1UB1Navalattack2'}
		    },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
end

function P1UB2LandAttacks()

    local quantity = {}

	quantity = {2, 4, 5}
	local Temp = {
       'P1UB2LandAttackTemp0',
       'NoPlan',
       { 'uel0106', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --light bots  
    }
    local Builder = {
       BuilderName = 'P1UB2LandAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase2',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1UB2landattack1','P1UB2landattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	quantity = {2, 3, 4}
	Temp = {
       'P1UB2LandAttackTemp1',
       'NoPlan',
       { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --tanks  
    }
    Builder = {
       BuilderName = 'P1UB2LandAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase2',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1UB2landattack1','P1UB2landattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
	quantity = {2, 3, 4}
	Temp = {
       'P1UB2LandAttackTemp2',
       'NoPlan',
       { 'uel0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Arty  
    }
    Builder = {
       BuilderName = 'P1UB2LandAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1UEFBase2',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1UB2landattack1','P1UB2landattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
end
	
	
	