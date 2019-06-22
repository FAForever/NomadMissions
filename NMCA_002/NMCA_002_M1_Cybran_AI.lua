local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local Cybran = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local CybranAirBase = BaseManager.CreateBaseManager()

function CybranAirBaseAI()
    CybranAirBase:Initialize(ArmyBrains[Cybran], 'M1_AirBase', 'M1_Cybran_Air_Base_Marker', 50, {M1_CybranAirbase = 100})
    CybranAirBase:StartNonZeroBase({{4, 6, 8}, {2, 4, 6}})

	M1CybranAirAttacks()
end

function M1CybranAirAttacks()


    local quantity = {}

	quantity = {3, 4, 5}
	local Temp = {
       'CybranAirM1AttackTemp0',
       'NoPlan',
       { 'ura0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters  
    }
    local Builder = {
       BuilderName = 'CybranAirM1AttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M1_AirBase',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'M1_Cybran_Air_Attack1','M1_Cybran_Air_Attack2', 'M1_Cybran_Air_Attack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
	
	quantity = {4, 5, 6}
	Temp = {
       'CybranAirM1AttackTemp1',
       'NoPlan',
       { 'ura0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Bombers  
    }
    Builder = {
       BuilderName = 'CybranAirM1AttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M1_AirBase',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'M1_Cybran_Air_Attack1','M1_Cybran_Air_Attack2', 'M1_Cybran_Air_Attack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
	
	Temp = {
       'CybranAirM1AttackTemp2',
       'NoPlan',
       { 'ura0103', 1, 6, 'Attack', 'GrowthFormation' }, --Bombers
       { 'ura0102', 1, 9, 'Attack', 'GrowthFormation' }, --Fighters 	   
    }
    Builder = {
       BuilderName = 'CybranAirM1AttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M1_AirBase',
      PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'M1_Cybran_Air_Defence'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function M1CybranAirAttacks2()

    local quantity = {}

	quantity = {3, 4, 5}
	
	local Temp = {
       'CybranAirB1M2AttackTemp0',
       'NoPlan',
       { 'ura0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters  
    }
    local Builder = {
       BuilderName = 'CybranAirB1M2AttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M1_AirBase',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'M2_Cybran_UEF_Air_Attack_Chain1','M2_Cybran_UEF_Air_Attack_Chain2', 'M2_Cybran_UEF_Air_Attack_Chain3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
	
	Temp = {
       'CybranAirB1M2AttackTemp1',
       'NoPlan',
       { 'ura0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Bombers  
    }
    Builder = {
       BuilderName = 'CybranAirB1M2AttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M1_AirBase',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'M2_Cybran_UEF_Air_Attack_Chain1','M2_Cybran_UEF_Air_Attack_Chain2', 'M2_Cybran_UEF_Air_Attack_Chain3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
	
end

function DisableBase()
    if (CybranAirBase) then
        CybranAirBase:BaseActive(false)
    end
end
