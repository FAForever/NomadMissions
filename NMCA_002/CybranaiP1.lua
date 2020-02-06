local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local Cybran = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local P1Cbase1 = BaseManager.CreateBaseManager()
local P1Cbase2 = BaseManager.CreateBaseManager()

local CBase1Delay = {7*60, 6*60, 5*60}

function P1CybranBase1AI()
    P1Cbase1:InitializeDifficultyTables(ArmyBrains[Cybran], 'P1Cybranbase1', 'P1CB1MK', 60, {P1CBase1 = 100})
    P1Cbase1:StartNonZeroBase({{7, 10, 12}, {5, 8, 10}})
    
    P1CB1AirAttacks1()

    ForkThread(
        function()
        WaitSeconds(CBase1Delay[Difficulty])
        P1CB1LandAttacks1()
        end)     
end

function P1CybranBase2AI()
    P1Cbase2:InitializeDifficultyTables(ArmyBrains[Cybran], 'P1Cybranbase2', 'P1CB2MK', 40, {P1CBase2 = 100})
    P1Cbase2:StartNonZeroBase({{4, 5, 7}, {3, 4, 6}})

    P1CB2LandAttacks1()

     ForkThread(
        function()
        WaitSeconds(1*60)
        P1CB2AirAttacks1()
        end)   
end

function P1CB1AirAttacks1()

    local Temp = {
       'P1CB1AirAttackTemp0',
       'NoPlan',
       { 'ura0102', 1, 3, 'Attack', 'GrowthFormation' }, --Fighters  
    }
    local Builder = {
       BuilderName = 'P1CB1AirAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Airattack1','P1CB1Airattack2', 'P1CB1Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P1CB1AirAttackTemp1',
       'NoPlan',
       { 'ura0103', 1, 3, 'Attack', 'GrowthFormation' }, --Bombers  
    }
    Builder = {
       BuilderName = 'P1CB1AirAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Airattack1','P1CB1Airattack2', 'P1CB1Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P1CB1AirAttackTemp2',
       'NoPlan',
       { 'xra0105', 1, 4, 'Attack', 'GrowthFormation' }, --light gunships  
    }
    Builder = {
       BuilderName = 'P1CB1AirAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 105,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 10, categories.LAND * categories.MOBILE + categories.xnl0103}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Airattack1','P1CB1Airattack2', 'P1CB1Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P1CB1AirAttackTemp3',
       'NoPlan',
       { 'ura0103', 1, 6, 'Attack', 'GrowthFormation' }, --Bombers  
    }
    Builder = {
       BuilderName = 'P1CB1AirAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 104,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 40, categories.LAND * categories.MOBILE}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Airattack1','P1CB1Airattack2', 'P1CB1Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )

    Temp = {
       'P1CB1AirAttackTemp4',
       'NoPlan',
       { 'ura0102', 1, 6, 'Attack', 'GrowthFormation' }, --fighters  
    }
    Builder = {
       BuilderName = 'P1CB1AirAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 106,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 20, categories.AIR * categories.MOBILE}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Airattack1','P1CB1Airattack2', 'P1CB1Airattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )

    Temp = {
       'P1CB1AirAttackTemp5',
       'NoPlan',
       { 'ura0103', 1, 4, 'Attack', 'GrowthFormation' }, --Bombers
       { 'ura0102', 1, 5, 'Attack', 'GrowthFormation' }, --Fighters        
    }
    Builder = {
       BuilderName = 'P1CB1AirAttackBuilder5',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
      PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P1CB1Airpatrol1'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function P1CB1LandAttacks1()

    local quantity = {}

    quantity = {4, 5, 6}
    local Temp = {
       'P1CB1LandAttackTemp0',
       'NoPlan',
       { 'url0106', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Light assault bot  
    }
    local Builder = {
       BuilderName = 'P1CB1LandAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Landattack1','P1CB1Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {4, 5, 6}
    Temp = {
       'P1CB1LandAttackTemp1',
       'NoPlan',
       { 'url0107', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Assualt bots  
    }
    Builder = {
       BuilderName = 'P1CB1LandAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 6,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Landattack1','P1CB1Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {3, 4, 6}
    Temp = {
       'P1CB1LandAttackTemp2',
       'NoPlan',
       { 'url0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Marty
    }
    Builder = {
       BuilderName = 'P1CB1LandAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 103,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 4, categories.TECH1 * categories.DEFENSE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Landattack1','P1CB1Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {1, 2, 2}
    Temp = {
       'P1CB1LandAttackTemp3',
       'NoPlan',
       { 'url0202', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Heavy tank
       { 'url0103', 1, 4, 'Attack', 'GrowthFormation' }, --Marty
    }
    Builder = {
       BuilderName = 'P1CB1LandAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 105,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 60, categories.ALLUNITS - categories.WALL, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Landattack1','P1CB1Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )

    quantity = {2, 2, 4}
    Temp = {
       'P1CB1LandAttackTemp4',
       'NoPlan',
       { 'url0202', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Heavy tank
       { 'url0107', 1, 6, 'Attack', 'GrowthFormation' }, --assualt bot
    }
    Builder = {
       BuilderName = 'P1CB1LandAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 106,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 90, categories.ALLUNITS - categories.WALL, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB1Landattack1','P1CB1Landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function P1CB2LandAttacks1()

    local quantity = {}

    quantity = {4, 5, 6}
    local Temp = {
       'P1CB2LandAttackTemp0',
       'NoPlan',
       { 'url0106', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters  
    }
    local Builder = {
       BuilderName = 'P1CB2LandAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 100,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase2',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB2landattack1','P1CB2landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {4, 5, 6}
    Temp = {
       'P1CB2LandAttackTemp1',
       'NoPlan',
       { 'url0107', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters  
    }
    Builder = {
       BuilderName = 'P1CB2LandAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 102,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase2',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 15, categories.ALLUNITS - categories.WALL, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB2landattack1','P1CB2landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {4, 5, 6}
    Temp = {
       'P1CB2LandAttackTemp2',
       'NoPlan',
       { 'url0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters  
    }
    Builder = {
       BuilderName = 'P1CB2LandAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 103,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase2',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 60, categories.TECH1 * categories.DEFENSE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB2landattack1','P1CB2landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder ) 
end
    
function P1CB2AirAttacks1()

    local Temp = {
       'P1CB2AirAttackTemp0',
       'NoPlan',
       { 'ura0103', 1, 2, 'Attack', 'GrowthFormation' }, --bombers  
    }
    local Builder = {
       BuilderName = 'P1CB2AirAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase2',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB2landattack1','P1CB2landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )

    Temp = {
       'P1CB2AirAttackTemp1',
       'NoPlan',
       { 'xra0105', 1, 3, 'Attack', 'GrowthFormation' }, --light gunships  
    }
    Builder = {
       BuilderName = 'P1CB2AirAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 105,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P1Cybranbase2',
        BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 5, categories.LAND * categories.MOBILE * categories.xnl0103, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P1CB2landattack1','P1CB2landattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end