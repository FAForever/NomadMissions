local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'
local CustomAIOrders = '/maps/NMCA_001/CustomFunctions.lua'

local UEF = 2

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFBase = BaseManager.CreateBaseManager()

function UEFBaseAI()
    UEFBase:Initialize(ArmyBrains[UEF], 'MainBase', 'M3_UEF_Base_Marker', 200, {MainBase = 100})
    UEFBase:StartNonZeroBase({7, 5})
    UEFBase:SetActive('AirScouting', true)
    UEFBase:SetActive('LandScouting', true)

    UEFBase:AddExpansionBase('M2_UEF_Firebase', 6)
    UEFBase:AddExpansionBase('M3Firebase_1', 4)
    UEFBase:AddExpansionBase('M3Firebase_2', 4)

    UEFBaseLandAttacks()
    UEFBaseAirAttacks()
    UEFBaseTransportAttacks()
end

function DisableShields()
    UEFBase:SetActive('Shields', false)
end

function UEFBaseLandAttacks()
    local opai = nil
    local quantity = {}

    quantity = {6, 8, 10}

    for i = 1, Difficulty do
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack_1_'..i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M3_BaseLandAttack_1'
                },
                Priority = 1000,
            }
        )
        opai:SetChildQuantity('LightTanks', quantity[Difficulty])
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    quantity = {4, 6, 8}
    opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_BaseLandAttack_1'
            },
            Priority = 975,
        }
    )
    opai:SetChildQuantity('LightArtillery', quantity[Difficulty])

    quantity = {8, 12, 16}
    opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_BaseLandAttack_2'
            },
            Priority = 950,
        }
    )
    opai:SetChildQuantity('LightBots', quantity[Difficulty])

    quantity = {6, 8, 10}
    opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M3_BaseLandAttack_1', 
                                'M3_BaseLandAttack_2'},
            },
            Priority = 925,
        }
    )
    opai:SetChildQuantity('LightArtillery', quantity[Difficulty])

    for i = 1, Difficulty * 2 do
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack5_'..i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
                PlatoonData = {
                    PatrolChains = {'M3_BaseLandAttack_1', 
                                    'M3_BaseLandAttack_2'},
                },
                Priority = 900,
            }
        )
        opai:SetChildQuantity('LightBots', 8)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    if Difficulty == 3 then
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack6',
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
                PlatoonData = {
                    PatrolChains = {'M3_BaseLandAttack_1', 
                                    'M3_BaseLandAttack_2'},
                },
                Priority = 875,
            }
        )
        opai:SetChildQuantity('HeavyTanks', 6)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack7',
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
                PlatoonData = {
                    PatrolChain = 'M3_BaseAirAttack_1'
                },
                Priority = 850,
            }
        )
        opai:SetChildQuantity('AmphibiousTanks', 6)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    for i = 1, Difficulty * 2 do 
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack8_'..i,
            {
                MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
                PlatoonData = {
                    PatrolChains = {'M3_BaseLandAttack_1', 
                                    'M3_BaseLandAttack_2'},
                },
                Priority = 825,
            }
        )
        opai:SetChildQuantity('LightTanks', 10)
        opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    end

    opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_BaseLandAttack9',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M3_BaseLandAttack_1', 
                                'M3_BaseLandAttack_2'},
            },
            Priority = 800,
        }
    )
    opai:SetChildQuantity('LightArtillery', 6 * Difficulty)
    opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
    {'default_brain', 'Player', 1, categories.xnb2101})

    -- Send some custom patrols
    Temp = {
        'M3_TempAttack_Land_1',
        'NoPlan',
        { 'uel0201', 1, 16, 'Attack', 'GrowthFormation' },
        { 'uel0103', 1, 4, 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, 2, 'Attack', 'GrowthFormation' },
        { 'uel0106', 1, 6, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'M3_BaseLandAttack10',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 775,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'MainBase',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'M3_BaseLandAttack_1', 'M3_BaseLandAttack_2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )

    Temp = {
        'M3_TempAttack_Land_2',
        'NoPlan',
        { 'uel0201', 1, 6, 'Attack', 'GrowthFormation' },
        { 'uel0202', 1, 4, 'Attack', 'GrowthFormation' },
        { 'uel0104', 1, 4, 'Attack', 'GrowthFormation' },
        { 'uel0203', 1, 2, 'Attack', 'GrowthFormation' },
    }
    Builder = {
        BuilderName = 'M3_BaseLandAttack11',
        PlatoonTemplate = Temp,
        InstanceCount = 1,
        Priority = 750,
        PlatoonType = 'Land',
        RequiresConstruction = true,
        LocationType = 'MainBase',
        PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
        PlatoonData = {
            PatrolChains = {'M3_BaseLandAttack_1', 'M3_BaseLandAttack_2'}
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end


function UEFBaseAirAttacks()
    local opai = nil
    local quantity = {}
    local trigger = {}

    -- Maintain Patrols
    quantity = {8, 12, 16}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_MaintainPatrols_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_IntPatrol1_Chain'
            },
            Priority = 300,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])

    -- Maintain Patrols
    quantity = {6, 8, 10}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_MaintainPatrols_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_IntPatrol2_Chain'
            },
            Priority = 275,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])

    -- Maintain Patrols
    quantity = {8, 10, 12}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_MaintainPatrols_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_IntPatrol3_Chain'
            },
            Priority = 250,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])

    -- Platoon of Ints
    quantity = {8, 10, 12}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_1',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_BaseAirAttack_1'
            },
            Priority = 225,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
        {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})

    -- Platoon of Ints 2
    quantity = {8, 12, 16}
    trigger = {20, 15, 10}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_2',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M3_BaseAirAttack_1', 
                                'M3_BaseAirAttack_2'},
            },
            Priority = 200,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
        {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})

    -- Construct Bomber Attack
    quantity = {4, 5, 6}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_3',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_BaseAirAttack_1'
            },
            Priority = 175,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])

    -- Construct Bomber Attack
    quantity = {6, 8, 10}
    trigger = {25, 20, 15}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_4',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
            PlatoonData = {
                PatrolChain = 'M3_BaseAirAttack_2'
            },
            Priority = 550,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
    {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.LAND * categories.MOBILE, '>='})

    -- Construct Bomber Attack
    quantity = {6, 7, 8}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_5',
        {
            MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
            PlatoonData = {
                PatrolChains = {'M3_BaseLandAttack_1', 
                                'M3_BaseLandAttack_2'},
            },
            Priority = 525,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])

    -- Target enemy ship
    quantity = {5, 7, 9}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_6',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
            PlatoonData = {
              CategoryList = { categories.xnc0001 },
            },
            Priority = 500,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
    {'default_brain', 'Player', 1, categories.xnc0001})

    -- Target Captured Factory
    quantity = {4, 5, 6}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_7',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
            PlatoonData = {
              CategoryList = { categories.ueb0101 },
            },
            Priority = 350,
        }
    )
    opai:SetChildQuantity('Bombers', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
    {'default_brain', 'Player', 1, categories.ueb0101})

    if Difficulty == 3 then
        opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_8',
            {
                MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
                PlatoonData = {
                  CategoryList = { categories.xnb1103 },
                },
                Priority = 400,
            }
        )
        opai:SetChildQuantity('Gunships', 8)
        opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain', 'Player', 1, categories.xnb1103})

        opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_9',
            {
                MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
                PlatoonData = {
                  CategoryList = { categories.ueb0101 },
                },
                Priority = 325,
            }
        )
        opai:SetChildQuantity('Gunships', 4)
        opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
        {'default_brain', 'Player', 1, categories.ueb0101})
    end

    quantity = {8, 14, 20}
    opai = UEFBase:AddOpAI('AirAttacks', 'M3_BaseAirAttack_10',
        {
            MasterPlatoonFunction = {'/lua/ScenarioPlatoonAI.lua', 'CategoryHunterPlatoonAI'},
            PlatoonData = {
                CategoryList = { categories.AIR * categories.MOBILE },
            },
            Priority = 300,
        }
    )
    opai:SetChildQuantity('Interceptors', quantity[Difficulty])
    opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
        {'default_brain', {'HumanPlayers'}, trigger[Difficulty], categories.AIR * categories.MOBILE, '>='})
end

function UEFBaseTransportAttacks()
    local opai = nil
    local quantity = {}

    -- Transport Builder
    opai = UEFBase:AddOpAI('EngineerAttack', 'M3_Base_TransportBuilder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {
            AttackChain = 'M3_BaseTransport_Attack_Route',
            LandingChain = 'M3_BaseTransport_Drop_Chain',
            TransportReturn = 'M3_UEF_Base_Marker',
        },
        Priority = 1000,
    })
    opai:SetChildActive('All', false)
    opai:SetChildActive('T1Transports', true)
    opai:SetChildQuantity('T1Transports', 8)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 8, categories.uea0107})

    -- Drops
    for i = 1, Difficulty do
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_UEFTLandAttack1' .. i,
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'M3_BaseTransport_Attack_Route',
                LandingChain = 'M3_BaseTransport_Drop_Chain',
                TransportReturn = 'M3_UEF_Base_Marker',
            },
            Priority = 250,
        })
        opai:SetChildQuantity('LightTanks', 6)
        opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
            'HaveGreaterThanUnitsWithCategory', {'default_brain', 1, categories.uea0107})
    end

    for i = 1, Difficulty do
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_UEFTLandAttack2' .. i,
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'M3_BaseTransport_Attack_Route',
                LandingChain = 'M3_BaseTransport_Drop_Chain',
                TransportReturn = 'M3_UEF_Base_Marker',
            },
            Priority = 225,
        })
        opai:SetChildQuantity('LightBots', 8)
        opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
            'HaveGreaterThanUnitsWithCategory', {'default_brain', 1, categories.uea0107})
    end

    for i = 1, Difficulty do
        opai = UEFBase:AddOpAI('BasicLandAttack', 'M3_UEFTLandAttack3' .. i,
        {
            MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
            PlatoonData = {
                AttackChain = 'M3_BaseTransport_Attack_Route',
                LandingChain = 'M3_BaseTransport_Drop_Chain',
                TransportReturn = 'M3_UEF_Base_Marker',
            },
            Priority = 200,
        })
        opai:SetChildQuantity('LightArtillery', 6)
        opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
            'HaveGreaterThanUnitsWithCategory', {'default_brain', 1, categories.uea0107})
    end
end

function BuildAIProtection(ACU)
    Temp = {
        'ACUProtectionTemp',
        'NoPlan',
        { 'uel0201', 1, 8, 'Attack', 'GrowthFormation' },
        { 'uel0202', 1, 6, 'Attack', 'GrowthFormation' },
        { 'uel0205', 1, 4, 'Attack', 'GrowthFormation' },
        { 'uel0203', 1, 4, 'Attack', 'GrowthFormation' },
    }
    Builder = {
    BuilderName = 'ACUProtection',
    PlatoonTemplate = Temp,
    InstanceCount = 1,
    Priority = 1000,
    PlatoonType = 'Land',
    RequiresConstruction = true,
    LocationType = 'MainBase',
    PlatoonAIFunction = {CustomAIOrders, 'IssueGuardOrder'},     
    PlatoonData = {
            UnitToGuard = ACU
        },
    }
    ArmyBrains[UEF]:PBMAddPlatoon(Builder)
end

function DisableBase()
    if(UEFBase) then
        UEFBase:BaseActive(false)
    end
end

function DisbandACUPlatoon()
    for _, platoon in ArmyBrains[UEF]:GetPlatoonsList() do
        for _, unit in platoon:GetPlatoonUnits() do
            if EntityCategoryContains( categories.uel0001, unit ) then
                ArmyBrains[UEF]:DisbandPlatoon(platoon)

                -- Put into a platoon to make sure the base manager won't grab it again
                local plat = ArmyBrains[UEF]:MakePlatoon('', '')
                ArmyBrains[UEF]:AssignUnitsToPlatoon(plat, {unit}, 'Attack', 'NoFormation')
            end
        end
    end
end
