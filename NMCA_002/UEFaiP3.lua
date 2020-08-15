local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local P3UBase1 = BaseManager.CreateBaseManager()
local P3UBase2 = BaseManager.CreateBaseManager()
local P3UBase3 = BaseManager.CreateBaseManager()

function P3UEFBase1AI()
    P3UBase1:InitializeDifficultyTables(ArmyBrains[UEF], 'P3UEFBase1', 'P3UB1MK', 120, {P3UBase1 = 300})
    P3UBase1:StartNonZeroBase({{15, 22, 28}, {13, 20, 26}})
    
    P3UB1Airattacks1()
    P3UB1Landattacks1()
    P3UB1Navalattacks1()
end

function P3UEFBase2AI()
    P3UBase2:InitializeDifficultyTables(ArmyBrains[UEF], 'P3UEFBase2', 'P3UB2MK', 60, {P3UBase2 = 300})
    P3UBase2:StartNonZeroBase({{5, 6, 8}, {3, 4, 6}})
    
    P3UB2Landattacks1()
end

function P3UEFBase3AI()
    P3UBase3:InitializeDifficultyTables(ArmyBrains[UEF], 'P3UEFBase3', 'P3UB3MK', 70, {P3UBase3 = 300})
    P3UBase3:StartNonZeroBase({{5, 6, 8}, {3, 4, 6}})
    
    P3UB3Navalattacks1()
end

function P3UB1Airattacks1()
    
    local Temp = {
       'P3UB1AirAttackTemp0',
       'NoPlan',
       { 'uea0203', 1, 10, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    local Builder = {
       BuilderName = 'P3UB1AirAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Airattack1','P3UB1Airattack2', 'P3UB1Airattack3', 'P3UB1Airattack4', 'P3UB1Airattack5'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1AirAttackTemp1',
       'NoPlan',
       { 'dea0202', 1, 10, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3UB1AirAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Airattack1','P3UB1Airattack2', 'P3UB1Airattack3', 'P3UB1Airattack4', 'P3UB1Airattack5'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1AirAttackTemp2',
       'NoPlan',
       { 'dea0202', 1, 5, 'Attack', 'GrowthFormation' }, --Gunships
       { 'uea0203', 1, 5, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3UB1AirAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Airattack1','P3UB1Airattack2', 'P3UB1Airattack3', 'P3UB1Airattack4', 'P3UB1Airattack5'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1AirAttackTemp3',
       'NoPlan',
       { 'uea0103', 1, 15, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3UB1AirAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Airattack1','P3UB1Airattack2', 'P3UB1Airattack3', 'P3UB1Airattack4', 'P3UB1Airattack5'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1AirAttackTemp4',
       'NoPlan',
       { 'uea0102', 1, 15, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3UB1AirAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Airattack1','P3UB1Airattack2', 'P3UB1Airattack3', 'P3UB1Airattack4', 'P3UB1Airattack5'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )    
end

function P3UB1Landattacks1()
    
    local Temp = {
       'P3UB1LandAttackTemp0',
       'NoPlan',
       { 'uel0202', 1, 10, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0205', 1, 5, 'Attack', 'GrowthFormation' }, --Flak        
    }
    local Builder = {
       BuilderName = 'P3UB1LandAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Landattack1','P3UB1Landattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1LandAttackTemp1',
       'NoPlan',
       { 'uel0202', 1, 12, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0307', 1, 4, 'Attack', 'GrowthFormation' }, --Flak        
    }
    Builder = {
       BuilderName = 'P3UB1LandAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Landattack1','P3UB1Landattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1LandAttackTemp2',
       'NoPlan',
       { 'uel0202', 1, 8, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0307', 1, 4, 'Attack', 'GrowthFormation' }, --Flak
       { 'uel0111', 1, 4, 'Attack', 'GrowthFormation' }, --Flak
    }
    Builder = {
       BuilderName = 'P3UB1LandAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Landattack1','P3UB1Landattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1LandAttackTemp3',
       'NoPlan',
       { 'uel0202', 1, 10, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0307', 1, 2, 'Attack', 'GrowthFormation' }, --Flak
       { 'uel0111', 1, 4, 'Attack', 'GrowthFormation' }, --Flak
       { 'uel0205', 1, 4, 'Attack', 'GrowthFormation' }, --Flak
    }
    Builder = {
       BuilderName = 'P3UB1LandAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Landattack1','P3UB1Landattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1LandAttackTemp4',
       'NoPlan',
       { 'uel0202', 1, 6, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0307', 1, 2, 'Attack', 'GrowthFormation' }, --Sheild
       { 'del0204', 1, 6, 'Attack', 'GrowthFormation' }, --Bots
       { 'uel0205', 1, 4, 'Attack', 'GrowthFormation' }, --Flak
    }
    Builder = {
       BuilderName = 'P3UB1LandAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Landattack1','P3UB1Landattack2'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function P3UB1Navalattacks1()
    
    local Temp = {
       'P3UB1NavalAttackTemp0',
       'NoPlan',
       { 'ues0103', 1, 6, 'Attack', 'GrowthFormation' }, --Frigates
       { 'ues0203', 1, 6, 'Attack', 'GrowthFormation' }, --Subs        
    }
    local Builder = {
       BuilderName = 'P3UB1NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Navalattack1','P3UB1Navalattack2', 'P3UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1NavalAttackTemp1',
       'NoPlan',
       { 'ues0103', 1, 4, 'Attack', 'GrowthFormation' }, --Frigates
       { 'ues0202', 1, 2, 'Attack', 'GrowthFormation' }, --Crusiers        
    }
    Builder = {
       BuilderName = 'P3UB1NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Navalattack1','P3UB1Navalattack2', 'P3UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1NavalAttackTemp2',
       'NoPlan',
       { 'ues0203', 1, 4, 'Attack', 'GrowthFormation' }, --Subs
       { 'ues0201', 1, 2, 'Attack', 'GrowthFormation' }, --Destroyers      
    }
    Builder = {
       BuilderName = 'P3UB1NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Navalattack1','P3UB1Navalattack2', 'P3UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1NavalAttackTemp3',
       'NoPlan',
       { 'ues0202', 1, 2, 'Attack', 'GrowthFormation' }, --Subs
       { 'ues0201', 1, 3, 'Attack', 'GrowthFormation' }, --Destroyers      
    }
    Builder = {
       BuilderName = 'P3UB1NavalAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Navalattack1','P3UB1Navalattack2', 'P3UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB1NavalAttackTemp4',
       'NoPlan',
       { 'xes0102', 1, 2, 'Attack', 'GrowthFormation' }, --Subs
       { 'ues0201', 1, 3, 'Attack', 'GrowthFormation' }, --Destroyers      
    }
    Builder = {
       BuilderName = 'P3UB1NavalAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB1Navalattack1','P3UB1Navalattack2', 'P3UB1Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function P3UB2Landattacks1()
    
    local Temp = {
       'P3UB2LandAttackTemp0',
       'NoPlan',
       { 'uel0202', 1, 6, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0205', 1, 2, 'Attack', 'GrowthFormation' }, --Flak        
    }
    local Builder = {
       BuilderName = 'P3UB2LandAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase2',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB2Landattack1','P3UB2Landattack2', 'P3UB2Landattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB2LandAttackTemp1',
       'NoPlan',
       { 'uel0202', 1, 8, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0307', 1, 2, 'Attack', 'GrowthFormation' }, --Flak        
    }
    Builder = {
       BuilderName = 'P3UB2LandAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase2',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB2Landattack1','P3UB2Landattack2', 'P3UB2Landattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB2LandAttackTemp2',
       'NoPlan',
       { 'del0204', 1, 6, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0111', 1, 3, 'Attack', 'GrowthFormation' }, --Flak        
    }
    Builder = {
       BuilderName = 'P3UB2LandAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase2',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB2Landattack1','P3UB2Landattack2', 'P3UB2Landattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB2LandAttackTemp3',
       'NoPlan',
       { 'del0204', 1, 4, 'Attack', 'GrowthFormation' }, --Heavy tanks
       { 'uel0202', 1, 4, 'Attack', 'GrowthFormation' }, --Heavy tanks  
       { 'uel0307', 1, 2, 'Attack', 'GrowthFormation' }, --Flak        
    }
    Builder = {
       BuilderName = 'P3UB2LandAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase2',
      PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB2Landattack1','P3UB2Landattack2', 'P3UB2Landattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function P3UB3Navalattacks1()
    
    local Temp = {
       'P3UB3NavalAttackTemp0',
       'NoPlan',
       { 'ues0103', 1, 6, 'Attack', 'GrowthFormation' }, --Frigates
       { 'ues0203', 1, 6, 'Attack', 'GrowthFormation' }, --Subs        
    }
    local Builder = {
       BuilderName = 'P3UB3NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase3',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB4Navalattack1','P3UB4Navalattack2', 'P3UB4Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB3NavalAttackTemp1',
       'NoPlan',
       { 'ues0103', 1, 4, 'Attack', 'GrowthFormation' }, --Frigates
       { 'ues0201', 1, 2, 'Attack', 'GrowthFormation' }, --Subs        
    }
    Builder = {
       BuilderName = 'P3UB3NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase3',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB4Navalattack1','P3UB4Navalattack2', 'P3UB4Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB3NavalAttackTemp2',
       'NoPlan',
       { 'ues0203', 1, 4, 'Attack', 'GrowthFormation' }, --Frigates
       { 'ues0202', 1, 2, 'Attack', 'GrowthFormation' }, --Subs        
    }
    Builder = {
       BuilderName = 'P3UB3NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase3',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB4Navalattack1','P3UB4Navalattack2', 'P3UB4Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3UB3NavalAttackTemp3',
       'NoPlan',
       { 'ues0203', 1, 4, 'Attack', 'GrowthFormation' }, --Frigates
       { 'xes0102', 1, 2, 'Attack', 'GrowthFormation' }, --Subs        
    }
    Builder = {
       BuilderName = 'P3UB3NavalAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3UEFBase3',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3UB4Navalattack1','P3UB4Navalattack2', 'P3UB4Navalattack3'}
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end
    
