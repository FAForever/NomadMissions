local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local P3UBase1 = BaseManager.CreateBaseManager()
local P3UBase2 = BaseManager.CreateBaseManager()
local P3UBase3 = BaseManager.CreateBaseManager()
local P3UBase4 = BaseManager.CreateBaseManager()
local P3UBase5 = BaseManager.CreateBaseManager()

function UEFP3Base1AI()
    P3UBase1:InitializeDifficultyTables(ArmyBrains[UEF], 'P3UEFBase1', 'P3B1MK', 60, {P3Base1 = 60})
    P3UBase1:StartNonZeroBase({{7, 10, 12}, {5, 8, 10}})
    
    P3B1Landattacks()
    P3B1Airattacks()
end

function P3B1Landattacks()
    
    local quantity = {}

    quantity = {4, 5, 6}
    local Temp = {
        'P3B1LandAttackTemp0',
        'NoPlan',
        { 'uel0202', 1, 4, 'Attack', 'GrowthFormation' },
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B1LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 6,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B1Landattack1', 'P3B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 4, 6}
    Temp = {
        'P3B1LandAttackTemp1',
        'NoPlan',
        { 'uel0202', 1, 4, 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B1LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 105,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 20, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B1Landattack1', 'P3B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 4, 6}
    Temp = {
        'P3B1LandAttackTemp2',
        'NoPlan',
        { 'uel0202', 1, 4, 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B1LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 25, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B1Landattack1', 'P3B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder ) 
end

function P3B1Airattacks()

    local quantity = {}

    quantity = {3, 3, 4}
    local Temp = {
        'P3B1AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B1AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B1Airattack1', 'P3B1Landattack1', 'P3B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 4, 5}
    Temp = {
        'P3B1AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B1AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 30, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
            PatrolChains = {'P3B1Airattack1', 'P3B1Landattack1', 'P3B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 4, 5}
    Temp = {
        'P3B1AirAttackTemp2',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B1AirAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B1Airpatrol'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function UEFP3Base2AI()
    P3UBase2:InitializeDifficultyTables(ArmyBrains[UEF], 'P3UEFBase2', 'P3B2MK', 60, {P3Base2 = 60})
    P3UBase2:StartNonZeroBase({{6, 8, 10}, {4, 6, 8}})
    
    P3B2Landattacks()
    P3B2Airattacks()
end

function P3B2Landattacks()
    
    local quantity = {}

    quantity = {4, 5, 6}
    local Temp = {
        'P3B2LandAttackTemp0',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B2LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 6,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase2',
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B2Landattack1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 4, 6}
    Temp = {
        'P3B2LandAttackTemp1',
        'NoPlan',
        { 'uel0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B2LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 105,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 15, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B2Landattack1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 4, 6}
    Temp = {
        'P3B2LandAttackTemp2',
        'NoPlan',
        { 'uel0104', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B2LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 25, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B2Landattack1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder ) 
end

function P3B2Airattacks()

    local quantity = {}

    quantity = {4, 5, 7}
    local Temp = {
        'P3B2AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B2AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase2',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B2Airattack1', 'P3B2Airattack2', 'P3B2Landattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 6, 9}
    Temp = {
        'P3B2AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B2AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 30, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
            PatrolChains = {'P3B2Airattack1', 'P3B2Airattack2', 'P3B2Landattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 5, 6}
    Temp = {
        'P3B2AirAttackTemp2',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B2AirAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase2',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B2Airpatrol'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {1, 2, 3}
    Temp = {
        'P3B2AirAttackTemp3',
        'NoPlan',
        { 'uea0203', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, 4, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B2AirAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 104,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 100, categories.LAND * categories.MOBILE - categories.xnl0105}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B2Airattack1', 'P3B2Airattack2', 'P3B2Landattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function UEFP3Base3AI()
    P3UBase3:InitializeDifficultyTables(ArmyBrains[UEF], 'P3UEFBase3', 'P3B3MK', 50, {P3Base3 = 60})
    P3UBase3:StartNonZeroBase({{7, 10, 12}, {5, 8, 10}})
    
    P3B3Landattacks()
    P3B3Airattacks()
end

function P3B3Landattacks()
    
    local quantity = {}

    quantity = {4, 5, 6}
    local Temp = {
        'P3B3LandAttackTemp0',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B3LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 6,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase3',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B3Landattack1', 'P3B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 4, 6}
    Temp = {
        'P3B3LandAttackTemp1',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B3LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 105,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase3',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 10, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B3Landattack1', 'P3B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 4, 6}
    Temp = {
        'P3B3LandAttackTemp2',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B3LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase3',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 25, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B3Landattack1', 'P3B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder ) 
end

function P3B3Airattacks()

    local quantity = {}

    quantity = {3, 3, 4}
    local Temp = {
        'P3B3AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B3AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase3',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B3Airattack1', 'P3B3Landattack1', 'P3B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 4, 5}
    Temp = {
        'P3B3AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B3AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase3',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 30, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
            PatrolChains = {'P3B3Airattack1', 'P3B3Landattack1', 'P3B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 4, 5}
    Temp = {
        'P3B3AirAttackTemp2',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B3AirAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase3',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B3Airpatrol'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function UEFP3Base4AI()
    P3UBase4:InitializeDifficultyTables(ArmyBrains[UEF], 'P3UEFBase4', 'P3B4MK', 60, {P3Base4 = 60})
    P3UBase4:StartNonZeroBase({{6, 8, 10}, {4, 6, 8}})
    
    P3B4Landattacks()
    P3B4Airattacks()
end

function P3B4Landattacks()
    
    local quantity = {}

    quantity = {2, 2, 3}
    local Temp = {
        'P3B4LandAttackTemp0',
        'NoPlan',
        { 'uel0202', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0201', 1, 3, 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B4LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 6,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase4',
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B4Landattack1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {1, 2, 3}
    Temp = {
        'P3B4LandAttackTemp1',
        'NoPlan',
        { 'uel0111', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, 3, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B4LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 105,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase4',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 15, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B4Landattack1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {1, 2, 3}
    Temp = {
        'P3B4LandAttackTemp2',
        'NoPlan',
        { 'uel0205', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, 3, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B4LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase4',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 25, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B4Landattack1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder ) 
end

function P3B4Airattacks()

    local quantity = {}

    quantity = {4, 5, 7}
    local Temp = {
        'P3B4AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B4AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase4',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B4Airattack1', 'P3B4Airattack2', 'P3B4Landattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 6, 9}
    Temp = {
        'P3B4AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B4AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase4',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 30, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
            PatrolChains = {'P3B4Airattack1', 'P3B4Airattack2', 'P3B4Landattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 5, 6}
    Temp = {
        'P3B4AirAttackTemp2',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B4AirAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase4',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B4Airpatrol'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {1, 2, 3}
    Temp = {
        'P3B4AirAttackTemp3',
        'NoPlan',
        { 'uea0203', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, 4, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B4AirAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 104,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase4',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 100, categories.LAND * categories.MOBILE - categories.xnl0105}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B4Airattack1', 'P3B4Airattack2', 'P3B4Landattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function UEFP3Base5AI()
    P3UBase5:InitializeDifficultyTables(ArmyBrains[UEF], 'P3UEFBase5', 'P3B5MK', 50, {P3Base5 = 60})
    P3UBase5:StartNonZeroBase({{3, 4, 5}, {2, 3, 4}})
    
    P3B5Navalattacks()
end

function P3B5Navalattacks()

    local quantity = {}

    quantity = {2, 2, 3}
    local Temp = {
        'P3B5NavalAttackTemp0',
        'NoPlan',
        { 'ues0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P3B5NavalAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Sea',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase5',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P3B5Navalattack1', 'P3B5Navalattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 3, 4}
    Temp = {
        'P3B5NavalAttackTemp1',
        'NoPlan',
        { 'ues0203', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B5NavalAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Sea',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase5',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 6, categories.NAVAL * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
            PatrolChains = {'P3B5Navalattack1', 'P3B5Navalattack3'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 3, 4}
    Temp = {
        'P3B5NavalAttackTemp2',
        'NoPlan',
        { 'ues0203', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'ues0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P3B5NavalAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 105,
        PlatoonType = 'Sea',
        RequiresConstruction = true,
        LocationType = 'P3UEFBase5',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P3B5Navalpatrol'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end