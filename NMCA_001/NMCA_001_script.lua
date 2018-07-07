--****************************************************************************
--**
--**  File     :  /maps/NMCA_001/NMCA_001_script.lua
--**  Author(s):  JJs_AI, Tokyto_, speed2, Exotic_Retard, zesty_lime, biass, and Wise Old Dog
--**
--**  Summary  :  Ths script for the first mission of the Nomads campaign.
--**
--****************************************************************************

local Behaviors = import('/lua/ai/opai/OpBehaviors.lua')
local Objectives = import('/lua/SimObjectives.lua')
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Cinematics = import('/lua/cinematics.lua')
local OpStrings = import('/maps/NMCA_001/NMCA_001_strings.lua')
local TauntManager = import('/lua/TauntManager.lua')
local PingGroups = import('/lua/ScenarioFramework.lua').PingGroups
local Utilities = import('/lua/utilities.lua')
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

----------
-- AI
----------
local M1OutpostAI = import('/maps/NMCA_001/NMCA_001_M1_AI.lua')
local M2FirebaseAI = import('/maps/NMCA_001/NMCA_001_M2_AI.lua')
local M3BaseAI = import('/maps/NMCA_001/NMCA_001_M3_AI.lua')
local M3FirebaseAI_1 = import('/maps/NMCA_001/NMCA_001_M3_Firebase_1_AI.lua')
local M3FirebaseAI_2 = import('/maps/NMCA_001/NMCA_001_M3_Firebase_2_AI.lua')
local M3PBaseAI = import('/maps/NMCA_001/NMCA_001_M3_Firebase_3_AI.lua')

ScenarioInfo.Player1 = 1
ScenarioInfo.UEF = 2
ScenarioInfo.Civilian = 3
ScenarioInfo.Nomads = 4
ScenarioInfo.Player2 = 5
ScenarioInfo.Player3 = 6
ScenarioInfo.Player4 = 7

local Player1 = ScenarioInfo.Player1
local UEF = ScenarioInfo.UEF
local Civilian = ScenarioInfo.Civilian
local Nomads = ScenarioInfo.Nomads
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3
local Player4 = ScenarioInfo.Player4

local Difficulty = ScenarioInfo.Options.Difficulty
local TimedExapansion = ScenarioInfo.Options.Expansion

local UEFM1Timer = {300, 240, 180}
local TMLTimer = {450, 375, 300}
local M1TransportTimer = {450, 400, 350}
local BombAbilCoolDown = {120, 180, 240}

local M3BuildProtectionTimer = {300, 225, 150}
local M3UEFCommanderAttackTimer = {1000, 850, 600}

local Spotted = false
local PlayerLost = false
local FactoryCaptured = false
local M1Finished = false
local M2Finished = false

local AssignedObjectives = {}

-- Timed Expansions
local M1ExpansionTime = {23 * 60, 20 * 60, 17 * 60}
local M2ExpansionTime = {34 * 60, 31 * 60, 28 * 60}

----------------
-- Taunt Managers
----------------
local M1UEFTM = TauntManager.CreateTauntManager('M1UEFTM', '/maps/NMCA_001/NMCA_001_strings.lua')

function OnPopulate()
    ScenarioUtils.InitializeScenarioArmies()
    ScenarioFramework.SetPlayableArea('M1', false)

    SetArmyColor('UEF', 41, 40, 140)
    SetArmyColor('Civilian', 71, 114, 148)
    SetArmyColor('Nomads', 225, 135, 62)

    ----------
    -- Coop Colours
    ----------
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

    ----------
    -- Unit Cap
    ----------
    ScenarioFramework.SetSharedUnitCap(1000)
    SetArmyUnitCap(UEF, 450)
end
  
function OnStart(self)
    ----------
    -- Restrictions
    ----------
    ScenarioFramework.AddRestrictionForAllHumans(categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL)
    ScenarioFramework.AddRestrictionForAllHumans(categories.ina1003) # Attack Bomber
    ScenarioFramework.AddRestrictionForAllHumans(categories.uel0105) # UEF Engineer
    ScenarioFramework.AddRestrictionForAllHumans(categories.ina1005) # Transport Drone
    ScenarioFramework.AddRestrictionForAllHumans(categories.inu1004) # Medium Tank
    ScenarioFramework.AddRestrictionForAllHumans(categories.inu1008) # Tank Destroyer
    ScenarioFramework.AddRestrictionForAllHumans(categories.NAVAL) # Navy

    ----------
    -- Spawn Things
    ----------
    ScenarioUtils.CreateArmyUnit('Player1', 'EStorage')
    ScenarioUtils.CreateArmyUnit('Player1', 'MStorage')
    ScenarioInfo.Ship = ScenarioUtils.CreateArmyUnit('Nomads', 'Ship')
    ScenarioFramework.CreateUnitDeathTrigger(PlayerLose, ScenarioInfo.Ship)

    ScenarioUtils.CreateArmyGroup('Civilian', 'CivilianGroup')
    ScenarioInfo.UEFTech = ScenarioUtils.CreateArmyUnit('UEF', 'TechCentre')

    ScenarioInfo.UEFTech:SetCanTakeDamage(false)
    ScenarioInfo.UEFTech:SetCanBeKilled(false)
    ScenarioInfo.UEFTech:SetDoNotTarget(true)
    ScenarioInfo.UEFTech:SetReclaimable(false)

    ScenarioUtils.CreateArmyGroup('UEF', 'M1Walls')

    ScenarioInfo.Ship:SetCustomName('Command Ship')
    ScenarioInfo.Ship:SetCanBeKilled(false)
    ScenarioInfo.Ship:SetReclaimable(false)
    ScenarioInfo.UEFTech:SetCustomName('Tech Centre')

    ScenarioInfo.Engineer1 = ScenarioUtils.CreateArmyUnit('Player1', 'Engineer_1')
    ScenarioFramework.EngineerBuildUnits('Player1', 'Engineer_2', 'Cutscene_Pgen_1')
    ScenarioFramework.EngineerBuildUnits('Player1', 'Engineer_3', 'Cutscene_Mex_1', 'Cutscene_Factory_1')

    IssueMove({ScenarioInfo.Engineer1}, ScenarioUtils.MarkerToPosition('M1_Nomads_Engineer_Move_Marker'))

    local platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Player1', 'Patrol_Units', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'Init_P1_Units_Patrol_Chain')

    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'AirPatrol_' .. Difficulty, 'NoFormation')
    for _, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M1_AirPatrol_Chain')))
    end

    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'LabPatrol_1', 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('LabPatrol_1_Chain')))
    end

    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'LabPatrol_2', 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('LabPatrol_2_Chain')))
    end

    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'LabPatrol_3', 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('LabPatrol_3_Chain')))
    end

    ----------
    -- Run AI
    ----------
    M1OutpostAI.UEFOutpostAI()

    ----------
    -- Cinematics
    ----------
    ForkThread(M1NIS)
end

function PlayerWin()
    -- Mark objectives as failed
    for k, v in AssignedObjectives do
        if(v and v.Active) then
            v:ManualResult(true)
        end
    end

    KillGame()
end

function PlayerLose()
    ----------
    -- Player Lost Game
    ----------
    PlayerLost = true
    
    -- Mark objectives as failed
    for k, v in AssignedObjectives do
        if(v and v.Active) then
            v:ManualResult(false)
        end
    end

    ScenarioInfo.OpComplete = false

    ScenarioFramework.EndOperationSafety()
    ScenarioFramework.FlushDialogueQueue()

    ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.Ship)

    M1OutpostAI.DisableBase()
    M3BaseAI.DisableBase()

    ForkThread(function()
        WaitSeconds(5)
        KillGame()
    end)
end

function KillGame()
    UnlockInput()
    local allPrimaryCompleted = true
    local allSecondaryCompleted = true
    ScenarioFramework.EndOperation(ScenarioInfo.OpComplete, allPrimaryCompleted, allSecondaryCompleted)
end

function M1NIS()
    ArmyBrains[Player1]:GiveResource('ENERGY', 5000)
    ArmyBrains[Player1]:GiveResource('MASS', 650)
    ScenarioFramework.CreateUnitDamagedTrigger(PlayerLose, ScenarioInfo.Ship, .75)

    WaitSeconds(1)

    Cinematics.EnterNISMode()
    ScenarioFramework.Dialogue(OpStrings.IntroNIS_Dialogue, M1_Objectives, true)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01a'), 0)
    
    WaitSeconds(1)

    Cinematics.CameraTrackEntity(ScenarioInfo.Engineer1, 40, 3)
    WaitSeconds(5)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01_Engineer_Pan_01'), 1)
    WaitSeconds(7)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01_Engineer_Pan_02'), 1)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01b'), 2)
    WaitSeconds(3)
    Cinematics.ExitNISMode()

    if (table.getn(ScenarioInfo.HumanPlayers) == 2) then
        ScenarioUtils.CreateArmyGroup('Player2', 'Engineers')
        ScenarioUtils.CreateArmyUnit('Player2', 'EStorage')
        ScenarioUtils.CreateArmyUnit('Player2', 'MStorage')

        ArmyBrains[Player2]:GiveResource('ENERGY', 5000)
        ArmyBrains[Player2]:GiveResource('MASS', 650)
    elseif(table.getn(ScenarioInfo.HumanPlayers) == 3) then
        ScenarioUtils.CreateArmyGroup('Player2', 'Engineers')
        ScenarioUtils.CreateArmyUnit('Player2', 'EStorage')
        ScenarioUtils.CreateArmyUnit('Player2', 'MStorage')
        ScenarioUtils.CreateArmyGroup('Player3', 'Engineers')
        ScenarioUtils.CreateArmyUnit('Player3', 'EStorage')
        ScenarioUtils.CreateArmyUnit('Player3', 'MStorage')

        ArmyBrains[Player2]:GiveResource('ENERGY', 5000)
        ArmyBrains[Player2]:GiveResource('MASS', 650)
        ArmyBrains[Player3]:GiveResource('ENERGY', 5000)
        ArmyBrains[Player3]:GiveResource('MASS', 650)
    elseif(table.getn(ScenarioInfo.HumanPlayers) == 4) then
        ScenarioUtils.CreateArmyGroup('Player2', 'Engineers')
        ScenarioUtils.CreateArmyUnit('Player2', 'EStorage')
        ScenarioUtils.CreateArmyUnit('Player2', 'MStorage')
        ScenarioUtils.CreateArmyGroup('Player3', 'Engineers')
        ScenarioUtils.CreateArmyUnit('Player3', 'EStorage')
        ScenarioUtils.CreateArmyUnit('Player3', 'MStorage')
        ScenarioUtils.CreateArmyGroup('Player4', 'Engineers')
        ScenarioUtils.CreateArmyUnit('Player4', 'EStorage')
        ScenarioUtils.CreateArmyUnit('Player4', 'MStorage')

        ArmyBrains[Player2]:GiveResource('ENERGY', 5000)
        ArmyBrains[Player2]:GiveResource('MASS', 650)
        ArmyBrains[Player3]:GiveResource('ENERGY', 5000)
        ArmyBrains[Player3]:GiveResource('MASS', 650)
        ArmyBrains[Player4]:GiveResource('ENERGY', 5000)
        ArmyBrains[Player4]:GiveResource('MASS', 650)
    end

    -- Remove Ships
    for _, player in ScenarioInfo.HumanPlayers do
        local ship = GetEntityById('INO0001')
        ship:Destroy()
    end
end

function M1_Objectives()
    ScenarioFramework.CreateTimerTrigger(M1StartUEFScouting, UEFM1Timer[Difficulty])

    local function MissionNameAnnouncement()
        ScenarioFramework.SimAnnouncement(ScenarioInfo.name, "mission by The 'Mad Men")
    end

    ScenarioFramework.CreateTimerTrigger(MissionNameAnnouncement, 7)
    ScenarioInfo.TacLauncher = ScenarioInfo.UnitNames[UEF]['TacMissile']

    ScenarioInfo.M1P1 = Objectives.Protect(
        'primary',
        'incomplete',
        OpStrings.M1P1Text,
        OpStrings.M1P1Desc,
        {
            Units = {ScenarioInfo.Ship},
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P1)

    ScenarioInfo.M1P2 = Objectives.Locate(
        'primary',
        'incomplete',
        OpStrings.M1P2Text,
        OpStrings.M1P2Desc,
        {
            Units = {ScenarioInfo.TacLauncher},
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P2)

    ScenarioFramework.CreateArmyIntelTrigger(ForkAttackThread, ArmyBrains[Player1], 'LOSNow', false, true,  categories.UEF, true, ArmyBrains[UEF] )
end

function M1StartUEFScouting()
    if ScenarioInfo.M1P1.Active then
        ----------
        -- Scouting Starts
        ----------
        local Scouts = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'Scouts','NoFormation')

        for k, v in Scouts:GetPlatoonUnits() do
            ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M1_UEF_Scout_Chain')))
        end
    end
end

function ForkAttackThread()
    if not Spotted then
        ScenarioFramework.Dialogue(OpStrings.UEF_Notice, M1StartUEFAttacks, true)
    end
end

function M1StartUEFAttacks()
    Spotted = true

    IssueTactical({ScenarioInfo.TacLauncher}, ScenarioUtils.MarkerToPosition('M1_TacMissile_Target'))

    WaitSeconds(15)

    Cinematics.EnterNISMode()

    local VisMarker1_1 = ScenarioFramework.CreateVisibleAreaLocation(10, 'M1_Vis_1_1', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01c'), 0)

    ScenarioFramework.Dialogue(OpStrings.M1_Scream_Incoming, nil, true)

    WaitSeconds(5)

    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_02a'), 2)

    WaitSeconds(5)

    VisMarker1_1:Destroy()
    Cinematics.ExitNISMode()

    WaitSeconds(5)
    ScenarioFramework.Dialogue(OpStrings.M1_Update_Commander, M2_Objectives, true)

    ----------
    -- Start Attacks
    ----------
    M1OutpostAI.M1LandAttacks()
    M1OutpostAI.M1AirAttacks()

    ----------
    -- Set Timer for Missile Launches
    ----------
    ScenarioFramework.CreateUnitDeathTrigger(TacDead, ScenarioInfo.TacLauncher)
    ScenarioFramework.CreateTimerTrigger(LaunchTac, TMLTimer[Difficulty])
    ScenarioFramework.CreateTimerTrigger(M1Reinforcements, M1TransportTimer[Difficulty])

    UEFM1Taunts()

    WaitSeconds(15)
    ScenarioFramework.Dialogue(OpStrings.M1UnlockAirTech, M1UnlockAirTechForAllHumans, true)
end

function M1UnlockAirTechForAllHumans()
    ScenarioFramework.PlayUnlockDialogue()
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.ina1003)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.ina1005)
end

function M1Reinforcements()
    if not PlayerLost and ScenarioInfo.M2P1.Active then
        ----------
        -- Transports
        ----------
        local allUnits = {}

        for i = 1, 2 * table.getn(ScenarioInfo.HumanPlayers) do
            local transport = ScenarioUtils.CreateArmyUnit('UEF', 'M2_Transport')
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_Reinforcements_Attack', 'AttackFormation')

            for _, v in units:GetPlatoonUnits() do
                table.insert(allUnits, v)
            end

            ScenarioFramework.AttachUnitsToTransports(units:GetPlatoonUnits(), {transport})
            WaitSeconds(0.5)
            IssueTransportUnload({transport}, ScenarioUtils.MarkerToPosition('M2_Transport_Drop_' .. i))
            IssueMove({transport}, ScenarioUtils.MarkerToPosition('UEF_Main_Base'))
            ScenarioFramework.PlatoonPatrolChain(units, 'M2_Transport_Attack_Route')
        end

        for i = 1, 2 * table.getn(ScenarioInfo.HumanPlayers) do
            local transport = ScenarioUtils.CreateArmyUnit('UEF', 'M2_Transport')
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M2_Reinforcements','AttackFormation')

            for _, v in units:GetPlatoonUnits() do
                table.insert(allUnits, v)
            end

            ScenarioFramework.AttachUnitsToTransports(units:GetPlatoonUnits(), {transport})
            WaitSeconds(0.5)
            IssueTransportUnload({transport}, ScenarioUtils.MarkerToPosition('M2_Transport_Base_Drop_' .. i))
            IssueMove({transport}, ScenarioUtils.MarkerToPosition('UEF_Main_Base'))
            ScenarioFramework.PlatoonPatrolChain(units, 'M2_Outpost_Patrol')
        end
    end
end

function M2_Objectives()
    ----------
    -- Timer Triggers (Reminders)
    ----------
    ScenarioFramework.CreateTimerTrigger(TacticalLauncherReminder, 600)
    ScenarioFramework.CreateTimerTrigger(OutpostReminder, 600)

    ----------
    -- Objectives
    ----------
    ScenarioInfo.M2P1 = Objectives.CategoriesInArea(
        'primary',                      -- type
        'incomplete',                   -- complete
        OpStrings.M2P1Text,  -- title
        OpStrings.M2P1Desc,  -- description
        'kill',
        {
            MarkUnits = true,
            Requirements = {
                { Area = 'M1Outpost', Category = categories.FACTORY + categories.ENGINEER, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
            },
        }
    )
    ScenarioInfo.M2P1:AddResultCallback(
        function(result)
            if(result) then
                M1OutpostAI.DisableBase()
                ScenarioFramework.Dialogue(OpStrings.UEFOutpost_Dead, nil, true)
                Cinematics.EnterNISMode()
                Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_02b'), 1)
                WaitSeconds(4)
                Cinematics.ExitNISMode()
                M2Capture()
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P1)

    ----------
    -- Destroy Tac Objective
    ----------
    ScenarioInfo.M2P2 = Objectives.KillOrCapture(
        'primary',                      -- type
        'incomplete',                   -- complete
        OpStrings.M2P2Text,  -- title
        OpStrings.M2P2Desc,  -- description
        {                               -- target
            Units = {ScenarioInfo.TacLauncher}
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P2)

    -- Expand to next part of the mission.
    if TimedExapansion then
        ScenarioFramework.CreateTimerTrigger(M2Capture, M1ExpansionTime[Difficulty])
    end
end

function M2Capture()
    if not M1Finished then
        M1Finished = true

        ScenarioUtils.CreateArmyGroup('Civilian', 'M2')
        ScenarioFramework.SetPlayableArea('M2', true)
        ScenarioInfo.UEFFactory = ScenarioInfo.UnitNames[Civilian]['Factory']

        ----------
        -- Spawn Base
        ----------
        ScenarioUtils.CreateArmyGroup('UEF', 'M3Walls')
        ScenarioUtils.CreateArmyGroup('UEF', 'M3Engineers')

        ----------
        -- Run AI
        ----------
        M2FirebaseAI.UEFFireBaseAI()
        ScenarioUtils.CreateArmyGroup('UEF', 'M2Walls')

        ScenarioUtils.CreateArmyGroup('UEF', 'M3_MainBase_Buildings_D'..Difficulty)

        M3BaseAI.UEFBaseAI()
        ScenarioInfo.EnemyCommander = ScenarioUtils.CreateArmyUnit('UEF', 'Commander')
        ScenarioInfo.EnemyCommander:SetCustomName("CDR Parker")
        ScenarioInfo.EnemyCommander:SetAutoOvercharge(true)

        M3FirebaseAI_1:UEFM3FireBase1()
        M3FirebaseAI_2:UEFM3FireBase2()

        if Difficulty == 1 then
            ScenarioInfo.EnemyCommander:CreateEnhancement('AdvancedEngineering')
            ScenarioInfo.EnemyCommander:CreateEnhancement('LeftPod')
            ScenarioInfo.EnemyCommander:CreateEnhancement('RightPod')
        elseif Difficulty == 2 then
            ScenarioInfo.EnemyCommander:CreateEnhancement('AdvancedEngineering')
            ScenarioInfo.EnemyCommander:CreateEnhancement('Shield')
            ScenarioInfo.EnemyCommander:CreateEnhancement('ResourceAllocation')   
        elseif Difficulty == 3 then
            ScenarioInfo.EnemyCommander:CreateEnhancement('AdvancedEngineering')
            ScenarioInfo.EnemyCommander:CreateEnhancement('Shield')
            ScenarioInfo.EnemyCommander:CreateEnhancement('HeavyAntiMatterCannon')
        end

        ----------
        -- Spawn PBase
        ----------
        ScenarioUtils.CreateArmyGroup('UEF', 'M3PWalls')
        ScenarioUtils.CreateArmyGroup('UEF', 'M3Shields')
        M3PBaseAI:UEFM3FireBase3()

        ----------
        -- Spawn Patrols
        ----------
        local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_AirPatrol_' .. Difficulty, 'NoFormation')
        for k, v in units:GetPlatoonUnits() do
            ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_AirPatrol_Chain')))
        end

        local AttackUnits = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_Init_Attack_' .. Difficulty, 'GrowthFormation')
        ScenarioFramework.PlatoonPatrolChain(AttackUnits, 'M3_LandAttack_Chain')

        local PBasePatrol = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3PBasePatrol', 'GrowthFormation')
        for k, v in PBasePatrol:GetPlatoonUnits() do
            ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_PBase_Patrol_Chain')))
        end

        local BasePatrol = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3BasePatrol_' .. Difficulty, 'GrowthFormation')
        for k, v in BasePatrol:GetPlatoonUnits() do
            ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M3_Base_Patrol_Chain')))
        end

        ----------
        -- Dialogue
        ----------
        ScenarioFramework.Dialogue(OpStrings.M2_Update_Commander, M2ObjectviesExtended, true)
    end
end

function M2ObjectviesExtended()
    ----------
    -- Timer Triggers (Reminders)
    ----------
    ScenarioFramework.CreateTimerTrigger(TechReminder, 450)

    ----------
    -- Objectives
    ----------
    ScenarioInfo.M2P3 = Objectives.Capture(
        'primary',                      -- type
        'incomplete',                   -- complete
        OpStrings.M2P3Text,  -- title
        OpStrings.M2P3Desc,  -- description
        {
            FlashVisible = true,
            MarkUnits = true,
            Units = {ScenarioInfo.UEFTech},
        }
    )
    ScenarioInfo.M2P3:AddResultCallback(
        function(result)
            if(result) then
                ScenarioFramework.Dialogue(OpStrings.M2TechCaptured, M3, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P3)

    ----------
    -- Capture UEF Factory
    ----------
    ScenarioInfo.M2S1 = Objectives.Capture(
        'secondary',                      -- type
        'incomplete',                   -- complete
        OpStrings.M2S1Text,  -- title
        OpStrings.M2S1Desc,  -- description
        {                            -- target
            Units = {ScenarioInfo.UEFFactory},
        }
    )
    ScenarioInfo.M2S1:AddResultCallback(
        function(result, units)
            ScenarioFramework.PlayUnlockDialogue()
            ScenarioFramework.RemoveRestrictionForAllHumans(categories.inu1004)

            ScenarioInfo.NFactory = units[1]
            FactoryCaptured = true
            if not ScenarioInfo.NFactory:IsDead() then
                ScenarioFramework.Dialogue(OpStrings.UEFTauntFactory, nil, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2S1)

    -- Expand to next part of the mission.
    if TimedExapansion then
        ScenarioFramework.CreateTimerTrigger(M3, M2ExpansionTime[Difficulty])
    end
end

function M3()
    if not M2Finished then
        M2Finished = true
        ScenarioFramework.SetPlayableArea('M3', true)

        ScenarioFramework.Dialogue(OpStrings.M3_Update_Commander, Move_Camera_To_Power_Base, true)

        if FactoryCaptured then
            ScenarioFramework.CreateTimerTrigger(M3SetFactoryObjective, 120)
        end

        ----------
        -- Timer Triggers (Reminders)
        ----------
        ScenarioFramework.CreateTimerTrigger(EnemyReminder, 250)
        ScenarioFramework.CreateTimerTrigger(ACUWalkToShip, M3UEFCommanderAttackTimer[Difficulty])
        ScenarioFramework.CreateTimerTrigger(BuildACUProtection, M3BuildProtectionTimer[Difficulty])

        ----------
        -- Cinematics
        ----------
        ScenarioInfo.VisMarker3_1 = ScenarioFramework.CreateVisibleAreaLocation(80, 'M3_UEF_Base_Marker', 0, ArmyBrains[Player1])
        ScenarioInfo.VisMarker3_2 = ScenarioFramework.CreateVisibleAreaLocation(40, 'M3PBase', 0, ArmyBrains[Player1])
        ScenarioInfo.vizmarker = nil

        Cinematics.EnterNISMode()

        Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_03a'), 1)

        WaitSeconds(2)

        Cinematics.CameraTrackEntity(ScenarioInfo.EnemyCommander, 40, 2)
    end
end

function Move_Camera_To_Power_Base()
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_03b'), 1)

    local platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'M3_NISAttackers', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_LandAttack_Chain')

    ScenarioFramework.Dialogue(OpStrings.M3_Update_Commander_Power, Move_Camera_To_Enemy_Unit, true)
end

function Move_Camera_To_Enemy_Unit()
    ScenarioFramework.Dialogue(OpStrings.M3_Update_Commander_Enemy, End_M3_Cutscene, true)

    local unit = ScenarioInfo.UnitNames[UEF]['NIS_Follow_Unit']
    local pos = unit:GetPosition()
    local spec = {
        X = pos[1],
        Z = pos[2],
        Radius = 15,
        LifeTime = -1,
        Omni = false,
        Vision = true,
        Radar = false,
        Army = 1,
    }
    ScenarioInfo.vizmarker = VizMarker(spec)
    ScenarioInfo.vizmarker:AttachBoneTo(-1, unit, -1)

    Cinematics.CameraTrackEntity(unit, 25, 0)
end

function End_M3_Cutscene()
    ScenarioInfo.vizmarker:Destroy()

    ScenarioInfo.VisMarker3_1:Destroy()
    ScenarioInfo.VisMarker3_2:Destroy()
    
    -- Drop unit tracking and move back to the original position of the player.
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('Cutscene_01b'), 2)

    Cinematics:ExitNISMode()

    ----------
    -- Unlock T2 Air Factory
    ----------
    ScenarioFramework.PlayUnlockDialogue()
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.inb0202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.inb0212)

    ----------
    -- Objectives
    ----------
    ScenarioInfo.M3P1 = Objectives.KillOrCapture(
        'primary',                      -- type
        'incomplete',                   -- complete
        OpStrings.M3P1Text,  -- title
        OpStrings.M3P1Desc, -- description
        {                               -- target
            Units = {ScenarioInfo.EnemyCommander}
        }
    )
    ScenarioInfo.M3P1:AddResultCallback(
        function(result)
            if(result) then
                ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.EnemyCommander)
                M3BaseAI.DisableBase()
                ScenarioFramework.EndOperationSafety()
                ScenarioFramework.Dialogue(OpStrings.EnemyDead, PlayerWin, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3P1) 

    ----------
    -- Destroy Power Base
    ----------
    ScenarioInfo.M3S1 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        OpStrings.M3S1Text,  -- title
        OpStrings.M3S1Desc,  -- description
        'kill',
        {
            MarkUnits = true,
            Requirements = {
                { Area = 'M3Power', Category = categories.ueb1201, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
                { Area = 'M3Power', Category = categories.ueb1201, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
                { Area = 'M3Power', Category = categories.ueb1201, CompareOp = '<=', Value = 0, ArmyIndex = UEF},
            },
        }
    )
    ScenarioInfo.M3S1:AddResultCallback(
        function(result)
            if(result) then
                M3BaseAI.DisableShields()
                ScenarioFramework.Dialogue(OpStrings.M3ShieldsDead, nil, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3S1)

    ----------
    -- Build T2 Air Factory
    ----------
    ScenarioInfo.M3S2 = Objectives.ArmyStatCompare(
        'secondary',                      -- type
        'incomplete',                   -- complete
        OpStrings.M3S2Text,     -- title
        OpStrings.M3S2Desc,      -- description
        'build',                        -- action
        {                               -- target
            Armies = {'HumanPlayers'},
            StatName = 'Units_Active',
            CompareOp = '>=',
            Value = 1,
            Category = categories.inb0202,
        }
    )
    ScenarioInfo.M3S2:AddResultCallback(
        function(result)
            if(result) then
                ScenarioFramework.Dialogue(OpStrings.Tech2AirFactoryBuilt, nil, true)
                ForkThread(GiveOrbitalBombardmentAbil)
            end
        end
    )  
    table.insert(AssignedObjectives, ScenarioInfo.M3S2)
end

function M3SetFactoryObjective()
    ScenarioFramework.Dialogue(OpStrings.M3_ProtectFactory, nil, true)

    ScenarioInfo.M3S3 = Objectives.Protect(
        'secondary',                      -- type
        'incomplete',                   -- complete
        OpStrings.M3S3Text,  -- title
        OpStrings.M3S3Desc,  -- description
        {
            Units = {ScenarioInfo.NFactory},
        }
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3S3)
    
    ScenarioFramework.CreateUnitDeathTrigger(FacDead, ScenarioInfo.NFactory)
end

function BuildACUProtection()
    M3BaseAI.BuildAIProtection(ScenarioInfo.EnemyCommander)
end

function ACUWalkToShip()
    ScenarioFramework.Dialogue(OpStrings.M3ParkerLeaveBase, nil, true)
    M3BaseAI.DisbandACUPlatoon()

    local platoon = ArmyBrains[UEF]:MakePlatoon('', '')
    ArmyBrains[UEF]:AssignUnitsToPlatoon(platoon, {ScenarioInfo.EnemyCommander}, 'Attack', 'GrowthFormation')

    ForkThread(M3_Issue_ACU_Direct_Orders)
end

function M3_Issue_ACU_Direct_Orders()
    IssueStop({ScenarioInfo.EnemyCommander})
    WaitSeconds(3)
    IssueAggressiveMove({ScenarioInfo.EnemyCommander}, ScenarioUtils.MarkerToPosition('M3_Parker_ACU_Move_1'))
    IssueAggressiveMove({ScenarioInfo.EnemyCommander}, ScenarioUtils.MarkerToPosition('M3_Parker_ACU_Move_2'))
end

function TacDead()
    ScenarioInfo.M2P2:ManualResult(true)
    ScenarioFramework.Dialogue(OpStrings.M1_Tac_Dead, nil, true)
end

function LaunchTac()
    if not ScenarioInfo.TacLauncher:IsDead() then
        IssueTactical({ScenarioInfo.TacLauncher}, ScenarioUtils.MarkerToPosition('M1_TacMissile_Target'))
        ScenarioFramework.CreateTimerTrigger(LaunchTac, TMLTimer[Difficulty])
    else
        return
    end
end

function FacDead()
    ScenarioInfo.M3S1:ManualResult(false)
    ScenarioFramework.Dialogue(OpStrings.M3FactoryDead, nil, true)
    ScenarioFramework.AddRestrictionForAllHumans(categories.inu1004) # Medium Tank
end

function GiveOrbitalBombardmentAbil()
    ScenarioFramework.Dialogue(OpStrings.OrbStrikeReady, nil, true)
    ScenarioInfo.M2AttackPing = PingGroups.AddPingGroup('Signal Air Strike', nil, 'attack', 'Mark a location for the bombers to attack.')
    ScenarioInfo.M2AttackPing:AddCallback(SendBombers)
end

function SendBombers(location)
    ForkThread(function()
        local Bombers = ScenarioUtils.CreateArmyGroup('Nomads', 'OrbStrikeBombers_' .. Difficulty)
        local delBomb = ScenarioUtils.MarkerToPosition('DestroyBombers')
        ScenarioInfo.M2AttackPing:Destroy()

        ----------
        -- Send Bombers
        ----------
        for _, v in Bombers do
            if(v and not v:IsDead()) then
                IssueStop({v})
                IssueClearCommands({v})
                v:SetFireState('GroundFire')
                IssueAttack({v}, location)
                IssueMove({v}, delBomb)
            end
        end

        ----------
        -- Trigger a Remove
        ----------
        for _, v in Bombers do
            WaitSeconds(10)
            ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, v, delBomb, 15)
        end

        ScenarioFramework.CreateTimerTrigger(GiveOrbitalBombardmentAbil, BombAbilCoolDown[Difficulty])
    end)
end

function DestroyUnit(unit)
    unit:Destroy()
end

----------
-- Taunts
----------
function UEFM1Taunts()
    M1UEFTM:AddUnitsKilledTaunt('TAUNT1', ArmyBrains[Player1], categories.MOBILE, 60)
    M1UEFTM:AddUnitsKilledTaunt('TAUNT2', ArmyBrains[Player1], categories.ALLUNITS, 95)
    M1UEFTM:AddDamageTaunt('TAUNT3', ScenarioInfo.Ship, .50)
    M1UEFTM:AddUnitsKilledTaunt('TAUNT4', ArmyBrains[Player1], categories.MOBILE, 120)
    M1UEFTM:AddUnitsKilledTaunt('TAUNT5', ArmyBrains[Player1], categories.STRUCTURE, 10)
    M1UEFTM:AddUnitsKilledTaunt('TAUNT6', ArmyBrains[Player1], categories.STRUCTURE, 16)   
end

----------
-- Reminders
----------
function TacticalLauncherReminder()
    if(ScenarioInfo.M2P2.Active) then
        ScenarioFramework.Dialogue(OpStrings.M2P2Reminder, nil, true)
    end
end

function OutpostReminder()
    if(ScenarioInfo.M2P1.Active) then
        ScenarioFramework.Dialogue(OpStrings.M2P1Reminder, nil, true)
    end
end

function TechReminder()
    if(ScenarioInfo.M2P3.Active) then
        ScenarioFramework.Dialogue(OpStrings.M2P3Reminder, nil, true)
    end
end

function EnemyReminder()
    if(ScenarioInfo.M3P1.Active) then
        ScenarioFramework.Dialogue(OpStrings.M3P1Reminder, nil, true)
    end
end