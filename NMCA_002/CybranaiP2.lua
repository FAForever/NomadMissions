local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local Cybran = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local P2CBase1 = BaseManager.CreateBaseManager()
local P3CBase1 = BaseManager.CreateBaseManager()


function CybranMainBaseAI()
    P2CBase1:Initialize(ArmyBrains[Cybran], 'P2CybranBase1', 'P2CB1MK', 80, {P2CBase1 = 100})
    P2CBase1:StartNonZeroBase({{14, 12, 10}, {12, 10, 8}})

end

function P3CybranBaseAI()
    P3CBase1:InitializeDifficultyTables(ArmyBrains[Cybran], 'P3CybranBase1', 'P3CB1MK', 110, {P3CBase1 = 100})
    P3CBase1:StartNonZeroBase({{14, 12, 10}, {12, 10, 8}})
    
    P3CB1Airattacks1()
    P3CB1Landattacks1()
    P3CB1Navalattacks1()
end

function P3CB1Airattacks1()
    
    local Temp = {
        'P3CB1AirAttackTemp0',
        'NoPlan',
        { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    local Builder = {
        BuilderName = 'P3CB1AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3CybranBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3CB1Airattack1','P3CB1Airattack2'}
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1AirAttackTemp1',
       'NoPlan',
       { 'ura0103', 1, 9, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3CB1AirAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Airattack1','P3CB1Airattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1AirAttackTemp2',
       'NoPlan',
       { 'ura0102', 1, 9, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3CB1AirAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Airattack1','P3CB1Airattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1AirAttackTemp3',
       'NoPlan',
       { 'dra0202', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3CB1AirAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Airattack1','P3CB1Airattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1AirAttackTemp4',
       'NoPlan',
       { 'dra0202', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships
       { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships 
       { 'ura0102', 1, 9, 'Attack', 'GrowthFormation' }, --Gunships 
       { 'ura0103', 1, 9, 'Attack', 'GrowthFormation' }, --Gunships 
    }
    Builder = {
       BuilderName = 'P3CB1AirAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
      PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P3CB1Airdefense1'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
end

function P3CB1Landattacks1()
    
    local Temp = {
       'P3CB1LandAttackTemp0',
       'NoPlan',
       { 'url0203', 1, 4, 'Attack', 'GrowthFormation' },   
    }
    local Builder = {
       BuilderName = 'P3CB1LandAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 5,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P3CB1Landattack1'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
end

function P3CB1Navalattacks1()
    
    local Temp = {
       'P3CB1NavalAttackTemp0',
       'NoPlan',
       { 'urs0201', 1, 2, 'Attack', 'GrowthFormation' }, 
       { 'urs0103', 1, 4, 'Attack', 'GrowthFormation' },
    }
    local Builder = {
       BuilderName = 'P3CB1NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Navalattack1','P3CB1Navalattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1NavalAttackTemp1',
       'NoPlan',
       { 'urs0202', 1, 2, 'Attack', 'GrowthFormation' }, 
       { 'urs0103', 1, 4, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P3CB1NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Navalattack1','P3CB1Navalattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1NavalAttackTemp2',
       'NoPlan',
       { 'urs0203', 1, 4, 'Attack', 'GrowthFormation' }, 
       { 'urs0103', 1, 4, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P3CB1NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Navalattack1','P3CB1Navalattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1NavalAttackTemp3',
       'NoPlan',
       { 'urs0203', 1, 4, 'Attack', 'GrowthFormation' }, 
       { 'urs0201', 1, 2, 'Attack', 'GrowthFormation' },
       { 'urs0202', 1, 2, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P3CB1NavalAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 200,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P3CB1Navaldefense1'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
end



