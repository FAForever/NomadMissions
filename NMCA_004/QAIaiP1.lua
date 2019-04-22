local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'
local ScenarioFramework = import('/lua/ScenarioFramework.lua')

local Player1 = 1
local Nomads = 2
local QAI = 3

local N1P1Base1 = BaseManager.CreateBaseManager()
local N1P1Base2 = BaseManager.CreateBaseManager()
local Q1P1Base1 = BaseManager.CreateBaseManager()
local Q1P1Base2 = BaseManager.CreateBaseManager()
local Difficulty = ScenarioInfo.Options.Difficulty

function P1NBase1AI()

    N1P1Base1:Initialize(ArmyBrains[Nomads], 'P1NomadBase1', 'P1NB1MK', 75, {P1Nbase1 = 500})
    N1P1Base1:StartNonZeroBase(4)

end

function P1NBase2AI()

    N1P1Base2:Initialize(ArmyBrains[Nomads], 'P1NomadBase2', 'P1NB2MK', 75, {P1Nbase2 = 500})
    N1P1Base2:StartNonZeroBase(4)

end

function P1Q1base1AI()

    Q1P1Base1:InitializeDifficultyTables(ArmyBrains[QAI], 'P1QAIBase1', 'P1QB1MK', 85, {P1Qbase1 = 500})
    Q1P1Base1:StartNonZeroBase({{7,10,13}, {5,8,11}})
	
	P1QB1Airattacks1()
	P1QB1landattacks1()
	
	ForkThread(
	function()
	WaitSeconds(12*60)
	P1QB1Airattacks2()
	P1QB1landattacks2()
	end
	)
	
end

function P1Q1base2AI()

    Q1P1Base2:InitializeDifficultyTables(ArmyBrains[QAI], 'P1QAIBase2', 'P1QB2MK', 85, {P1Qbase2 = 500})
    Q1P1Base2:StartNonZeroBase({{7,10,13}, {5,8,11}})
	
	ForkThread(
	function()
	WaitSeconds(1*60)
	P1QB2Airattacks1()
	P1QB2landattacks1()
	end
	)
	
	ForkThread(
	function()
	WaitSeconds(12*60)
	P1QB1Airattacks2()
	P1QB1landattacks2()
	end
	)
end

function P1QB1Airattacks1()

    local Temp = {
       'P1QB1AirattackTemp0',
       'NoPlan',
       { 'ura0103', 1, 3, 'Attack', 'GrowthFormation' },	       
    }
    local Builder = {
       BuilderName = 'P1QB1AirattackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
     PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Airattack1', 'P1QB1Airattack2', 'P1QB1Airattack3', 'P1QB1Airattack4'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB1AirattackTemp1',
       'NoPlan',
       { 'ura0102', 1, 3, 'Attack', 'GrowthFormation' },	       
    }
    Builder = {
       BuilderName = 'P1QB1AirattackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
     PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Airattack1', 'P1QB1Airattack2', 'P1QB1Airattack3', 'P1QB1Airattack4'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	

end

function P1QB1landattacks1()

    local Temp = {
       'P1QB1LandattackTemp0',
       'NoPlan',
       { 'url0104', 1, 2, 'Attack', 'GrowthFormation' },   
       { 'url0107', 1, 6, 'Attack', 'GrowthFormation' },     
    }
    local Builder = {
       BuilderName = 'P1QB1LandattackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Landattack1', 'P1QB1Landattack2'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB1LandattackTemp1',
       'NoPlan',
       { 'url0103', 1, 6, 'Attack', 'GrowthFormation' },        
    }
    Builder = {
       BuilderName = 'P1QB1LandattackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Landattack1', 'P1QB1Landattack2'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB1LandattackTemp2',
       'NoPlan',
       { 'url0107', 1, 8, 'Attack', 'GrowthFormation' },        
    }
    Builder = {
       BuilderName = 'P1QB1LandattackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Landattack1', 'P1QB1Landattack2'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )

end

function P1QB1Airattacks2()

    local Temp = {
       'P1QB1AirattackTemp4',
       'NoPlan',   
       { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' },     
    }
    local Builder = {
       BuilderName = 'P1QB1AirattackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Airattack1', 'P1QB1Airattack2', 'P1QB1Airattack3', 'P1QB1Airattack4'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB1AirattackTemp5',
       'NoPlan',  
       { 'dra0202', 1, 4, 'Attack', 'GrowthFormation' },     
    }
    Builder = {
       BuilderName = 'P1QB1AirattackBuilder5',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Airattack1', 'P1QB1Airattack2', 'P1QB1Airattack3', 'P1QB1Airattack4'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )

end

function P1QB1landattacks2()

    local Temp = {
       'P1QB1LandattackTemp3',
       'NoPlan',   
       { 'ura0202', 1, 6, 'Attack', 'GrowthFormation' },     
    }
    local Builder = {
       BuilderName = 'P3QB1AirAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 200,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Landattack1', 'P1QB1Landattack2'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB1LandattackTemp4',
       'NoPlan',
       { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' },       
    }
    Builder = {
       BuilderName = 'P3QB1AirAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 200,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Landattack3', 'P1QB1Landattack4'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB1LandattackTemp5',
       'NoPlan',
       { 'ura0111', 1, 3, 'Attack', 'GrowthFormation' },       
    }
    Builder = {
       BuilderName = 'P3QB1AirAttackBuilder5',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 200,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB1Landattack1', 'P1QB1Landattack2'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
end

function P1QB2Airattacks1()

    local Temp = {
       'P1QB2AirattackTemp0',
       'NoPlan',
       { 'ura0103', 1, 3, 'Attack', 'GrowthFormation' },	       
    }
    local Builder = {
       BuilderName = 'P1QB2AirattackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase2',
     PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB2Airattack1', 'P1QB2Airattack2', 'P1QB2Airattack3'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB2AirattackTemp1',
       'NoPlan',
       { 'ura0102', 1, 3, 'Attack', 'GrowthFormation' },	       
    }
    Builder = {
       BuilderName = 'P1QB2AirattackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase2',
     PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB2Airattack1', 'P1QB2Airattack2', 'P1QB2Airattack3'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	

end

function P1QB2landattacks1()

    local Temp = {
       'P1QB2LandattackTemp0',
       'NoPlan',
       { 'url0202', 1, 2, 'Attack', 'GrowthFormation' },   
       { 'url0107', 1, 4, 'Attack', 'GrowthFormation' },     
    }
    local Builder = {
       BuilderName = 'P1QB2LandattackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 120,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase2',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB2Landattack1'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB2LandattackTemp1',
       'NoPlan',
       { 'url0107', 1, 6, 'Attack', 'GrowthFormation' },        
    }
    Builder = {
       BuilderName = 'P1QB2LandattackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 101,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase2',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB2Landattack1'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	local opai = Q1P1Base2:AddOpAI('EngineerAttack', 'M1_Cybran_TransportBuilder1',
    {
        MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'LandAssaultWithTransports'},
        PlatoonData = {
            TransportReturn = 'P1QB2MK',
        },
        Priority = 1000,
    })
    opai:SetChildQuantity('T2Transports', 2)
    opai:SetLockingStyle('None')
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 2, categories.ura0104})
   
    opai = Q1P1Base2:AddOpAI('BasicLandAttack', 'M1_Cybran_TransportAttack_1',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain =  'P1QB2Dropattack1', 
                LandingChain = 'P1QB2Drop1',
                TransportReturn = 'P1QB2MK',
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('LightArtillery', 10)
    opai:SetLockingStyle('DeathTimer', {LockTimer = 120})
	
	opai = Q1P1Base2:AddOpAI('BasicLandAttack', 'M1_Cybran_TransportAttack_2',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain =  'P1QB2Dropattack2', 
                LandingChain = 'P1QB2Drop2',
                TransportReturn = 'P1QB2MK',
            },
            Priority = 110,
        }
    )
    opai:SetChildQuantity('LightArtillery', 10)
    opai:SetLockingStyle('DeathTimer', {LockTimer = 60})

end

function P1QB2Airattacks2()

    local Temp = {
       'P1QB2AirattackTemp3',
       'NoPlan',
       { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' },	       
    }
    local Builder = {
       BuilderName = 'P1QB2AirattackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase2',
     PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB2Airattack1', 'P1QB2Airattack2', 'P1QB2Airattack3'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	Temp = {
       'P1QB2AirattackTemp4',
       'NoPlan',
       { 'dra0202', 1, 4, 'Attack', 'GrowthFormation' },	       
    }
    Builder = {
       BuilderName = 'P1QB2AirattackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase2',
     PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB2Airattack1', 'P1QB2Airattack2', 'P1QB2Airattack3'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
end

function P1QB2landattacks2()

    local Temp = {
       'P1QB2LandattackTemp2',
       'NoPlan',
       { 'url0202', 1, 7, 'Attack', 'GrowthFormation' },   
       { 'url0306', 1, 2, 'Attack', 'GrowthFormation' },     
    }
    local Builder = {
       BuilderName = 'P1QB2LandattackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 200,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1QAIBase2',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1QB2Landattack1'}
       },
    }
    ArmyBrains[QAI]:PBMAddPlatoon( Builder )
	
	opai = Q1P1Base2:AddOpAI('BasicLandAttack', 'M1_Cybran_TransportAttack_1',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain =  'P1QB2Dropattack1', 
                LandingChain = 'P1QB2Drop1',
                TransportReturn = 'P1QB2MK',
            },
            Priority = 210,
        }
    )
    opai:SetChildQuantity('HeavyTanks', 8)
    opai:SetLockingStyle('DeathTimer', {LockTimer = 120})
	
	opai = Q1P1Base2:AddOpAI('BasicLandAttack', 'M1_Cybran_TransportAttack_2',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain =  'P1QB2Dropattack2', 
                LandingChain = 'P1QB2Drop2',
                TransportReturn = 'P1QB2MK',
            },
            Priority = 210,
        }
    )
    opai:SetChildQuantity('HeavyTanks', 8)
    opai:SetLockingStyle('DeathTimer', {LockTimer = 90})
	
	opai = Q1P1Base2:AddOpAI('BasicLandAttack', 'M1_Cybran_TransportAttack_2',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain =  'P1QB2Dropattack3', 
                LandingChain = 'P1QB2Drop3',
                TransportReturn = 'P1QB2MK',
            },
            Priority = 210,
        }
    )
    opai:SetChildQuantity('HeavyTanks', 8)
    opai:SetLockingStyle('DeathTimer', {LockTimer = 60})
	
end


