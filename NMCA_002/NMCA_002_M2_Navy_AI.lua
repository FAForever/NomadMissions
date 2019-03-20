local BaseManager = import('/lua/ai/opai/basemanager.lua')
local SPAIFileName = '/lua/scenarioplatoonai.lua'

local UEF = 4

local Difficulty = ScenarioInfo.Options.Difficulty

local UEFNavyBase = BaseManager.CreateBaseManager()

function UEFNavyBaseFunction()
    UEFNavyBase:Initialize(ArmyBrains[UEF], 'M2_Naval_Base', 'M2_UEF_Naval_Base_Marker', 100, {M2_Naval_Base = 100})
    UEFNavyBase:StartNonZeroBase({{14, 12, 10}, {10, 8, 6}})

	UEFNavyBase:SetActive('AirScouting', true)

	UEFNavyBase_AirAttacks()
	UEFNavy_NavalAttacks()
end

function UEFNavyBase_AirAttacks()
	-- Start with some attacks on the player. Based on what they have, the attacks will get heavier.
	local opai = nil
	local quantity = {}

	quantity = {4, 6, 8}
	opai = UEFNavyBase:AddOpAI('AirAttacks', 'M2_UEF_NavalBase_AirAttack_1',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
			PlatoonData = {
				PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2'}
			},
			Priority = 600,
		}
	)
	opai:SetChildQuantity('Bombers', quantity[Difficulty])

	quantity = {6, 10, 14}
	opai = UEFNavyBase:AddOpAI('AirAttacks', 'M2_UEF_NavalBase_AirAttack_2',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
			PlatoonData = {
				PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2'}
			},
			Priority = 575,
		}
	)
	opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
		{'default_brain', {'HumanPlayers'}, 20, categories.AIR * categories.MOBILE, '>='})
	opai:SetChildQuantity('Interceptors', quantity[Difficulty])

	quantity = {4, 6, 8}
	opai = UEFNavyBase:AddOpAI('AirAttacks', 'M2_UEF_NavalBase_AirAttack_3',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
			PlatoonData = {
				PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2'}
			},
			Priority = 550,
		}
	)
	opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
		{'default_brain', {'HumanPlayers'}, 2, categories.AIR * categories.FACTORY, '>='})
	opai:SetChildQuantity('Gunships', quantity[Difficulty])

	quantity = {4, 6, 8}
	opai = UEFNavyBase:AddOpAI('AirAttacks', 'M2_UEF_NavalBase_AirAttack_4',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
			PlatoonData = {
				PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2'}
			},
			Priority = 525,
		}
	)
	opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
		{'default_brain', {'HumanPlayers'}, 2, categories.AIR * categories.FACTORY, '>='})
	opai:SetChildQuantity('CombatFighters', quantity[Difficulty])

	quantity = {5, 7, 11}
	opai = UEFNavyBase:AddOpAI('AirAttacks', 'M2_UEF_NavalBase_AirAttack_5',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
			PlatoonData = {
				PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2'}
			},
			Priority = 500,
		}
	)
	opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
		{'default_brain', {'HumanPlayers'}, 1, categories.NAVAL * categories.FACTORY, '>='})
	opai:SetChildQuantity('TorpedoBombers', quantity[Difficulty])

	quantity = {12, 20, 28}
	opai = UEFNavyBase:AddOpAI('AirAttacks', 'M2_UEF_NavalBase_AirAttack_6',
		{
			MasterPlatoonFunction = {SPAIFileName, 'PatrolChainPickerThread'},
			PlatoonData = {
				PatrolChains = {'M2_UEF_Player_Air_Attack_Chain_1', 'M2_UEF_Player_Air_Attack_Chain_2'}
			},
			Priority = 575,
		}
	)
	opai:AddBuildCondition('/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainsCompareNumCategory',
		{'default_brain', {'HumanPlayers'}, 35, categories.AIR * categories.MOBILE, '>='})
	opai:SetChildQuantity('Interceptors', quantity[Difficulty])
end

function UEFNavy_NavalAttacks()
	local Temp = {
		'NavalAttackTemp',
		'NoPlan',
		{ 'ues0103', 1, 6, 'Attack', 'GrowthFormation' },
		{ 'ues0203', 1, 4, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'NavyAttackBuilder',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 1000,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	local Temp = {
		'NavalAttackTemp2',
		'NoPlan',
		{ 'ues0103', 1, 8, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'NavyAttackBuilder2',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 975,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	local Temp = {
		'NavalAttackTemp3',
		'NoPlan',
		{ 'ues0201', 1, 2, 'Attack', 'GrowthFormation' },
		{ 'ues0103', 1, 4, 'Attack', 'GrowthFormation' },
		{ 'ues0203', 1, 2, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'NavyAttackBuilder3',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 950,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		BuildConditions = {
			{ '/lua/editor/otherarmyunitcountbuildconditions.lua', 'BrainGreaterThanOrEqualNumCategory',
			{'default_brain', 'Player', 2, categories.NAVAL * categories.FACTORY}},
		},
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )

	local Temp = {
		'NavalAttackTemp4',
		'NoPlan',
		{ 'ues0202', 1, 2, 'Attack', 'GrowthFormation' },
	}
	local Builder = {
		BuilderName = 'NavyAttackBuilder4',
		PlatoonTemplate = Temp,
		InstanceCount = 1,
		Priority = 925,
		PlatoonType = 'Sea',
		RequiresConstruction = true,
		LocationType = 'M2_Naval_Base',
		PlatoonAIFunction = {SPAIFileName, 'PatrolChainPickerThread'},     
		PlatoonData = {
			PatrolChains = {'M2_UEF_Player_Navy_Attack_Chain_1', 'M2_UEF_Player_Navy_Attack_Chain_2'}
		},
	}
	ArmyBrains[UEF]:PBMAddPlatoon( Builder )
end

function DisableBase()
    if (UEFNavyBase) then
        UEFNavyBase:BaseActive(false)
    end
end