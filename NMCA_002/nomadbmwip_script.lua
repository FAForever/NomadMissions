--****************************************************************************
--**
--**  File     :  /maps/NMCA_002/NMCA_002_script.lua
--**  Author(s):  JJ173, speed2, Exotic_Retard, zesty_lime, biass, Shadowlorda1, and Wise Old Dog (AKA The 'Mad Men)
--**
--**  Summary  :  This script for the Second mission of the Nomads campaign.
--**
--****************************************************************************

local Buff = import('/lua/sim/Buff.lua')
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
local M1CybranAirBaseAI = import('/maps/NMCA_002/NMCA_002_M1_Cybran_AI.lua')
local M2UEFNavalBaseAI = import('/maps/NMCA_002/NMCA_002_M2_Navy_AI.lua')
local M2UEFArtilleryBaseAI = import('/maps/NMCA_002/NMCA_002_M2_UEF_Artillery_AI.lua')
local M2UEFPlateauBaseAI = import('/maps/NMCA_002/NMCA_002_M2_UEF_Plateau_AI.lua')
local M3UEFMainBaseAI = import('/maps/NMCA_002/NMCA_002_M3_UEF_MainBase_AI.lua')

-- Global Variables
ScenarioInfo.Player1 = 1
ScenarioInfo.Cybran = 2
ScenarioInfo.CybranCivilian = 3
ScenarioInfo.UEF = 4
ScenarioInfo.Player2 = 5
ScenarioInfo.Player3 = 6
ScenarioInfo.Player4 = 7
ScenarioInfo.Nomads = 8
ScenarioInfo.PlayerACU = {}

-- Local Variables
local Player1 = ScenarioInfo.Player1
local Cybran = ScenarioInfo.Cybran
local CybranCivilian = ScenarioInfo.CybranCivilian
local UEF = ScenarioInfo.UEF
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3
local Player4 = ScenarioInfo.Player4
local Nomads = ScenarioInfo.Nomads

local Difficulty = ScenarioInfo.Options.Difficulty
local TimedExapansion = ScenarioInfo.Options.Expansion

local AssignedObjectives = {}

local M1UEFNavySpotted = false
local M2ReinforcementsIntro = false
local M2UEFNavyBaseDestroyed = false
local M2UEFLandBaseDestroyed = false

local M1Complete = false
local M2Complete = false

local M2UEFCybranAttackStage = 1

local M1UEFScoutTimer = {3*60, 2*60, 60}
local M1CybranPatrolTimer = {4*60, 3*60, 2*60}
local M1UEFAirAttackTimer = {3*60, 2*60, 1.7*60}
local M1UEFTransportAttackTimer = {4*60, 3*60, 2.5*60}
local M1UEFACUSnipeTimer = {180, 160, 140}

local M1ExpansionTime = {35*60, 30*60, 25*60}  --{19 * 60, 16 * 60, 13 * 60}
local M2ExpansionTime = {34 * 60, 31 * 60, 28 * 60}

local M2ReinforcementCoolDown = {5 * 60, 7 * 60, 10 * 60} -- Easy Difficuly: 5 Minutes, Medium Difficulty: 7 Minutes, Hard Difficulty: 10 Minutes.

-- Taunt Managers
local UEFTM = TauntManager.CreateTauntManager('UEFTM', '/maps/NMCA_002/nomadbmwip_strings.lua')

function OnPopulate(Scenario)
	ScenarioUtils.InitializeScenarioArmies()
	ScenarioFramework.SetPlayableArea('M1_Zone', false)

	SetArmyColor('UEF', 41, 40, 140)
	SetArmyColor('Cybran', 	128, 39, 37)
	SetArmyColor('CybranCivilian', 165, 9, 1)
	SetArmyColor('Nomads', 225, 135, 62)

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

    ScenarioFramework.SetSharedUnitCap(2000)
	SetArmyUnitCap(UEF, 1050)
	SetArmyUnitCap(Cybran, 1050)
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
    
	M1CybranAirBaseAI:CybranAirBaseAI()
	
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
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M1_Intro_Cam_3'), 2)

	ScenarioFramework.Dialogue(OpStrings.M2_Intro_CDR_Dropped_Dialogue_2, nil, true)

	VisMarker1_1:Destroy()

	WaitSeconds(2)

	Cinematics.ExitNISMode()

	local function MissionNameAnnouncement()
        ScenarioFramework.SimAnnouncement(ScenarioInfo.name, "mission by The 'Mad Men")
    end

    ScenarioFramework.CreateTimerTrigger(MissionNameAnnouncement, 7)
	ScenarioFramework.CreateArmyIntelTrigger(M1SetNavalSecondaryObjective, ArmyBrains[Player1], 'LOSNow', false, true,  categories.NAVAL, true, ArmyBrains[UEF] )
	
	-- Establish UEF Taunts
	ForkThread(UEFTaunts)

	-- Trigger M1 Objectives
	ForkThread(M1Objectives)
	
	buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 1.5

       for _, u in GetArmyBrain(Cybran):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
	
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
  
	ScenarioInfo.M1P1 = Objectives.CategoriesInArea(
        'primary',
        'incomplete',
        'Neutralize Civilian Town',
        'Scans indicate that there are hostile defence structures located in a civilian town to the east. Destroy the hostile defences and seize control of the town.',
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
			FlashVisible = true,
            Requirements = {
                {   
                    Area = 'M1_Zone',
                    Category = categories.FACTORY + categories.DEFENSE - categories.urb5101,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Cybran,
                },
            },
        }
	)
	ScenarioInfo.M1P1:AddResultCallback(
        function(result)
			if (result) then
				ScenarioFramework.Dialogue(OpStrings.M2_P2_Cutscene_Intro, M2NISIntro, true)
            end
        end
	)
	table.insert(AssignedObjectives, ScenarioInfo.M1P1)

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

	-- Expand to next part of the mission.
	if TimedExapansion then
		ScenarioFramework.CreateTimerTrigger(M2NISIntro, M1ExpansionTime[Difficulty])
	end
end

function M1SetNavalSecondaryObjective()
	if not M1UEFNavySpotted then
		M1UEFNavySpotted = true
		ScenarioFramework.Dialogue(OpStrings.M2_Secure_River_Dialogue, nil, true)
        
		ForkThread(M1UnlockNavalTech)
		
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
				if (result) then
					ForkThread(M1UEFNavyAttacks)
				end
			end
		)
		table.insert(AssignedObjectives, ScenarioInfo.M1S2)
	end
end

function M1UnlockNavalTech()

	ScenarioFramework.PlayUnlockDialogue()
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0103)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xns0103)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xns0203)
	
end

function M1UEFScoutHandler()
	local scouts = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_Air_Scouts', 'NoFormation')
	ScenarioFramework.PlatoonPatrolChain(scouts, 'M1_UEF_Scout_Chain')

	ScenarioFramework.CreateTimerTrigger(M1UEFAirAttacks, M1UEFAirAttackTimer[Difficulty])
	ScenarioFramework.CreateTimerTrigger(M1UEFTransportAttacks, M1UEFTransportAttackTimer[Difficulty])
	ScenarioFramework.CreateTimerTrigger(M1UEFACUSnipeAttempts, M1UEFACUSnipeTimer[Difficulty])
end

function M1UEFAirAttacks()
	if ScenarioInfo.M1P1.Active then
		ForkThread(function()
			local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_AirAttacks_D' ..Difficulty, 'AttackFormation')
			 ScenarioFramework.PlatoonPatrolChain(units, 'M1_UEF_Air_Attack_Chain' .. Random(1, 3))
			local units2 = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_Airattack2', 'AttackFormation')
			ScenarioFramework.PlatoonPatrolChain(units2, 'M1_UEF_Air_Attack_Chain4')
			WaitSeconds(M1UEFAirAttackTimer[Difficulty])
			ScenarioFramework.CreatePlatoonDeathTrigger(M1UEFAirAttacks, units)
		end)
	end
end

function M1UEFNavyAttacks()
	if ScenarioInfo.M1P1.Active then
		ForkThread(function()
			WaitSeconds(2.5*60)
			local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_NavyAttacks_D' ..Difficulty, 'AttackFormation')
			ScenarioFramework.PlatoonPatrolChain(units, 'M1_UEF_Navy_Attack_Chain')
			ScenarioFramework.CreatePlatoonDeathTrigger(M1UEFNavyAttacks, units)
		end)
	end
end

function M1UEFACUSnipeAttempts()
	if ScenarioInfo.M1P1.Active then	
		ForkThread(function()
			WaitSeconds(M1UEFACUSnipeTimer[Difficulty])
			local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_ACU_Snipe_Units_D' ..Difficulty, 'AttackFormation')

			for _, unit in units:GetPlatoonUnits() do
				IssueAttack({unit}, ScenarioInfo.PlayerACU[Random(1, table.getn(ScenarioInfo.PlayerACU))])
			end

			ScenarioFramework.CreatePlatoonDeathTrigger(M1UEFACUSnipeAttempts, units)
		end)
	end
end

function M1UEFTransportAttacks()
	if ScenarioInfo.M1P1.Active then
		ForkThread(function()
			WaitSeconds(M1UEFTransportAttackTimer[Difficulty])
			local destination = ScenarioUtils.MarkerToPosition('M1_UEF_Transport_Drop_0' .. Random(1, 3))

			local transports = ScenarioUtils.CreateArmyGroup('UEF', 'M1_Transports_D' .. Difficulty)
			local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M1_Transport_Units_D' .. Difficulty, 'AttackFormation')

			import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)

			for _, transport in transports do
				ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('M1_NIS_Remove_UEF_Transports'), 15)

				IssueTransportUnload({transport}, destination)
				IssueMove({transport}, ScenarioUtils.MarkerToPosition('M1_NIS_Remove_UEF_Transports'))
			end
		
			ScenarioFramework.PlatoonPatrolChain(units, 'M1_UEF_Transport_Troops_Chain')
			ScenarioFramework.CreatePlatoonDeathTrigger(M1UEFTransportAttacks, units)
		end)
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
	-- If this flag hasn't been marked as true, set it to true, that way we can exit the function straight away if this is true.
	if not M1Complete then
		M1Complete = true
	else
		return -- ABORT!
	end

	-- Spawn M2 Units
	ScenarioInfo.CybranCommander = ScenarioFramework.SpawnCommander('Cybran', 'CybranCommander', false, 'Jerrax', false, false,
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
	local CybranLandPatrol1 = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'M2_Cybran_Land_Patrol_1', 'AttackFormation')
	ScenarioFramework.PlatoonPatrolChain(CybranLandPatrol1, 'M2_Cybran_Main_Base_Land_Patrol_1_Chain')

	local CybranLandPatrol2 = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'M2_Cybran_Land_Patrol_2', 'AttackFormation')
	ScenarioFramework.PlatoonPatrolChain(CybranLandPatrol2, 'M2_Cybran_Main_Base_Land_Patrol_2_Chain')

	local CybranAirPatrol = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'M2_Cybran_Air_Patrol', 'AttackFormation')
	for k, v in CybranAirPatrol:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M2_Cybran_Main_Base_Air_Patrol_Chain')))
    end

	-- Create Cybran Town defences
	ScenarioUtils.CreateArmyGroup('Cybran', 'M2_Town_Defenses')

	-- Spawn the UEF AI
	M2UEFNavalBaseAI:UEFNavyBaseFunction()
	M2UEFArtilleryBaseAI:UEFArtilleryBaseFunction()
	M2UEFPlateauBaseAI:UEFPlateauBaseFunction()

	WaitSeconds(1)

	ScenarioUtils.CreateArmyGroup('UEF', 'M2_Arty_Base_Walls')
	ScenarioUtils.CreateArmyGroup('UEF', 'M2_Naval_Base_Walls')

	-- Create UEF Support buildings
	ScenarioUtils.CreateArmyGroup('UEF', 'M2_Naval_Base_Supports_D' .. Difficulty)
	ScenarioUtils.CreateArmyGroup('UEF', 'M2_Arty_Base_Supports')

	-- Create the UEF Navy Air Patrol
	local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_Naval_Base_Air_Patrol_D' .. Difficulty, 'GrowthFormation')

	for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M2_UEF_Naval_Base_Air_Patrol_Chain')))
    end

	-- We need to create a cutscene!
	Cinematics.EnterNISMode()
	Cinematics.CameraTrackEntity(ScenarioInfo.CybranCommander, 30, 1)
	WaitSeconds(2)
	ScenarioFramework.Dialogue(OpStrings.M2_P2_Cutscene_Dialogue, nil, true)
	WaitSeconds(1)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M2_Cam_01'), 2)
	WaitSeconds(4)
	local VisMarker2_1 = ScenarioFramework.CreateVisibleAreaLocation(50, 'M2_NIS_Vismarker_01', 0, ArmyBrains[Player1])
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M2_Cam_02'), 2)
	WaitSeconds(3)
	local VisMarker2_2 = ScenarioFramework.CreateVisibleAreaLocation(50, 'M2_NIS_Vismarker_02', 0, ArmyBrains[Player1])
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M2_Cam_03'), 2)
	WaitSeconds(3)
	Cinematics.CameraTrackEntity(ScenarioInfo.PlayerACU[1], 30, 1)
	WaitSeconds(2)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M2_Cam_Final'), 5)
	VisMarker2_1:Destroy()
	VisMarker2_2:Destroy()
	WaitSeconds(2)
	Cinematics.ExitNISMode()
	-- End Cutscene

	-- Assign some objectives.
	ForkThread(M2Objectives)

	-- Send UEF Engineers to base
	ForkThread(M2SendUEFEngineersToPlataeu)
	
	-- Trigger units that will attack the Cybran main base every now and again.
	ForkThread(M2SpawnUEFUnitsToAttackCybran)

	-- Handle player reinforcements.
	ScenarioFramework.CreateTimerTrigger(M2PlayerReinforcements, 15)
	
	ArmyBrains[UEF]:GiveResource('MASS', 10000)
    ArmyBrains[UEF]:GiveResource('ENERGY', 6000)
	
	buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 1.5

       for _, u in GetArmyBrain(UEF):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
	   
	buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 1.5

       for _, u in GetArmyBrain(Cybran):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
	
end

function M2Objectives()
	-- Handle the first objectives based on timed expansion.
	if TimedExapansion and ScenarioInfo.M1P1.Active then
		ScenarioInfo.M1P1:ManualResult(false)

		-- Spawn some UEF Transports to attack the town.
		local destination = ScenarioUtils.MarkerToPosition('M2_UEF_Town_Transport_Drop_' .. Random(1, 3))

		local transports = ScenarioUtils.CreateArmyGroup('UEF', 'M2_Town_Transports_D' .. Difficulty)
		local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_Town_Transport_Units_D' .. Difficulty, 'AttackFormation')

		import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)

		for _, transport in transports do
			ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('M2_Remove_UEF_Transports'), 15)

			IssueTransportUnload({transport}, destination)
			IssueMove({transport}, ScenarioUtils.MarkerToPosition('M2_Remove_UEF_Transports'))
		end
		
		ScenarioFramework.PlatoonPatrolChain(units, 'M2_UEF_Town_Transport_Attacker_Chain')
	end

	-- Set a new objective.
	ScenarioInfo.M2P1 = Objectives.Protect(
		'primary',
        'incomplete',                   
        'Protect Civilian Town',            
        'The UEF are attempting to destroy the Cybran Town to the East. Protect it. At least 50% of the Town must survive.',      
        {                               
			Units = ScenarioInfo.Town,         
            Timer = nil,
            NumRequired = math.floor(table.getn(ScenarioInfo.Town) / 2),
			ShowProgress = true,
		}
	)
	ScenarioInfo.M2P1:AddResultCallback(
        function(result)
			if (not result) then
				ScenarioFramework.PlayerLose(OpStrings.M2_P2_Town_Destroyed)
			end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P1)

	ScenarioInfo.M2P2 = Objectives.CategoriesInArea(
        'primary',                      -- type
        'incomplete',                   -- complete
        'Destroy UEF Naval Base',                 -- title
        'Destroy the UEF Naval Base to suppress the attacks on the Civilian Town.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'M2_UEF_Naval_Base',
                    Category = categories.FACTORY,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
            },
        }
	)
    ScenarioInfo.M2P2:AddResultCallback(
        function(result)
            if (result) then
				M2UEFNavyBaseDestroyed = true

				M2UEFArtilleryBaseAI:DisableBase()

				ForkThread(M2CheckObjectiveProgress)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P2)

	-- Make sure that the Cybran Commander is protected. We should make audio queues if he's taking damage.
	ScenarioInfo.M2P3 = Objectives.Protect(
		'primary',
        'incomplete',                   
        'Assist Cybran Commander',            
        'Ensure the safety of the Cybran Commander at all costs. We need that information that he is holding.',      
        {                               
			Units = {ScenarioInfo.CybranCommander},         
		}
	)
    table.insert(AssignedObjectives, ScenarioInfo.M2P3)

	ScenarioInfo.M2P4 = Objectives.CategoriesInArea(
        'primary',      
        'incomplete',               
        'Destroy Expanding UEF Base',  
        'Destroy the UEF Engineers constructing a base to the East of the Town.', 
        'kill',  
        {            
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'M2_UEF_Air_Base',
                    Category = categories.ENGINEER + categories.FACTORY,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
            },
        }
	)
    ScenarioInfo.M2P4:AddResultCallback(
        function(result)
			if (result) then
				M2UEFLandBaseDestroyed = true

				M2UEFArtilleryBaseAI:DisableBase()

				ForkThread(M2CheckObjectiveProgress)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2S1)
	
	ForkThread(M2SecondaryObjectives)
	
end

function M2SecondaryObjectives()

    WaitSeconds(3*60)

	ScenarioFramework.Dialogue(OpStrings.M2_P2_SecondaryObj, nil, true)
	
    ScenarioInfo.M2S1 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy UEF Artillery Base',                 -- title
        'Destroy the UEF Artillery Base to reduce pressure on the Cybran Commander.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'M2_ArtySObj',
                    Category = categories.FACTORY + categories.ENGINEER + categories.ueb2303,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
            },
        }
	)
    ScenarioInfo.M2S1:AddResultCallback(
        function(result)
            if (result) then
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2S1)

end

function M2SpawnUEFUnitsToAttackCybran()
	if ScenarioInfo.M2P1.Active then
		ForkThread(function() 
			WaitSeconds(25)
			local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_UEF_Attack_Cybran_Units_' .. M2UEFCybranAttackStage, 'AttackFormation')
			ScenarioFramework.PlatoonPatrolChain(units, 'M2_UEF_Cybran_Land_Attack_Chain')
			ScenarioFramework.CreatePlatoonDeathTrigger(M2SpawnUEFUnitsToAttackCybran, units)

			M2UEFCybranAttackStage = M2UEFCybranAttackStage + 1;

			if (M2UEFCybranAttackStage >= 4) then
				M2UEFCybranAttackStage = 1
			end
		end)
	end
end

function M2PlayerReinforcements()
	if (not M2ReinforcementsIntro) then
		ScenarioFramework.Dialogue(OpStrings.M2_IntroReinforcements, nil, true)
		M2ReinforcementsIntro = true
		ForkThread(M2UnlockT2Air)
	end

	ScenarioInfo.M2ReinforcementPing = PingGroups.AddPingGroup('Signal reinforcements', nil, 'move', 'Benson has prepared some prototype units to tackle the UEF. Signal them when you are ready.')
    ScenarioInfo.M2ReinforcementPing:AddCallback(M2SendPlayerReinforcements)
end

function M2UnlockT2Air()
    
	ScenarioFramework.PlayUnlockDialogue()
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0202)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0203)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0107)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0208)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0202)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.znb9502)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb1201)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb1202)

end

function M2SendPlayerReinforcements()
	ForkThread(function()
		ScenarioFramework.Dialogue(OpStrings.M2_ReinforcementsCalled, nil, true)

		ScenarioInfo.M2ReinforcementPing:Destroy()

		-- Load up some units in transports and send them to the player.
		local destination = ScenarioUtils.MarkerToPosition('M2_Nomads_Delivery_' .. Random(1, 3))

		local transports = ScenarioUtils.CreateArmyGroup('Nomads', 'M2_Reinforcment_Transports_D' .. Difficulty)
		local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'M2_Reinforcments_D' .. Difficulty, 'AttackFormation')
        WaitSeconds(2)
		import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)

		for _, transport in transports do
			ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('M2_Remove_Nomads_Transports'), 15)

			IssueTransportUnload({transport}, destination)
			IssueMove({transport}, ScenarioUtils.MarkerToPosition('M2_Remove_Nomads_Transports'))
		end

        for k, v in units:GetPlatoonUnits() do
			while (v:IsUnitState('Attached')) do
				WaitSeconds(.5)
		    return
			end

            if (v and not v:IsDead() and (v:GetAIBrain() == ArmyBrains[Nomads]) and not v:IsUnitState('Attached')) then
                ScenarioFramework.GiveUnitToArmy(v, Player1)
            end
        end

		ScenarioFramework.CreateTimerTrigger(M2PlayerReinforcements, M2ReinforcementCoolDown[Difficulty])
	end)
end

function M2SendUEFEngineersToPlataeu()
	-- We need to create some transports and send them to drop Engineers off on the Plateau next to the Cybran base. They will attempt to build artillery.
	-- The AI file that is in place will take care of the Engineers once they are dropped off. We only care about what the Engineers are doing during the phase
	-- of M2P1 (Protect the town) being active.
	if ScenarioInfo.M2P1 then
		WaitSeconds(45)
        
		local Aunits = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_UEF_Plateau_Air', 'GrowthFormation')

	for k, v in Aunits:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M2_UEF_Plateau_Patrol_Chain')))
    end
		
		local destination = ScenarioUtils.MarkerToPosition('M2_UEF_Engineer_Dropoff')

		local transports = ScenarioUtils.CreateArmyGroup('UEF', 'M2_UEF_Engineer_Transports')
		local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_UEF_Engineers', 'GrowthFormation')

		import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)

		for _, transport in transports do
			ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('M2_Remove_UEF_Transports'), 15)

			IssueTransportUnload({transport}, destination)
			IssueMove({transport}, ScenarioUtils.MarkerToPosition('M2_Remove_UEF_Transports'))
		end
		
		-- Disband the Platoon
		ArmyBrains[UEF]:DisbandPlatoon(units)
	end
end

function M2CheckObjectiveProgress()
	-- We can safely assume that both primary objectives have been completed at this point, we should now complete the city objective by force and move on with the mission.
	if (M2UEFLandBaseDestroyed and M2UEFNavyBaseDestroyed and ScenarioInfo.M2P1.Active) then
		ScenarioInfo.M2P1:ManualResult(true)

		-- Start up some dialogue to say that the city is safe for now.
		ScenarioFramework.Dialogue(OpStrings.M2_P2_Town_Safe, nil, true)
		
		ForkThread(M3NISIntro)
	end
end

--M3 Functions

function M3NISIntro()
   
	--let dialogue Finish 
	WaitSeconds(5)
	
    -- Spawn M3 Units
	ScenarioInfo.UEFCommander = ScenarioFramework.SpawnCommander('UEF', 'UEFCommander', false, 'Colonel Berry', true, false,
	{'HeavyAntiMatterCannon', 'AdvancedEngineering', 'ShieldGeneratorField'})
	
	 local Aunits = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_DefenceAir', 'GrowthFormation')

	for k, v in Aunits:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_UEF_Base_AirDefence')))
    end
	
	--Stops AI from using T3 engs as main build power
	ScenarioFramework.AddRestriction(UEF, categories.uel0309)
	
	-- Call the AI
	M3UEFMainBaseAI:UEFMainBaseAI()
	M2CybranMainBaseAI:M3CybranAttacks()

	-- Expand the necessary areas 
	ScenarioFramework.SetPlayableArea('M3_Zone', true)
	
	ScenarioUtils.CreateArmyGroup('UEF', 'M3_OuterDefenses_D' .. Difficulty)
	ScenarioUtils.CreateArmyGroup('UEF', 'M3_Firebase_D' .. Difficulty)
	ScenarioUtils.CreateArmyGroup('UEF', 'M3_Walls')
	ScenarioUtils.CreateArmyGroup('UEF', 'M3_Arty_Structures_D' .. Difficulty)
	
	--Secondary Obj structure
	ScenarioInfo.MissileLancher = ScenarioUtils.CreateArmyUnit('UEF', 'Missile')
    ScenarioInfo.MissileLancher:SetReclaimable(false)
    ScenarioInfo.MissileLancher:SetCapturable(true)
    ScenarioInfo.MissileLancher:SetCanTakeDamage(false)
    ScenarioInfo.MissileLancher:SetCanBeKilled(false)
	ScenarioInfo.MissileLancher:SetDoNotTarget(true)
	 
	 Cinematics.EnterNISMode()
	WaitSeconds(1)
	
	local VisMarker3_1 = ScenarioFramework.CreateVisibleAreaLocation(50, 'M3_NIS_Vismarker_1', 0, ArmyBrains[Player1])
	local VisMarker3_3 = ScenarioFramework.CreateVisibleAreaLocation(80, 'M3_NIS_Vismarker_2', 0, ArmyBrains[Player1])
	local VisMarker3_2 = ScenarioFramework.CreateVisibleAreaLocation(50, 'M3_NIS_Vismarker_3', 0, ArmyBrains[Player1])
	local VisMarker3_4 = ScenarioFramework.CreateVisibleAreaLocation(60, 'M3_NIS_Vismarker_4', 0, ArmyBrains[Player1])
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M3_Intro_Cam_1'), 2)
	ScenarioFramework.Dialogue(OpStrings.M3_Intro_Dialogue, nil, true)
	WaitSeconds(3)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M3_Intro_Cam_2'), 2)
	WaitSeconds(4)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M3_Intro_Cam_3'), 2)
	WaitSeconds(2)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M3_Intro_Cam_4'), 2)
	ScenarioFramework.Dialogue(OpStrings.M3_Intro_Dialogue2, nil, true)
	WaitSeconds(4)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M3_Intro_Cam_5'), 2)
	WaitSeconds(3)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M3_Intro_Cam_6'), 2)
	WaitSeconds(2)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M3_Intro_Cam_7'), 2)
    WaitSeconds(2)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M2_Cam_Final'), 5)
	VisMarker3_1:Destroy()
	VisMarker3_2:Destroy()
	VisMarker3_3:Destroy()
	VisMarker3_4:Destroy()
	WaitSeconds(2)
	Cinematics.ExitNISMode()
	-- End Cutscene
	
	ForkThread(UEFNISattacks)
	ForkThread(PrimaryObjective)
	ForkThread(M3UnlockT2Land)
    
	buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 1.5

       for _, u in GetArmyBrain(UEF):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
	
end

function SecondaryObjective()

    ScenarioInfo.M3S1 = Objectives.Capture(
        'secondary',
        'incomplete',
        'Capture UEF missile Silo',
        'The Missile launcher can be used to clear out those T3 anti-air defences.',
        {
		    MarkUnits = true,
            Units = {ScenarioInfo.MissileLancher}
        }
    )
	ScenarioInfo.M3S1:AddResultCallback(
        function(result)
			if (result) then
        ScenarioFramework.Dialogue(OpStrings.M3_Missile_Captured, nil, true)
			end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M3S1)

    ScenarioInfo.M3S2 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy UEF Artillery Positions',                 -- title
        'Destroy the UEF Artillery located on the hill to assist the Cybrans assault.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'M3_ArtySObj',
                    Category = categories.ueb4202 + categories.ueb2301 + categories.ueb2303,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
            },
        }
	)
    ScenarioInfo.M3S2:AddResultCallback(
        function(result)
            if (result) then
			ScenarioFramework.Dialogue(OpStrings.M3_Arty_Destroyed, nil, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3S2)	
 
end

function PrimaryObjective()

    ScenarioInfo.M3P1 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        'Kill The UEF Commander',
        'Kill the UEF Commander to secure this area.',
        {
		    MarkUnits = true,
            Units = {ScenarioInfo.UEFCommander}
        }
    )
	ScenarioInfo.M3P1:AddResultCallback(
        function(result)
			if (result) then
        ForkThread(UEFCommanderKilled)
			end
        end
    )
	table.insert(AssignedObjectives, ScenarioInfo.M3P1) 

    ForkThread(SecondaryObjective)
	
end

function UEFNISattacks()
   
   --Spawn starting attacks and send at player base, to rough them up a bit
   local Aunits = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_UEF_Airattack1', 'GrowthFormation')

	for k, v in Aunits:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_UEF_Intattack2')))
    end
	
   Aunits = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_UEF_Airattack2', 'GrowthFormation')

	for k, v in Aunits:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_UEF_Intattack2')))
    end
    
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_UEF_Navalattack', 'AttackFormation')
		ScenarioFramework.PlatoonPatrolChain(units, 'M3_UEF_Intattack1')	
   
end

function M3UnlockT2Land()
    
	WaitSeconds(60)
	ScenarioFramework.Dialogue(OpStrings.M3_TechIntel, nil, true)
	
	ScenarioFramework.PlayUnlockDialogue()
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0202)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0203)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0204)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0205)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.znb9501)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0201)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2201)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2202)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2207)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb3201)
	ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb3202)

end

function UEFCommanderKilled()

    ScenarioFramework.Dialogue(OpStrings.M3_UEFDeath, nil, true)
    ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.UEFCommander, 3)
    M3UEFMainBaseAI:DisableBase()
	WaitSeconds(6)
	ForkThread(EndNIS)
	
end

function EndNIS()

     Cinematics.EnterNISMode()
	WaitSeconds(1)
	ScenarioInfo.M2P3:ManualResult(true)
	ScenarioFramework.Dialogue(OpStrings.M3_Outro_Dialogue, nil, true)
	WaitSeconds(4)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('M2_Cam_01'), 2)
	WaitSeconds(10)
	Cinematics.ExitNISMode()
	
	PlayerWin()
	-- End Cutscene
    
end

-- Utility Functions
function PlayerDeath(deadCommander)
	ScenarioFramework.PlayerDeath(deadCommander, nil, AssignedObjectives)
end

function DestroyUnit(unit)
	unit:Destroy()
end

function CybranCommanderDeath()
	ScenarioFramework.Dialogue(OpStrings.M2_Cybran_Defeated, nil, true)

	ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.CybranCommander)

	for k, v in AssignedObjectives do
        if(v and v.Active) then
            v:ManualResult(false)
        end
    end
end

function PlayerWin()
     if(not ScenarioInfo.OpEnded) then
        ScenarioInfo.OpComplete = true
        KillGame()
    end
end

function KillGame()
    UnlockInput()
    ScenarioFramework.EndOperation(ScenarioInfo.OpComplete, ScenarioInfo.OpComplete, true)
end

-- Taunts
function UEFTaunts()
    UEFTM:AddUnitsKilledTaunt('TAUNT1', ArmyBrains[Player1], categories.MOBILE, 60)
    UEFTM:AddUnitsKilledTaunt('TAUNT2', ArmyBrains[Player1], categories.ALLUNITS, 95)
    UEFTM:AddDamageTaunt('TAUNT3', ScenarioInfo.PlayerACU[1], .50)
    UEFTM:AddUnitsKilledTaunt('TAUNT4', ArmyBrains[Player1], categories.MOBILE, 120)
    UEFTM:AddUnitsKilledTaunt('TAUNT5', ArmyBrains[Player1], categories.STRUCTURE, 8)
    UEFTM:AddUnitsKilledTaunt('TAUNT6', ArmyBrains[Player1], categories.STRUCTURE, 16)  
    UEFTM:AddUnitsKilledTaunt('TAUNT4', ArmyBrains[Player1], categories.MOBILE, 180)
    UEFTM:AddUnitsKilledTaunt('TAUNT1', ArmyBrains[Player1], categories.MOBILE, 200)
    UEFTM:AddUnitsKilledTaunt('TAUNT5', ArmyBrains[Player1], categories.STRUCTURE, 26)	
end