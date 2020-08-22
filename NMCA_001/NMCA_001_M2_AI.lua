local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local P2UBase1 = BaseManager.CreateBaseManager()
local P2UBase2 = BaseManager.CreateBaseManager()
local P2UBase3 = BaseManager.CreateBaseManager()


function UEFP2Base1AI()
    P2UBase1:InitializeDifficultyTables(ArmyBrains[UEF], 'P2UEFBase1', 'P2B1MK', 50, {P2Base1 = 100})
    P2UBase1:StartNonZeroBase({{8, 11, 14}, {6, 9, 12}})

    P2B1Landattacks()
    P2B1Airattacks()
end

function P2B1Landattacks()
    
    local quantity = {}

    quantity = {6, 9, 12}
    local Temp = {
        'P2B1LandAttackTemp0',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B1LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B1Landattack1', 'P2B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 5, 6}
    Temp = {
        'P2B1LandAttackTemp1',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, 6, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B1LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 25, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B1Landattack1', 'P2B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {9, 12, 18}
    Temp = {
        'P2B1LandAttackTemp2',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B1LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 106,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 70, categories.LAND * categories.MOBILE - categories.xnl0105}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B1Landattack1', 'P2B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 5, 6}
    Temp = {
        'P2B1LandAttackTemp3',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, 6, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B1LandAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 105,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 10, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B1Landattack1', 'P2B1Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function P2B1Airattacks()
    local opai = nil
    local quantity = {}

    quantity = {3, 4, 6}
    local Temp = {
        'P2B1AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B1AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 4,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B1Airattack1', 'P2B1Airattack2', 'P2B1Airattack3', 'P2B1Airattack4'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 4, 6}
    Temp = {
        'P2B1AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B1AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 20, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B1Airattack1', 'P2B1Airattack2', 'P2B1Airattack3', 'P2B1Airattack4'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 4, 6}
    Temp = {
        'P2B1AirAttackTemp2',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B1AirAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 110,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
        PlatoonData = {
            PatrolChain = 'P2B1Airpatrol1'
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 6, 9}
    Temp = {
        'P2B1AirAttackTemp3',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B1AirAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 50, categories.LAND * categories.MOBILE - categories.xnl0105}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B1Airattack1', 'P2B1Airattack2', 'P2B1Airattack3', 'P2B1Airattack4'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )  

    quantity = {6, 9, 12}
    Temp = {
        'P2B1AirAttackTemp4',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B1AirAttackBuilder4',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 109,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase1',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 45, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B1Airattack1', 'P2B1Airattack2', 'P2B1Airattack3', 'P2B1Airattack4'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder ) 
    
end

function UEFP2Base2AI()
    P2UBase2:InitializeDifficultyTables(ArmyBrains[UEF], 'P2UEFBase2', 'P2B2MK', 50, {P2Base2 = 100})
    P2UBase2:StartNonZeroBase({{4, 5, 6}, {3, 4, 5}})

    P2B2Landattacks()
    P2B2Airattacks()
end

function P2B2Landattacks()
    
    local quantity = {}

    quantity = {4, 5, 6}
    local Temp = {
        'P2B2LandAttackTemp0',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B2LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 101,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase2',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B2Landattack1', 'P2B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 6, 8}
    Temp = {
        'P2B2LandAttackTemp1',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B2LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase2',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B2Landattack1', 'P2B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 3, 4}
    Temp = {
        'P2B2LandAttackTemp2',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B2LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 105,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 10, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B2Landattack1', 'P2B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 3, 4}
    Temp = {
        'P2B2LandAttackTemp3',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B2LandAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 20, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B2Landattack1', 'P2B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder ) 
end

function P2B2Airattacks()
    local opai = nil
    local quantity = {}

    quantity = {2, 3, 4}
    local Temp = {
        'P2B2AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B2AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase2',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B2Landattack1', 'P2B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 3, 4}
    Temp = {
        'P2B2AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B2AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase2',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 15, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B2Landattack1', 'P2B2Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function UEFP2Base3AI()
    P2UBase3:InitializeDifficultyTables(ArmyBrains[UEF], 'P2UEFBase3', 'P2B3MK', 50, {P2Base3 = 100})
    P2UBase3:StartNonZeroBase({{4, 5, 6}, {3, 4, 5}})

    P2B3Landattacks()
    P2B3Airattacks()
end

function P2B3Landattacks()
    
    local quantity = {}

    quantity = {4, 5, 6}
    local Temp = {
        'P2B3LandAttackTemp0',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B3LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 102,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase3',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B3Landattack1', 'P2B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {4, 6, 8}
    local Temp = {
        'P2B3LandAttackTemp1',
        'NoPlan',
        { 'uel0201', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B3LandAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 3,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase3',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B3Landattack1', 'P2B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 3, 4}
    local Temp = {
        'P2B3LandAttackTemp2',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B3LandAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 105,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase3',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 10, categories.STRUCTURE * categories.DEFENSE - categories.WALL}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B3Landattack1', 'P2B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {2, 3, 4}
    local Temp = {
        'P2B3LandAttackTemp3',
        'NoPlan',
        { 'uel0202', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B3LandAttackBuilder3',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 104,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase3',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain',  {'HumanPlayers'}, 20, categories.AIR * categories.MOBILE}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B3Landattack1', 'P2B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder ) 
end

function P2B3Airattacks()
    local opai = nil
    local quantity = {}

    quantity = {2, 3, 4}
    local Temp = {
        'P2B3AirAttackTemp0',
        'NoPlan',
        { 'uea0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    local Builder = {
        BuilderName = 'P2B3AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase3',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B3Landattack1', 'P2B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    quantity = {3, 3, 4}
    Temp = {
        'P2B3AirAttackTemp1',
        'NoPlan',
        { 'uea0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'P2B3AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 103,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2UEFBase3',
        BuildConditions = {
           { '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
       {'default_brain',  {'HumanPlayers'}, 15, categories.AIR * categories.MOBILE}},
       },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2B3Landattack1', 'P2B3Landattack2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end


