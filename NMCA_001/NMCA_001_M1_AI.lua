local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local P1UBase1 = BaseManager.CreateBaseManager()
local P1UBase2 = BaseManager.CreateBaseManager()
local P1UBase3 = BaseManager.CreateBaseManager()

function UEFBase1AI()
    P1UBase1:InitializeDifficultyTables(ArmyBrains[UEF], 'P1UEFBase1', 'P1B1MK', 50, {P1Base1 = 100})
    P1UBase1:StartNonZeroBase({{5, 7, 9}, {4, 6, 8}})
    
    P1B1LandAttacks()
    P1B1AirAttacks()
end

function P1B1LandAttacks()
    local quantity = {}

    quantity = {4, 6, 8}
    local Temp = {
        'P1B1LandAttackTemp0',
        'NoPlan',
        { 'uel0106', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P1B1LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 4,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B1Landattack1', 'P1B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 4, 6}
    Temp = {
        'P1B1LandAttackTemp1',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, 4, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B1LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 12, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B1Landattack1', 'P1B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 4, 6}
    Temp = {
        'P1B1LandAttackTemp2',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, 4, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B1LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 105,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 5, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B1Landattack1', 'P1B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 6, 8}
    Temp = {
        'P1B1LandAttackTemp3',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B1LandAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 103,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 20, categories.LAND * categories.MOBILE - categories.xnl0105}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B1Landattack1', 'P1B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 6, 8}
    Temp = {
        'P1B1LandAttackTemp4',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B1LandAttackBuilder4',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 102,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P1Masspatrol1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {6, 9, 12}
    Temp = {
        'P1B1LandAttackTemp5',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B1LandAttackBuilder5',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 110,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 45, categories.LAND * categories.MOBILE - categories.xnl0105}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B1Landattack1', 'P1B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function P1B1AirAttacks()
    local quantity = {}

    quantity = {1, 2, 3}
    local Temp = {
        'P1B1AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P1B1AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 4,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B1Landattack1', 'P1B1Landattack2', 'P1B1Airattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 2, 3}
    Temp = {
        'P1B1AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B1AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 5, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B1Landattack1', 'P1B1Landattack2', 'P1B1Airattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 2, 3}
    Temp = {
        'P1B1AirAttackTemp2',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B1AirAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P1B1Airpatrol1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 4, 5}
    Temp = {
        'P1B1AirAttackTemp3',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B1AirAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 25, categories.LAND * categories.MOBILE - categories.xnl0105}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B1Landattack1', 'P1B1Landattack2', 'P1B1Airattack1'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function UEFBase2AI()
    P1UBase2:InitializeDifficultyTables(ArmyBrains[UEF], 'P1UEFBase2', 'P1B2MK', 50, {P1Base2 = 100})
    P1UBase2:StartNonZeroBase({{3, 4, 5}, {2, 3, 4}})
    
    P1B2LandAttacks()
end

function P1B2LandAttacks()
    local quantity = {}

    quantity = {4, 4, 6}
    local Temp = {
        'P1B2LandAttackTemp0',
        'NoPlan',
        { 'uel0106', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P1B2LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 4,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase2',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B2Landattack1', 'P1B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 3, 4}
    Temp = {
        'P1B2LandAttackTemp1',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, 2, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B2LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 12, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B2Landattack1', 'P1B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 3, 4}
    Temp = {
        'P1B2LandAttackTemp2',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, 2, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B2LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 3, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B2Landattack1', 'P1B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 4, 6}
    Temp = {
        'P1B2LandAttackTemp3',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B2LandAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 102,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 20, categories.LAND * categories.MOBILE - categories.xnl0105}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B2Landattack1', 'P1B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function UEFBase3AI()
    P1UBase3:InitializeDifficultyTables(ArmyBrains[UEF], 'P1UEFBase3', 'P1B3MK', 50, {P1Base3 = 100})
    P1UBase3:StartNonZeroBase({{2, 3, 4}, {1, 2, 3}})
    
    P1B3AirAttacks()
end

function P1B3AirAttacks()
    local quantity = {}

    quantity = {1, 2, 3}
    local Temp = {
        'P1B3AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P1B3AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 4,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase3',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B3Airattack1', 'P1B3Airattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 2, 3}
    Temp = {
        'P1B3AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B3AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase3',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 10, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P1B3Airattack1', 'P1B3Airattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 2, 3}
    Temp = {
        'P1B1AirAttackTemp2',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P1B3AirAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P1UEFBase3',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P1B3Airpatrol1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end
