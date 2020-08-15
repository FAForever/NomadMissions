local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local Cybran = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local P2CBase1 = BaseManager.CreateBaseManager()
local P2CBase2 = BaseManager.CreateBaseManager()


function CybranBase1AI()
    P2CBase1:InitializeDifficultyTables(ArmyBrains[Cybran], 'P2CybranBase1', 'P2CB1MK', 80, {P2CBase1 = 100})
    P2CBase1:StartNonZeroBase({{10, 14, 18}, {8, 12, 16}})

    P2CB1Airattacks1()
    P2CB1Navalattacks1()
    P2CB1Landattacks1()
end

function P2CB1Airattacks1()
    
    local quantity = {}

    quantity = {4, 5, 7} 
    local Temp = {
        'P2CB1AirAttackTemp0',
        'NoPlan',
        { 'xra0105', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Light Gunships  
    }
    local Builder = {
        BuilderName = 'P2CB1AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2CybranBase1',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2CB1Airattack1','P2CB1Airattack2', 'P2CB1Airattack3','P2CB1Airattack4'}
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {5, 6, 9} 
    Temp = {
       'P2CB1AirAttackTemp1',
       'NoPlan',
       { 'ura0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Bombers  
    }
    Builder = {
       BuilderName = 'P2CB1AirAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2CB1Airattack1','P2CB1Airattack2', 'P2CB1Airattack3','P2CB1Airattack4'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {6, 9, 12} 
    Temp = {
       'P2CB1AirAttackTemp2',
       'NoPlan',
       { 'ura0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters 
    }
    Builder = {
       BuilderName = 'P2CB1AirAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 103,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 25, categories.AIR * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2CB1Airattack2', 'P2CB1Airattack3','P2CB1Airattack4'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {5, 6, 9} 
    Temp = {
       'P2CB1AirAttackTemp3',
       'NoPlan',
       { 'dra0202', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighterbombers  
    }
    Builder = {
       BuilderName = 'P2CB1AirAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 109,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 40, categories.AIR * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2CB1Airattack2', 'P2CB1Airattack3','P2CB1Airattack4'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )

    quantity = {3, 6, 6}
    Temp = {
       'P2CB1AirAttackTemp4',
       'NoPlan',
       { 'ura0203', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Gunships
    }
    Builder = {
       BuilderName = 'P2CB1AirAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 108,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 45, categories.LAND * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2CB1Airattack2', 'P2CB1Airattack3','P2CB1Airattack4'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P2CB1AirAttackTemp5',
       'NoPlan',
       { 'dra0202', 1, 6, 'Attack', 'GrowthFormation' }, --Fighter/Bombers
       { 'ura0203', 1, 6, 'Attack', 'GrowthFormation' }, --Gunships 
       { 'ura0102', 1, 10, 'Attack', 'GrowthFormation' }, --Fighters
       { 'ura0103', 1, 6, 'Attack', 'GrowthFormation' }, --Bombers 
    }
    Builder = {
       BuilderName = 'P2CB1AirAttackBuilder5',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',     
       PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P2CB1Airdefense1'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )    
end

function P2CB1Landattacks1()
    
    -- Transport Builder
    opai = P2CBase1:AddOpAI('EngineerAttack', 'M2_Cybran_TransportAttack_Builder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {

            TransportReturn = 'P2CB1MK',
        },
        Priority = 1000,
    })
    opai:SetChildQuantity('T2Transports', 2)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 2, categories.ura0104})

    quantity = {10, 12, 18}
        opai = P2CBase1:AddOpAI('BasicLandAttack', 'M2_Cybran_TransportAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB1Dropattack1',
                LandingChain = 'P2CB1Drop1',
                TransportReturn = 'P2CB1MK',
            },
            Priority = 105,
        })
        opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
        
    quantity = {4, 6, 8}
    
        opai = P2CBase1:AddOpAI('BasicLandAttack', 'M2_Cybran_TransportAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB1Dropattack1',
                LandingChain = 'P2CB1Drop1',
                TransportReturn = 'P2CB1MK',
            },
            Priority = 104,
        })
        opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 240})
    
    quantity = {10, 12, 18}
        opai = P2CBase1:AddOpAI('BasicLandAttack', 'M2_Cybran_TransportAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB1Dropattack2',
                LandingChain = 'P2CB1Drop2',
                TransportReturn = 'P2CB1MK',
            },
            Priority = 103,
        })
        opai:SetChildQuantity('LightTanks', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 240})
    
    
    quantity = {4, 6, 8}
        opai = P2CBase1:AddOpAI('BasicLandAttack', 'M2_Cybran_TransportAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB1Dropattack2',
                LandingChain = 'P2CB1Drop2',
                TransportReturn = 'P2CB1MK',
            },
            Priority = 102,
        })
        opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 180})

    local Temp = {
       'P2CB1LandAttackTemp0',
       'NoPlan',
       { 'url0203', 1, 4, 'Attack', 'GrowthFormation' },   
    }
    local Builder = {
       BuilderName = 'P2CB1LandAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 4,
       Priority = 106,
       PlatoonType = 'Land',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2CB1Landattack1','P2CB1Landattack2', 'P2CB1Landattack3'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder ) 
end

function P2CB1Navalattacks1()
    
    local Temp = {
       'P2CB1NavalAttackTemp0',
       'NoPlan', 
       { 'urs0103', 1, 6, 'Attack', 'GrowthFormation' },
    }
    local Builder = {
       BuilderName = 'P2CB1NavalAttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2CB1Navalattack1','P2CB1Navalattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P2CB1NavalAttackTemp1',
       'NoPlan',
       { 'urs0202', 1, 1, 'Attack', 'GrowthFormation' }, 
       { 'urs0103', 1, 5, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P2CB1NavalAttackBuilder1',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 100,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2CB1Navalattack1','P2CB1Navalattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P2CB1NavalAttackTemp2',
       'NoPlan',
       { 'urs0201', 1, 2, 'Attack', 'GrowthFormation' }, 
       { 'urs0103', 1, 4, 'Attack', 'GrowthFormation' }, 
    }
    Builder = {
       BuilderName = 'P2CB1NavalAttackBuilder2',
       PlatoonTemplate = Temp,
       InstanceCount = 3,
       Priority = 103,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 20, categories.NAVAL * categories.MOBILE, '>='}},
       },
       PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
       PlatoonData = {
           PatrolChains = {'P2CB1Navalattack1','P2CB1Navalattack2'}
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P2CB1NavalAttackTemp3',
       'NoPlan',
       { 'urs0203', 1, 8, 'Attack', 'GrowthFormation' }, 
       { 'xrs0204', 1, 4, 'Attack', 'GrowthFormation' },

    }
    Builder = {
       BuilderName = 'P2CB1NavalAttackBuilder3',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 200,
       PlatoonType = 'Sea',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase1',
       PlatoonAIFunction = {SPAIFileName, 'PatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P2CB1Navaldefense1'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
end

function CybranBase2AI()
    P2CBase2:InitializeDifficultyTables(ArmyBrains[Cybran], 'P2CybranBase2', 'P2CB2MK', 80, {P2CBase2 = 100})
    P2CBase2:StartNonZeroBase({{8, 11, 14}, {6, 9, 12}})

    P2CB2Airattacks1()
    P2CB2Landattacks1()
end

function P2CB2Airattacks1()
    
    local quantity = {}

    quantity = {4, 6, 8} 
    local Temp = {
        'P2CB2AirAttackTemp0',
        'NoPlan',
        { 'ura0103', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Bombers  
    }
    local Builder = {
        BuilderName = 'P2CB2AirAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 5,
        Priority = 100,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2CybranBase2',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2CB2Airattack1','P2CB2Airattack2','P2CB2Airattack3','P2CB2Airattack4'}
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {4, 6, 8}
    Temp = {
        'P2CB2AirAttackTemp1',
        'NoPlan',
        { 'xra0105', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Gunships  
    }
    Builder = {
        BuilderName = 'P2CB2AirAttackBuilder1',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 105,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2CybranBase2',
        BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 30, categories.LAND * categories.MOBILE, '>='}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
           PatrolChains = {'P2CB2Airattack2','P2CB2Airattack3','P2CB2Airattack4'}
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    quantity = {4, 6, 8}
    Temp = {
        'P2CB2AirAttackTemp2',
        'NoPlan',
        { 'ura0102', 1, quantity[Difficulty], 'Attack', 'GrowthFormation' }, --Fighters 
    }
    Builder = {
        BuilderName = 'P2CB2AirAttackBuilder2',
        PlatoonTemplate = Temp,
        InstanceCount = 2,
        Priority = 104,
        PlatoonType = 'Air',
        RequiresConstruction = true,
        LocationType = 'P2CybranBase2',
        BuildConditions = {
           {'/lua/editor/otherarmyunitcountbuildconditions.lua',
            'BrainsCompareNumCategory', {'default_brain', {'HumanPlayers'}, 30, categories.AIR * categories.MOBILE, '>='}},
        },
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
           PatrolChains = {'P2CB2Airattack1','P2CB2Airattack2','P2CB2Airattack3','P2CB2Airattack4'}
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )
    
    Temp = {
       'P2CB2AirAttackTemp4',
       'NoPlan',
       { 'dra0202', 1, 2, 'Attack', 'GrowthFormation' }, --Fighter/Bombers
       { 'ura0203', 1, 2, 'Attack', 'GrowthFormation' }, --Gunships 
       { 'ura0102', 1, 12, 'Attack', 'GrowthFormation' }, --Fighters 
       { 'ura0103', 1, 10, 'Attack', 'GrowthFormation' }, --Bombers 
    }
    Builder = {
       BuilderName = 'P2CB2AirAttackBuilder4',
       PlatoonTemplate = Temp,
       InstanceCount = 1,
       Priority = 200,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'P2CybranBase2',
       PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'P2CB2Airdefense1'
       },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder ) 
end

function P2CB2Landattacks1()
    
    local Temp = {
        'P2CB2LandAttackTemp0',
        'NoPlan',
        { 'drl0204', 1, 2, 'Attack', 'GrowthFormation' },
        { 'url0107', 1, 6, 'Attack', 'GrowthFormation' },     
    }
    local Builder = {
        BuilderName = 'P2CB2LandAttackBuilder0',
        PlatoonTemplate = Temp,
        InstanceCount = 8,
        Priority = 100,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'P2CybranBase2',     
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'P2CB2Landattack1','P2CB2Landattack2'}
        },
    }
    ArmyBrains[Cybran]:PBMAddPlatoon( Builder )

    -- Transport Builder
    opai = P2CBase2:AddOpAI('EngineerAttack', 'M2_CybranB2_TransportAttack_Builder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {

            TransportReturn = 'P2CB2MK',
        },
        Priority = 1000,
    })
    opai:SetChildQuantity('T2Transports', 2)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 2, categories.ura0104})

    quantity = {10, 12, 18}
        opai = P2CBase2:AddOpAI('BasicLandAttack', 'M2_CybranB2_TransportAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB2Dropattack3',
                LandingChain = 'P2CB2Drop3',
                TransportReturn = 'P2CB2MK',
            },
            Priority = 105,
        })
        opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
        
    quantity = {4, 6, 8}
    
        opai = P2CBase2:AddOpAI('BasicLandAttack', 'M2_CybranB2_TransportAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB2Dropattack1',
                LandingChain = 'P2CB2Drop1',
                TransportReturn = 'P2CB2MK',
            },
            Priority = 104,
        })
        opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 240})
    
    quantity = {10, 12, 18}
        opai = P2CBase2:AddOpAI('BasicLandAttack', 'M2_CybranB2_TransportAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB2Dropattack1',
                LandingChain = 'P2CB2Drop1',
                TransportReturn = 'P2CB2MK',
            },
            Priority = 103,
        })
        opai:SetChildQuantity('LightTanks', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
    
    
    quantity = {4, 6, 8}
        opai = P2CBase2:AddOpAI('BasicLandAttack', 'M2_CybranB2_TransportAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB2Dropattack2',
                LandingChain = 'P2CB2Drop2',
                TransportReturn = 'P2CB2MK',
            },
            Priority = 102,
        })
        opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 240})

    quantity = {10, 12, 18}
        opai = P2CBase2:AddOpAI('BasicLandAttack', 'M2_CybranB2_TransportAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'P2CB2Dropattack2',
                LandingChain = 'P2CB2Drop2',
                TransportReturn = 'P2CB2MK',
            },
            Priority = 101,
        })
        opai:SetChildQuantity('LightTanks', quantity[Difficulty])
        opai:SetLockingStyle('DeathTimer', {LockTimer = 180})
end


