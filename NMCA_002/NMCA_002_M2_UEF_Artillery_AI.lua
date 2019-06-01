local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFArtilleryBase = BaseManager.CreateBaseManager()

function UEFArtilleryBaseFunction()
    UEFArtilleryBase:Initialize(ArmyBrains[UEF], 'M2_Arty_Base_Units', 'M2_UEF_Artillery_Base_Marker', 100, {M2_Arty_Base_Units = 100})
    UEFArtilleryBase:StartNonZeroBase({{16, 12, 10}, {8, 6, 4}})
    UEFArtilleryBase.MaximumConstructionEngineers = 5
	UEFArtilleryBase:SetActive('AirScouting', true)

    UEFArtilleryBase:AddBuildGroup('M2_Arty_Base_Expansion_D' .. Difficulty, 100, false)

	UEFArtilleryBase_LandAttacks()
	UEFArtilleryBase_AirAttacks()
	UEFArtilleryBase_TransportAttacks()
end

function UEFArtilleryBase_AirAttacks()
	local opai = nil
	local quantity = {}

	quantity = {8, 8, 10}
	opai = UEFArtilleryBase:AddOpAI('AirAttacks', 'M2_UEF_Artillery_Base_AirAttack_1',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChain = 'M2_UEF_Artillery_Base_Air_Attack_1'
			},
			Priority = 600,
		}
	)
	opai:SetChildQuantity('Bombers', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
	
	quantity = {8, 8, 10}
	opai = UEFArtilleryBase:AddOpAI('AirAttacks', 'M2_UEF_Artillery_Base_AirAttack_2',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChain = 'M2_UEF_Artillery_Base_Air_Attack_2'
			},
			Priority = 600,
		}
	)
	opai:SetChildQuantity('Bombers', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

	quantity = {4, 4, 6}
	opai = UEFArtilleryBase:AddOpAI('AirAttacks', 'M2_UEF_Artillery_Base_AirAttack_3',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChain = 'M2_UEF_Artillery_Base_Air_Attack_1'
			},
			Priority = 575,
		}
	)
	opai:SetChildQuantity('Gunships', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
	
	quantity = {4, 4, 6}
	opai = UEFArtilleryBase:AddOpAI('AirAttacks', 'M2_UEF_Artillery_Base_AirAttack_4',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChain = 'M2_UEF_Artillery_Base_Air_Attack_2'
			},
			Priority = 575,
		}
	)
	opai:SetChildQuantity('Gunships', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

	quantity = {4, 6, 8}
	opai = UEFArtilleryBase:AddOpAI('AirAttacks', 'M2_UEF_Artillery_Base_AirAttack_5',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChain = 'M2_UEF_Artillery_Base_Air_Attack_1'
			},
			Priority = 575,
		}
	)
	opai:SetChildQuantity('Gunships', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

	quantity = {6, 8, 10}
	opai = UEFArtilleryBase:AddOpAI('AirAttacks', 'M2_UEF_Artillery_Base_AirAttack_6',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChain = 'M2_UEF_Artillery_Base_Cybran_Attack'
			},
			Priority = 550,
		}
	)
	opai:SetChildQuantity('Gunships', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})

	quantity = {4, 4, 6}
	opai = UEFArtilleryBase:AddOpAI('AirAttacks', 'M2_UEF_Artillery_Base_AirAttack_7',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
			PlatoonData = {
				PatrolChain = 'M2_UEF_Artillery_Base_Cybran_Attack'
			},
			Priority = 525,
		}
	)
	opai:SetChildQuantity('CombatFighters', quantity[Difficulty])
	opai:SetLockingStyle('DeathRatio', {Ratio = 0.5})
	
	Temp = {
       'UEFAirM2AttackTemp0',
       'NoPlan',
       { 'uea0103', 1, 5, 'Attack', 'GrowthFormation' }, --Bombers
       { 'uea0102', 1, 9, 'Attack', 'GrowthFormation' }, --Fighters
       { 'uea0203', 1, 4, 'Attack', 'GrowthFormation' }, --Gunships 	 	   
    }
    Builder = {
       BuilderName = 'UEFAirM2AttackBuilder0',
       PlatoonTemplate = Temp,
       InstanceCount = 2,
       Priority = 70,
       PlatoonType = 'Air',
       RequiresConstruction = true,
       LocationType = 'M2_Arty_Base_Units',
      PlatoonAIFunction = {SPAIFileName, 'RandomDefensePatrolThread'},     
       PlatoonData = {
           PatrolChain = 'M2_UEF_Air_Base_Patrol_Chain_1'
       },
    }
    ArmyBrains[UEF]:PBMAddPlatoon( Builder )
	
end

function UEFArtilleryBase_LandAttacks()
	local opai = nil
	local quantity = {}
	
	opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_Artillery_Base_Land_Patrol_1', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_UEF_Air_Base_Patrol_Chain_1'
           },
           Priority = 1000,
		}
	)
	opai:SetChildQuantity('HeavyTanks', 6)

	opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_Artillery_Base_Land_Patrol_2', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_UEF_Air_Base_Patrol_Chain_1'
           },
           Priority = 975,
		}
	)
	opai:SetChildQuantity('MobileFlak', 4)

	opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_Artillery_Base_Land_Patrol_3', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_UEF_Artillery_Base_Cybran_Attack'
           },
           Priority = 950,
		}
	)
	opai:SetChildQuantity('LightTanks', 16)

	opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_Artillery_Base_Land_Patrol_5', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_UEF_Artillery_Base_Cybran_Attack'
           },
           Priority = 900,
		}
	)
	opai:SetChildQuantity('HeavyTanks', 6)

	quantity = {8, 12, 16}
	opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_Artillery_Base_Land_Patrol_6', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_UEF_Artillery_Base_Land_Attack_1'
           },
           Priority = 875,
		}
	)
	opai:SetChildQuantity('LightTanks', quantity[Difficulty])

	quantity = {12, 16, 20}
	opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_Artillery_Base_Land_Patrol_7', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_UEF_Artillery_Base_Land_Attack_1'
           },
           Priority = 850,
		}
	)
	opai:SetChildQuantity('LightBots', quantity[Difficulty])

	quantity = {2, 3, 4}
	opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_Artillery_Base_Land_Patrol_8', 
		{
	       MasterPlatoonFunction = {SPAIFileName, 'PatrolThread'},
           PlatoonData = {
               PatrolChain = 'M2_UEF_Artillery_Base_Land_Attack_1'
           },
           Priority = 825,
		}
	)
	opai:SetChildQuantity('MobileFlak', quantity[Difficulty])
end

function UEFArtilleryBase_TransportAttacks()
	local opai = nil
    local quantity = {}

    -- Transport Builder
    opai = UEFArtilleryBase:AddOpAI('EngineerAttack', 'M2_Artillery_Base_Transport_Builder',
    {
        MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
        PlatoonData = {
            AttackChain = 'M1_UEF_Transport_Troops_Chain',
            LandingChain = 'M2_UEF_Artillery_Drop_Chain',
            TransportReturn = 'M2_UEF_Artillery_Base_Marker',
        },
        Priority = 1000,
    })
    opai:SetChildActive('All', false)
    opai:SetChildActive('T2Transports', true)
    opai:SetChildQuantity('T2Transports', 4)
    opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
        'HaveLessThanUnitsWithCategory', {'default_brain', 4, categories.uea0104})

	quantity = {10, 14, 18}
	for i = 1, Difficulty do
		opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_ArtilleryBase_Drop_' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M1_UEF_Transport_Troops_Chain',
				LandingChain = 'M2_UEF_Artillery_Drop_Chain',
				TransportReturn = 'M2_UEF_Artillery_Base_Marker',
			},
			Priority = 250,
		})
		opai:SetChildQuantity('LightTanks', quantity[Difficulty])
		opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
			'HaveGreaterThanUnitsWithCategory', {'default_brain', 1, categories.uea0104})
	end

	quantity = {6, 8, 10}
	for i = 1, Difficulty do
		opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_ArtilleryBase_Drop2_' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M1_UEF_Transport_Troops_Chain',
				LandingChain = 'M2_UEF_Artillery_Drop_Chain',
				TransportReturn = 'M2_UEF_Artillery_Base_Marker',
			},
			Priority = 225,
		})
		opai:SetChildQuantity('LightArtillery', quantity[Difficulty])
		opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
			'HaveGreaterThanUnitsWithCategory', {'default_brain', 1, categories.uea0104})
	end

	quantity = {8, 10, 12}
	for i = 1, Difficulty do
		opai = UEFArtilleryBase:AddOpAI('BasicLandAttack', 'M2_UEF_ArtilleryBase_Drop3_' .. i,
		{
			MasterPlatoonFunction = {SPAIFileName, 'LandAssaultWithTransports'},
			PlatoonData = {
				AttackChain = 'M1_UEF_Transport_Troops_Chain',
				LandingChain = 'M2_UEF_Artillery_Drop_Chain',
				TransportReturn = 'M2_UEF_Artillery_Base_Marker',
			},
			Priority = 200,
		})
		opai:SetChildQuantity('HeavyTanks', quantity[Difficulty])
		opai:AddBuildCondition('/lua/editor/unitcountbuildconditions.lua',
			'HaveGreaterThanUnitsWithCategory', {'default_brain', 1, categories.uea0104})
	end
end

function DisableBase()
    if(UEFArtilleryBase) then
        UEFArtilleryBase:BaseActive(false)
    end
end
