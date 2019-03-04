local Behaviors = import('/lua/ai/opai/OpBehaviors.lua')
local Objectives = import('/lua/SimObjectives.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Cinematics = import('/lua/cinematics.lua')
local OpStrings = import('/maps/NMCA_002/nomadbmwip_strings.lua')
local TauntManager = import('/lua/TauntManager.lua')
local PingGroups = import('/lua/ScenarioFramework.lua').PingGroups
local Utilities = import('/lua/utilities.lua')
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

-- AI
local M2CybranMainBaseAI = import('/maps/NMCA_002/NMCA_002_M2_Cybran_AI.lua')

-- Global Variables
ScenarioInfo.Player1 = 1
ScenarioInfo.Cybran = 2
ScenarioInfo.CybranCivilian = 3
ScenarioInfo.UEF = 4
ScenarioInfo.Player2 = 5
ScenarioInfo.Player3 = 6
ScenarioInfo.Player4 = 7
ScenarioInfo.PlayerACU = {}

-- Local Variables
local Player1 = ScenarioInfo.Player1
local Cybran = ScenarioInfo.Cybran
local CybranCivilian = ScenarioInfo.CybranCivilian
local UEF = ScenarioInfo.UEF
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3
local Player4 = ScenarioInfo.Player4

local Difficulty = ScenarioInfo.Options.Difficulty
local TimedExapansion = ScenarioInfo.Options.Expansion

local AssignedObjectives = {}

local M1UEFNavySpotted = false

local M1UEFScoutTimer = {300, 180, 90}
local M1CybranPatrolTimer = {240, 180, 120}
local M1UEFAirAttackTimer = {300, 240, 180}
local M1UEFTransportAttackTimer = {450, 300, 180}
local M1UEFACUSnipeTimer = {600, 450, 300}

local M1ExpansionTime = {23 * 60, 20 * 60, 17 * 60}
local M2ExpansionTime = {34 * 60, 31 * 60, 28 * 60}

-- Taunt Managers

function OnPopulate()
	ScenarioUtils.InitializeScenarioArmies()
	ScenarioFramework.SetPlayableArea('M1_Zone', false)

	SetArmyColor('UEF', 41, 40, 140)
	SetArmyColor('Cybran', 	128, 39, 37)
	SetArmyColor('CybranCivilian', 165, 9, 1)

    local colors = {
        ['Player1'] = {255, 135, 62},
        ['Player2'] = {255, 191, 128},
        ['Player3'] = {183, 101, 24},
        ['Player4'] = {250, 250, 0},
    }

    local tblArmy = ListArmies()
    for army, color in colors do
        if tblArmy[ScenarioInfo[army]] then
            ScenarioFramework.SetArmyColor(ScenarioInfo[army], unpack(color))
        end
    end

    ScenarioFramework.SetSharedUnitCap(1500)
	SetArmyUnitCap(UEF, 450)
	SetArmyUnitCap(Cybran, 450)
	SetArmyUnitCap(CybranCivilian, 150)
end

function OnStart(self)
	ScenarioFramework.AddRestrictionForAllHumans(categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL)
    ScenarioFramework.AddRestrictionForAllHumans(categories.UEF) # UEF Engineer
	ScenarioFramework.AddRestrictionForAllHumans(categories.NAVAL) # Navy

	-- Restrict the ACU Upgrades.
	ScenarioFramework.RestrictEnhancements({
		'AdvancedEngineering',
		'DoubleGuns',
		'GunUpgrade',
		'IntelProbe',
		'IntelProbeAdv',
		'MovementSpeedIncrease',
		'Capacitor',
		'OrbitalBombardment',
		'PowerArmor',
		'RapidRepair',
		'ResourceAllocation',
		'T3Engineering'
	})
	
	ScenarioInfo.Town = ScenarioUtils.CreateArmyGroup('CybranCivilian', 'M1_Civilian_Town')
	ScenarioUtils.CreateArmyGroup('CybranCivilian', 'M1_Civilian_Town_Power')

	local units = ScenarioUtils.CreateArmyGroupAsPlatoon('CybranCivilian', 'M1_Civilian_Engineers', 'NoFormation')
    for _, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M1_Civilian_Engineers_Patrol_Chain')))
	end

	ScenarioInfo.UEFNavyPatrol_1 = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_Navy_Patrol_1', 'AttackFormation')
	ScenarioFramework.PlatoonPatrolChain(ScenarioInfo.UEFNavyPatrol_1, 'M1_UEF_Navy_Patrol_Chain')

	ScenarioInfo.UEFNavyPatrol_2 = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_Navy_Patrol_2', 'AttackFormation')
	ScenarioFramework.PlatoonPatrolChain(ScenarioInfo.UEFNavyPatrol_2, 'M1_UEF_Navy_Patrol_Chain')

	ScenarioUtils.CreateArmyGroup('Cybran', 'M1_Forward_Walls')
	ScenarioInfo.M1CybranDefences = ScenarioUtils.CreateArmyGroup('Cybran', 'M1_Forward_Civilian_Defenses_D' .. Difficulty)
	
	ForkThread(M1IntroScene)
end

-- M1 Functions
function M1IntroScene()
	Cinematics.EnterNISMode()
	WaitSeconds(1)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M1_Intro_Cam_1'), 2)

	ForkThread(function()
		for i = 1, table.getn(ScenarioInfo.HumanPlayers) do
			ScenarioInfo.PlayerACU[i] = ScenarioFramework.SpawnCommander('Player'..i, 'ACU', 'Warp', true, true, PlayerDeath)
			WaitSeconds(1)
		end
	end)

	WaitSeconds(4)

	ScenarioFramework.Dialogue(OpStrings.M2_Intro_CDR_Dropped_Dialogue, nil, true)
	WaitSeconds(8)

	local UEF_NIS_Units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_NIS_Units', 'AttackFormation')
	ScenarioFramework.CreatePlatoonDeathTrigger(M1_Play_Berry_Dialogue, UEF_NIS_Units)

	local VisMarker1_1 = ScenarioFramework.CreateVisibleAreaLocation(50, 'M1_NIS_Vismarker_1', 0, ArmyBrains[Player1])

	ScenarioInfo.Cybran_NIS_Units = ScenarioUtils.CreateArmyGroup('Cybran', 'M1_NIS_Units')
	local transports = ScenarioUtils.CreateArmyGroup('UEF', 'M1_NIS_Transports')

	WaitSeconds(2)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M1_Intro_Cam_2'), 2)
	WaitSeconds(2)

	ScenarioFramework.Dialogue(OpStrings.M2_Intro_Fight_Dialogue, nil, true)

	for _, v in transports do
		IssueStop({v})
		IssueClearCommands({v})
		IssueMove({v}, ScenarioUtils.MarkerToPosition('M1_NIS_Remove_UEF_Transports'))
		ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, v,  ScenarioUtils.MarkerToPosition('M1_NIS_Remove_UEF_Transports'), 10)
	end

	WaitSeconds(14)

	ScenarioFramework.Dialogue(OpStrings.M2_Intro_CDR_Dropped_Dialogue_2, nil, true)

	VisMarker1_1:Destroy()
	Cinematics.ExitNISMode()

	ScenarioFramework.CreateArmyIntelTrigger(M1SetNavalSecondaryObjective, ArmyBrains[Player1], 'LOSNow', false, true,  categories.NAVAL, true, ArmyBrains[UEF] )
	
	ForkThread(M1Objectives)
end

function M1_Play_Berry_Dialogue()
	ScenarioFramework.Dialogue(OpStrings.M2_Berry_Cybran_Interaction, nil, true)
	
	for _, v in ScenarioInfo.Cybran_NIS_Units do
		IssueStop({v})
		IssueClearCommands({v})
		IssueMove({v}, ScenarioUtils.MarkerToPosition('M1_NIS_Remove_Cybran_Units'))
		ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, v,  ScenarioUtils.MarkerToPosition('M1_NIS_Remove_Cybran_Units'), 10)
	end
end

function M1Objectives() 
    ScenarioInfo.M1P1 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        'Neutralize Civilian Town',
        'Scans indicate that there are hostile defence structures located in a civilian town to the east. Destroy the hostile defences and seize control of the town.',
        {
			FlashVisible = true,
            Units = ScenarioInfo.M1CybranDefences,
        }
    )
	ScenarioInfo.M1P1:AddResultCallback(
        function(result)
			if(result) then
				ForkThread(M2NISIntro)
            end
        end
	)
	table.insert(AssignedObjectives, ScenarioInfo.M1P1)
	
	ScenarioInfo.M1P2 = Objectives.Protect(
        'primary',
        'incomplete',
        'Civilian Town Must Not Be Harmed',
        'We must capture the town intact, do not destroy any civilian buildings.',
        {
            Units = ScenarioInfo.Town,
        }
    )
	table.insert(AssignedObjectives, ScenarioInfo.M1P2)

	ScenarioInfo.M1S1 = Objectives.UnitStatCompare(
		'secondary',
		'incomplete',
		'ACU Prototype Weapon Test',
		'Kill 10 enemy units with your prototype ACU.',
		'kill',
		{
			Unit = ScenarioInfo.PlayerACU[1],
			StatName = 'KILLS',
			CompareOp = '>=',
			Value = 10,
			ShowProgress = true,
		}
	)
	table.insert(AssignedObjectives, ScenarioInfo.M1S1)

	ScenarioFramework.CreateTimerTrigger(M1UEFScoutHandler, M1UEFScoutTimer[Difficulty])
	ScenarioFramework.CreateTimerTrigger(M1CybranPatrols, M1CybranPatrolTimer[Difficulty])
end

function M1SetNavalSecondaryObjective()
	if not M1UEFNavySpotted then
		M1UEFNavySpotted = true
		ScenarioFramework.Dialogue(OpStrings.M2_Secure_River_Dialogue, M1UnlockNavalTech, true)

		ScenarioInfo.M1S2 = Objectives.CategoriesInArea(
			'secondary',
			'incomplete',
			'Destroy UEF Naval Patrol',
			'Secure the river by destroying the local UEF Naval patrol.',
			'kill',
			{
				MarkUnits = true,
				Requirements = {
					{ Area = 'M1_River_Area', Category = categories.ues0103, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
				},
			}
		)
		ScenarioInfo.M1S2:AddResultCallback(
			function(result)
				if(result) then
					ForkThread(M1UEFNavyAttacks)
				end
			end
		)
		table.insert(AssignedObjectives, ScenarioInfo.M1S2)
	end
end

function M1UnlockNavalTech()
	ScenarioFramework.PlayUnlockDialogue()
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.inb0103)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.ins1001)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.ins1002)
end

function M1UEFScoutHandler()
	local scouts = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_Air_Scouts', 'NoFormation')
	ScenarioFramework.PlatoonPatrolChain(scouts, 'M1_UEF_Scout_Chain')

	ScenarioFramework.CreateTimerTrigger(M1UEFAirAttacks, M1UEFAirAttackTimer[Difficulty])
	ScenarioFramework.CreateTimerTrigger(M1UEFTransportAttacks, M1UEFTransportAttackTimer[Difficulty])
	ScenarioFramework.CreateTimerTrigger(M1UEFACUSnipeAttempts, M1UEFACUSnipeTimer[Difficulty])
end

function M1UEFAirAttacks()
	while ScenarioInfo.M1P1.Active do
		local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_AirAttacks_D' ..Difficulty, 'AttackFormation')
		ScenarioFramework.PlatoonPatrolChain(units, 'M1_UEF_Air_Attack_Chain')
		WaitSeconds(M1UEFAirAttackTimer[Difficulty])
	end
end

function M1UEFNavyAttacks()
	if ScenarioInfo.M1P1.Active then
		WaitSeconds(45)
		local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_NavyAttacks_D' ..Difficulty, 'AttackFormation')
		ScenarioFramework.PlatoonPatrolChain(units, 'M1_UEF_Navy_Attack_Chain')
		ScenarioFramework.CreatePlatoonDeathTrigger(M1UEFNavyAttacks, units)
	end
end

function M1UEFACUSnipeAttempts()
	if ScenarioInfo.M1P1.Active then
		local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_ACU_Snipe_Units_D' ..Difficulty, 'AttackFormation')

		for _, unit in units:GetPlatoonUnits() do
			IssueAttack({unit}, ScenarioInfo.PlayerACU[Random(1, table.getn(ScenarioInfo.PlayerACU))])
		end

		WaitSeconds(M1UEFACUSnipeTimer[Difficulty])
	end
end

function M1UEFTransportAttacks()
	if ScenarioInfo.M1P1.Active then
		local destination = ScenarioUtils.MarkerToPosition('M1_UEF_Transport_Drop_0' .. Random(1, 3))

		local transports = ScenarioUtils.CreateArmyGroup('UEF', 'M1_Transports_D' .. Difficulty)
		local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_Transport_Units_D' .. Difficulty, 'AttackFormation')

		import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)

		for _, transport in transports do
			ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('M1_NIS_Remove_UEF_Transports'), 15)

			IssueTransportUnload({transport}, destination)
			IssueMove({transport}, ScenarioUtils.MarkerToPosition('M1_NIS_Remove_UEF_Transports'))
		end
		
		ScenarioFramework.PlatoonPatrolChain(units, 'M2_Transport_Attack_Route')

		WaitSeconds(M1UEFTransportAttackTimer[Difficulty])
	end
end

function M1CybranPatrols()
	local i = 1

	while ScenarioInfo.M1P1.Active do
		local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'M1_Cybran_Patrol_' .. i .. '_D' ..Difficulty, 'AttackFormation')
		ScenarioFramework.PlatoonPatrolChain(units, 'M1_Cybran_Patrol_Chain')
		WaitSeconds(M1CybranPatrolTimer[Difficulty])
		i = i + 1

		if (i == 3) then
			i = 1
		end
	end
end

-- M2 Functions
function M2NISIntro()
	-- Spawn M2 Units
	ScenarioInfo.CybranCommander = ScenarioFramework.SpawnCommander('Cybran', 'CybranCommander', false, 'Cybran_Name', false, false,
	{'MicrowaveLaserGenerator', 'T3Engineering', 'ResourceAllocation'})
	
	-- Call the AI
	M2CybranMainBaseAI:CybranMainBaseAI()

	-- Expand the necessary areas 
	ScenarioFramework.SetPlayableArea('M2_Zone', true)

	-- Fix alliances between the Nomads and the Cybran.
	for _, player in ScenarioInfo.HumanPlayers do
		SetAlliance(player, Cybran, 'Ally')
		SetAlliance(Cybran, player, 'Ally')

		SetAlliance(CybranCivilian, player, 'Ally')
		SetAlliance(player, CybranCivilian, 'Ally')
	end

	-- Create M2 Cybran Patrols

end

function M2PlayerReinforcements()

end

-- Utility Functions
function PlayerDeath(deadCommander)
	ScenarioFramework.PlayerDeath(deadCommander, nil, AssignedObjectives)
end

function DestroyUnit(unit)
	unit:Destroy()
end

function CybranCommanderDeath()
	ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.CybranCommander)

	for k, v in AssignedObjectives do
        if(v and v.Active) then
            v:ManualResult(false)
        end
    end
end