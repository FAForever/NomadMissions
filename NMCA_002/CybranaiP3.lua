local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local Cybran = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local P3CBase1 = BaseManager.CreateBaseManager()
local P3CBase2 = BaseManager.CreateBaseManager()
local P3CBase3 = BaseManager.CreateBaseManager()


function P3CybranBase1AI()
    P3CBase1:InitializeDifficultyTables(ArmyBrains[Cybran], 'P3CybranBase1', 'P3CB1MK', 110, {P3CBase1 = 100})
    P3CBase1:StartNonZeroBase({{16, 22, 30}, {14, 20, 28}})
    
    P3CB1Airattacks1()
    P3CB1Landattacks1()
    P3CB1Navalattacks1()
end

function P3CB1Airattacks1()
    
    local Temp = {
        'P3CB1AirAttackTemp0',
        'NoPlan',
        { 'ura0203', 1, 12, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    local Builder = {
        BuilderName = 'P3CB1AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 4,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3CybranBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3CB1Airattack1','P3CB1Airattack2','P3CB1Airattack3','P3CB1Airattack4','P3CB1Airattack5'}
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1AirAttackTemp1',
       'NoPlan',
       { 'ura0203', 1, 18, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3CB1AirAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 103,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 80, categories.LAND * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Airattack2','P3CB1Airattack3','P3CB1Airattack4','P3CB1Airattack5'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1AirAttackTemp2',
       'NoPlan',
       { 'dra0202', 1, 18, 'Attack', 'GrowthFormation' }, --Fighters  
    }
    Builder = {
       BuilderName = 'P3CB1AirAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 105,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 100, categories.AIR * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Airattack2','P3CB1Airattack3','P3CB1Airattack4','P3CB1Airattack5'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1AirAttackTemp3',
       'NoPlan',
       { 'ura0204', 1, 12, 'Attack', 'GrowthFormation' }, --Torpbombers
    }
    Builder = {
       BuilderName = 'P3CB1AirAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 104,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 50, categories.NAVAL * categories.MOBILE, '>='}},
       },
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
        { 'ura0204', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships 
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
       { 'url0203', 1, 9, 'Attack', 'GrowthFormation' },   
    }
    local Builder = {
       BuilderName = 'P3CB1LandAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 5,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Landattack1','P3CB1Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )

    Temp = {
       'P3CB1LandAttackTemp1',
       'NoPlan',
       { 'url0203', 1, 15, 'Attack', 'GrowthFormation' },   
    }
    Builder = {
       BuilderName = 'P3CB1LandAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 105,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 70, categories.LAND * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Landattack1','P3CB1Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function P3CB1Navalattacks1()
    
    local Temp = {
       'P3CB1NavalAttackTemp0',
       'NoPlan',
       { 'urs0201', 1, 2, 'Attack', 'GrowthFormation' }, 
       { 'urs0103', 1, 8, 'Attack', 'GrowthFormation' },
    }
    local Builder = {
       BuilderName = 'P3CB1NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Navalattack1','P3CB1Navalattack2','P3CB1Navalattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1NavalAttackTemp1',
       'NoPlan',
       { 'urs0202', 1, 4, 'Attack', 'GrowthFormation' }, 
       { 'urs0203', 1, 4, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P3CB1NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 104,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 100, categories.AIR * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB1Navalattack1','P3CB1Navalattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB1NavalAttackTemp2',
       'NoPlan',
       { 'urs0201', 1, 4, 'Attack', 'GrowthFormation' }, 
       { 'urs0202', 1, 4, 'Attack', 'GrowthFormation' },
       { 'xrs0204', 1, 4, 'Attack', 'GrowthFormation' },  
    }
    Builder = {
       BuilderName = 'P3CB1NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 105,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 50, categories.NAVAL * categories.MOBILE, '>='}},
       },
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

function P3CybranBase2AI()
    P3CBase2:InitializeDifficultyTables(ArmyBrains[Cybran], 'P3CybranBase2', 'P3CB2MK', 90, {P3CBase2 = 100})
    P3CBase2:StartNonZeroBase({{5, 7, 8}, {3, 5, 6}})
    
    P3CB2Airattacks1()
end

function P3CB2Airattacks1()
    
    local Temp = {
        'P3CB2AirAttackTemp0',
        'NoPlan',
        { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    local Builder = {
        BuilderName = 'P3CB2AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 4,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3CybranBase2',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3CB2Airattack1','P3CB2Airattack2','P3CB2Airattack3','P3CB2Airattack4'}
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB2AirAttackTemp1',
       'NoPlan',
       { 'dra0202', 1, 9, 'Attack', 'GrowthFormation' }, --Fighters  
    }
    Builder = {
       BuilderName = 'P3CB2AirAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 105,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase2',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 100, categories.AIR * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB2Airattack1','P3CB2Airattack2','P3CB2Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB2AirAttackTemp2',
       'NoPlan',
       { 'ura0203', 1, 12, 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
       BuilderName = 'P3CB2AirAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 103,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase2',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 100, categories.LAND * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB2Airattack1','P3CB2Airattack2','P3CB2Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB2AirAttackTemp3',
       'NoPlan',
       { 'ura0204', 1, 6, 'Attack', 'GrowthFormation' }, --Torpbombers
    }
    Builder = {
       BuilderName = 'P3CB2AirAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 104,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase2',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 40, categories.NAVAL * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB2Airattack1','P3CB2Airattack2','P3CB2Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
        'P3CB2AirAttackTemp4',
        'NoPlan',
        { 'ura0204', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships 
        { 'ura0102', 1, 3, 'Attack', 'GrowthFormation' }, --Gunships 
        { 'ura0103', 1, 3, 'Attack', 'GrowthFormation' }, --Gunships 
    }
    Builder = {
        BuilderName = 'P3CB2AirAttackBuilder4',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 200,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3CybranBase2',    
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
           PatrolChain = 'P3CB2Airdefense1'
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function P3CybranBase3AI()
    P3CBase3:InitializeDifficultyTables(ArmyBrains[Cybran], 'P3CybranBase3', 'P3CB3MK', 80, {P3CBase3 = 100})
    P3CBase3:StartNonZeroBase({{5, 7, 8}, {3, 5, 6}})

    P3CB3Navalattacks1()
end

function P3CB3Navalattacks1()
    
    local Temp = {
       'P3CB3NavalAttackTemp0',
       'NoPlan',
       { 'urs0201', 1, 3, 'Attack', 'GrowthFormation' }, 
       { 'urs0103', 1, 6, 'Attack', 'GrowthFormation' },
    }
    local Builder = {
       BuilderName = 'P3CB3NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase3',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB3Navalattack1','P3CB3Navalattack2','P3CB3Navalattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB3NavalAttackTemp1',
       'NoPlan',
       { 'urs0202', 1, 3, 'Attack', 'GrowthFormation' }, 
       { 'urs0103', 1, 5, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P3CB3NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 101,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase3',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 100, categories.AIR * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB3Navalattack1','P3CB3Navalattack2','P3CB3Navalattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P3CB3NavalAttackTemp2',
       'NoPlan',
       { 'urs0201', 1, 6, 'Attack', 'GrowthFormation' }, 
       { 'xrs0204', 1, 2, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P3CB3NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 103,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase3',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 50, categories.NAVAL * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB3Navalattack1','P3CB3Navalattack2','P3CB3Navalattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )

    Temp = {
       'P3CB3NavalAttackTemp3',
       'NoPlan',
       { 'urs0203', 1, 6, 'Attack', 'GrowthFormation' }, 
       { 'xrs0204', 1, 6, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P3CB3NavalAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 105,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P3CybranBase3',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 70, categories.NAVAL * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P3CB3Navalattack1','P3CB3Navalattack2','P3CB3Navalattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

