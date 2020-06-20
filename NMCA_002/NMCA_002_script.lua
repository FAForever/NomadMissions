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
local OpStrings = import('/maps/NMCA_002/NMCA_002_strings.lua')
local TauntManager = import('/lua/TauntManager.lua')
local PingGroups = import('/lua/ScenarioFramework.lua').PingGroups
local Utilities = import('/lua/utilities.lua')
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local AIBuildStructures = import('/lua/ai/aibuildstructures.lua')

-- AI
local CybranaiP1 = import('/maps/NMCA_002/CybranaiP1.lua')
local CybranaiP2 = import('/maps/NMCA_002/CybranaiP2.lua')
local UEFaiP1 = import('/maps/NMCA_002/UEFaiP1.lua')
local UEFaiP2 = import('/maps/NMCA_002/UEFaiP2.lua')
local UEFaiP3 = import('/maps/NMCA_002/UEFaiP3.lua')

local UEFTM = TauntManager.CreateTauntManager('UEF1TM', '/maps/NMCA_002/NMCA_002_strings.lua')

-- Global Variables
ScenarioInfo.Player1 = 1
ScenarioInfo.Cybran = 2
ScenarioInfo.CybranCivilian = 3
ScenarioInfo.UEF = 4
ScenarioInfo.Player2 = 6
ScenarioInfo.Player3 = 7
ScenarioInfo.Player4 = 8
ScenarioInfo.Nomads = 5
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

M2ReinforcementsIntro = false

local M1ExpansionTime = {40*60, 35*60, 30*60}  
local M2ExpansionTime = {35*60, 30*60, 25*60}

local M2ReinforcementCoolDown = {5*60, 6*60, 8*60} 


function OnPopulate(self)
    ScenarioUtils.InitializeScenarioArmies()
    ScenarioFramework.SetPlayableArea('M1_Zone', false)

    SetArmyColor('UEF', 41, 40, 140)
    SetArmyColor('Cybran',  128, 39, 37)
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
    
    --- decreases time factories wait to produce next platoon
    ArmyBrains[UEF]:PBMSetCheckInterval(10)
    ArmyBrains[Cybran]:PBMSetCheckInterval(10)
    
    ScenarioFramework.SetSharedUnitCap(1100)
    SetArmyUnitCap(UEF, 4000)
    SetArmyUnitCap(Cybran, 4000)
    SetArmyUnitCap(CybranCivilian, 300)
end

function OnStart(self)
    ScenarioFramework.AddRestrictionForAllHumans(categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL)
    ScenarioFramework.AddRestrictionForAllHumans(categories.UEF) -- UEF Faction
    ScenarioFramework.AddRestrictionForAllHumans(categories.CYBRAN) -- Cybran Faction


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
    

    ScenarioUtils.CreateArmyGroup('UEF', 'P1UWalls')
    ScenarioUtils.CreateArmyGroup('Cybran', 'P1CWalls')
    ScenarioUtils.CreateArmyGroup('Cybran', 'P1CBaseOuterD_D'.. Difficulty)
    ScenarioUtils.CreateArmyGroup('Cybran', 'P1Wreaks', true)
    
    
    CybranaiP1:P1CybranBase1AI()
    CybranaiP1:P1CybranBase2AI()
    
    UEFaiP1:P1UEFBase1AI()
    UEFaiP1:P1UEFBase2AI()
    
    ForkThread(M1IntroScene)
end

-- M1 Functions

function M1IntroScene()
    
    ScenarioInfo.MissionNumber = 1
    
    Cinematics.EnterNISMode()
    WaitSeconds(1)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam1'), 2)

    ForkThread(function()
        for i = 1, table.getsize(ScenarioInfo.HumanPlayers) do
            ScenarioInfo.PlayerACU[i] = ScenarioFramework.SpawnCommander('Player'..i, 'Commander', 'Warp', true, true, PlayerDeath)
            WaitSeconds(1)
        end
    end)

    WaitSeconds(3)

    ScenarioFramework.Dialogue(OpStrings.M2_Intro_CDR_Dropped_Dialogue, nil, true)
    WaitSeconds(6)

    local UEF_NIS_Units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P1UIntattack1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(UEF_NIS_Units, 'P1NISpatrol1' )
    
    ScenarioFramework.CreatePlatoonDeathTrigger(M1_Play_Berry_Dialogue, UEF_NIS_Units)

    local VisMarker1_1 = ScenarioFramework.CreateVisibleAreaLocation(30, 'P1Vision1', 0, ArmyBrains[Player1])
    
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P1CIntattack1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P1NISpatrol2')
 
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam2'), 2)
    WaitSeconds(1)
   
    ScenarioFramework.Dialogue(OpStrings.M2_Intro_Fight_Dialogue, nil, true)
    local VisMarker1_2 = ScenarioFramework.CreateVisibleAreaLocation(40, 'P1Vision2', 0, ArmyBrains[Player1])

    WaitSeconds(9)
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P1CIntattack2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P1NISpatrol2' )
    
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam3'), 2)
    WaitSeconds(3)
    ScenarioFramework.Dialogue(OpStrings.M2_Intro_CDR_Dropped_Dialogue_2, nil, true)
    local VisMarker1_3 = ScenarioFramework.CreateVisibleAreaLocation(60, 'P1Vision3', 0, ArmyBrains[Player1])
    local VisMarker1_4 = ScenarioFramework.CreateVisibleAreaLocation(60, 'P1Vision4', 0, ArmyBrains[Player1])
    local VisMarker1_5 = ScenarioFramework.CreateVisibleAreaLocation(60, 'P1Vision5', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam1'), 1)
    

    VisMarker1_1:Destroy()
    VisMarker1_2:Destroy()
    VisMarker1_3:Destroy()
    VisMarker1_4:Destroy()
    VisMarker1_5:Destroy()
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P1ULandPatrol1_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P1UB2landPatrol1' )
    WaitSeconds(1)

    Cinematics.ExitNISMode()

    local function MissionNameAnnouncement()
        ScenarioFramework.SimAnnouncement(ScenarioInfo.name, "mission by The 'Mad Men")
    end

    -- Establish Secondary Obj triggers
    ScenarioFramework.CreateTimerTrigger(MissionNameAnnouncement, 7)

    -- Trigger M1 Objectives
    ForkThread(M1Objectives)
    ForkThread(
    function()
    WaitSeconds(3*60)
    M1SpawnCybranattacks()
    end)
    
    --Set Cybran and UEF Eco buff
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(Cybran):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(UEF):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end  
    ForkThread(UEFTaunts) 
end

function M1_Play_Berry_Dialogue()

    ScenarioFramework.Dialogue(OpStrings.M2_Berry_Cybran_Interaction, nil, true)  
end

function M1Objectives() 
  
    ScenarioInfo.M1P1 = Objectives.CategoriesInArea(
        'primary',
        'incomplete',
        'Eliminate Both Enemy Bases',
        'Scans indicate that there are two large hostile bases, destroy them.',
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P1OBJ1',
                    Category = categories.FACTORY + categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
                {   
                    Area = 'P1OBJ2',
                    Category = categories.FACTORY + categories.ECONOMIC,
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
    
    
    local quantity = {}
    
    quantity = {20, 40, 60}
    
    ScenarioInfo.M1S3 = Objectives.UnitStatCompare(
        'secondary',
        'incomplete',
        'ACU Prototype Weapon Test',
        'Kill 20 enemy units with your prototype ACU.',
        'kill',
        {
            Unit = ScenarioInfo.PlayerACU[1],
            StatName = 'KILLS',
            CompareOp = '>=',
            Value = quantity[Difficulty],
            ShowProgress = true,
        }
    )
    ScenarioInfo.M1S3:AddResultCallback(
        function(result)
            if (result) then
                ForkThread(M1GunUpgrade)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1S3)
    
    ScenarioInfo.M1S2 = Objectives.CategoriesInArea(
        'secondary',
        'incomplete',
        'Clear Your Landing Zone',
        'Your landing zone has multiple hostiles, clear them out.',
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P1SOBJ1',
                    Category = categories.FACTORY + categories.ENGINEER + categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
                {   
                    Area = 'P1SOBJ2',
                    Category = categories.FACTORY + categories.ENGINEER + categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Cybran,
                },
            },
        }
    )
    ScenarioInfo.M1S2:AddResultCallback(
        function(result)
            if (result) then
                
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P1)
    
    -- Expand to next part of the mission.
    if TimedExapansion then
        ScenarioFramework.CreateTimerTrigger(M2NISIntro, M1ExpansionTime[Difficulty])
    end
end

function M1GunUpgrade()
   
   ScenarioFramework.PlayUnlockDialogue()
   ScenarioFramework.RestrictEnhancements({
        'AdvancedEngineering',
        'DoubleGuns',
        'IntelProbe',
        'IntelProbeAdv',
        'Capacitor',
        'OrbitalBombardment',
        'PowerArmor',
        'RapidRepair',
        'ResourceAllocation',
        'T3Engineering'
    })
end

function M1SpawnCybranattacks()
    if ScenarioInfo.MissionNumber == 1 then
        ForkThread(function() 
            WaitSeconds(6*60)
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P1COffmapattack1', 'AttackFormation')
            ScenarioFramework.PlatoonPatrolChain(units, 'P1COffmapattack1')
            WaitSeconds(5)
            local units2 = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P1COffmapattack2', 'AttackFormation')
            ScenarioFramework.PlatoonPatrolChain(units2, 'P1COffmapattack2')
            WaitSeconds(5)
            ScenarioFramework.CreatePlatoonDeathTrigger(M1SpawnCybranattacks, units2)

        end)
    end
end

-- M2 Functions

function M2NISIntro()
    -- If this flag hasn't been marked as true, set it to true, that way we can exit the function straight away if this is true.
    if ScenarioInfo.MissionNumber == 2 or ScenarioInfo.MissionNumber == 3 then
        return
    end
    ScenarioInfo.MissionNumber = 2
    
    if ScenarioInfo.M1P1.Active then
    ScenarioInfo.M1P1:ManualResult(false)
    ForkThread(M2Extraattack)
    end

    -- Spawn M2 Units
    ScenarioInfo.CybranCommander = ScenarioFramework.SpawnCommander('Cybran', 'P2CACU', false, 'Jerrax', false, false,
    {'T3Engineering', 'ResourceAllocation'})
    ScenarioInfo.CybranCommander:SetCanBeKilled(false)
    ScenarioFramework.GroupMoveChain({ScenarioInfo.CybranCommander}, 'P2CCommanderWalk')
    
    -- Call the AI
    CybranaiP2:CybranMainBaseAI()

    -- Expand the necessary areas 
    ScenarioFramework.SetPlayableArea('M2_Zone', true)

    -- Fix alliances between the Nomads and the Cybran.
    for _, player in ScenarioInfo.HumanPlayers do
        SetAlliance(player, Cybran, 'Ally')
        SetAlliance(Cybran, player, 'Ally')

        SetAlliance(CybranCivilian, player, 'Ally')
        SetAlliance(player, CybranCivilian, 'Ally')
    end
    
    -- Prevent AI Resource sharing with player
     GetArmyBrain(Cybran):SetResourceSharing(false)
    
    -- Create M2 Cybran Patrols
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2CIntattack1', 'AttackFormation')
    local CybranAirPatrol = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2CIntattack2', 'AttackFormation')
    for k, v in CybranAirPatrol:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2NISattack3')))
    end

    -- Create Cybran Town and defenses
    ScenarioUtils.CreateArmyGroup('Cybran', 'P2CColonyDefenses_D'.. Difficulty)
    ScenarioInfo.Town = ScenarioUtils.CreateArmyGroup('CybranCivilian', 'P2CybranCity')
    
    -- Spawn the UEF AI
    UEFaiP2:P2UEFBase1AI()
    
    ScenarioUtils.CreateArmyGroup('Cybran', 'P2CWalls')
    ScenarioUtils.CreateArmyGroup('Cybran', 'P2CBase1Wreak', true)
    ScenarioUtils.CreateArmyGroup('UEF', 'P2UWalls')
    
    -- Create the NIS Attacks 
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UIntattack1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UIntattack2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2NISattack2')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UIntattack3', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2NISPatrol1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UIntattack4', 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2NISattack3')))
    end
    
    -- We need to create a cutscene!
    Cinematics.EnterNISMode()
    local VisMarker2_1 = ScenarioFramework.CreateVisibleAreaLocation(90, 'P2Vision1', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam1'), 2)
    WaitSeconds(2)
    ScenarioFramework.Dialogue(OpStrings.M2_P2_Cutscene_Dialogue, nil, true)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam2'), 2)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam3'), 2)
    WaitSeconds(1)
    ScenarioFramework.FakeTeleportUnit(ScenarioInfo.CybranCommander, true)
    WaitSeconds(3)
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UIntattack5', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2NISattack4')
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam5'), 1)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam6'), 2)
    WaitSeconds(2)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam1'), 0)
    VisMarker2_1:Destroy()

    WaitSeconds(0.5)
    Cinematics.ExitNISMode()
    -- End Cutscene
    
    --- landbase delayed because of T2 arty
    UEFaiP2:P2UEFBase2AI()
    
    -- Patrols for UEF bases
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UB1intpatrol3', 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2UB1Airdefense1')))
    end
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UB2intpatrol1', 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2UB2Airdefense1')))
    end
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UB1intpatrol1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2UB1Navaldefense3')
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UB1intpatrol2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2UB1Navaldefense1')
    
    -- Assign some objectives.
    ForkThread(M2Objectives)

    -- Send UEF Engineers to base
    ForkThread(M2SendUEFEngineersToPlataeu)
    
    -- Trigger Offmap Cybran attacks for "flavor"
    ForkThread(M2SpawnCybranattacks)
    
    --UEF assault Forces
    ForkThread(function()
    
            local destination = ScenarioUtils.MarkerToPosition('P2UAssaultDrop')

            local transports = ScenarioUtils.CreateArmyGroup('UEF', 'P2UAssaulttrans2_D' .. Difficulty)
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UAssaults2_D' .. Difficulty, 'AttackFormation')
            WaitSeconds(6)
            import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)
            
            for _, transport in transports do
                ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('Tdeath1'), 15)

                IssueTransportUnload({transport}, destination)
                IssueMove({transport}, ScenarioUtils.MarkerToPosition('Tdeath1'))
            end
        
            ScenarioFramework.PlatoonPatrolChain(units, 'P2UAssaultDropattack1')
        end)
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UAssaults3_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2UAssault2')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UAssaults1_D' .. Difficulty, 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
       ScenarioFramework.GroupAttackChain({v}, 'P2UAssault1')
    end
    
    -- Handle player reinforcements.
    ScenarioFramework.CreateTimerTrigger(M2PlayerReinforcements, 15)
    
    ArmyBrains[UEF]:GiveResource('MASS', 10000)
    ArmyBrains[UEF]:GiveResource('ENERGY', 6000)
    
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(UEF):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
       
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(Cybran):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
    
    --start Second Secondary mission.
    ForkThread(M2T3Artybase)
    ForkThread(M2KillCybranunits)
    ForkThread(M2NomadScouts)
    --Trigger Mission when player spots T3 arty location
    ScenarioFramework.CreateArmyIntelTrigger(M2T3ArtybaseObjective, ArmyBrains[Player1], 'LOSNow', false, true, categories.ueb4203, true, ArmyBrains[UEF]) 
end

function M2Objectives()

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
        'Destroy UEF Bases',                 -- title
        'Clearing out Both bases will reduce pressure on the civilian defenses.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2OBJ1',
                    Category = categories.FACTORY + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
                {   
                    Area = 'P2OBJ2',
                    Category = categories.FACTORY + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
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
                ForkThread(M3NISIntro)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P2)

    
    ForkThread(M2SecondaryObjectives)
    
    ScenarioFramework.CreateTimerTrigger(M3NISIntro, M2ExpansionTime[Difficulty])    
end

function M2Extraattack()
    
    WaitSeconds(20)
    --UEF Extra assault Forces
    ForkThread(function()
    
            local destination = ScenarioUtils.MarkerToPosition('P2UAssaultDrop2')

            local transports = ScenarioUtils.CreateArmyGroup('UEF', 'P2UAssaulttrans1_D' .. Difficulty)
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UAssaults4_D' .. Difficulty, 'AttackFormation')
            WaitSeconds(6)
            import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)
            
            for _, transport in transports do
                ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('Tdeath1'), 15)

                IssueTransportUnload({transport}, destination)
                IssueMove({transport}, ScenarioUtils.MarkerToPosition('Tdeath1'))
            end
        
            ScenarioFramework.PlatoonPatrolChain(units, 'P2UAssaultDropattack2')
        end)
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UAssaults5_D' .. Difficulty, 'GrowthFormation')
     for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2UAssault3')))
    end
end

function M2KillCybranunits()
   local CybranUnits = ScenarioFramework.GetCatUnitsInArea((categories.MOBILE), 'M1_Zone', ArmyBrains[Cybran])
            for k, v in CybranUnits do
                if v and not v.Dead then
                v:DestroyUnit()
                end
            end
end

function M2SecondaryObjectives()

    WaitSeconds(3*60)

    ScenarioFramework.Dialogue(OpStrings.M2_P2_SecondaryObj, nil, true)
    
    ScenarioInfo.M2S1 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy New UEF Base',                 -- title
        'Destroy the UEF Base underconstuction at the Cybrans former location.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2SOBJ1',
                    Category = categories.FACTORY + categories.ENGINEER + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
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

function M2SpawnCybranattacks()
    if ScenarioInfo.MissionNumber == 2 then
        ForkThread(function() 
            WaitSeconds(2*60)
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2COffmapattack1', 'AttackFormation')
            ScenarioFramework.PlatoonPatrolChain(units, 'P2COffmapattack1')
            WaitSeconds(5)
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2COffmapattack2', 'AttackFormation')
            ScenarioFramework.PlatoonPatrolChain(units, 'P2COffmapattack2')
            WaitSeconds(5)
            local units2 = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2COffmapattack3', 'AttackFormation')
            ScenarioFramework.PlatoonPatrolChain(units2, 'P2COffmapattack3')
            ScenarioFramework.CreatePlatoonDeathTrigger(M2SpawnCybranattacks, units2)

        end)
    end
end

function M2PlayerReinforcements()
    if (not M2ReinforcementsIntro) then
        WaitSeconds(1*60)
        ScenarioFramework.Dialogue(OpStrings.M2_IntroReinforcements, nil, true)
        M2ReinforcementsIntro = true
        ForkThread(M2UnlockT2Air)
        ForkThread(function()
    
            local destination = ScenarioUtils.MarkerToPosition('NomadDrop')

            local transports = ScenarioUtils.CreateArmyGroup('Nomads', 'P2ReinforementsTrans')
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P2Reinforements2', 'AttackFormation')
            WaitSeconds(5)
            import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)
            for _, transport in transports do
                ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('Tdeath2'), 15)

                IssueTransportUnload({transport}, destination)
                IssueMove({transport}, ScenarioUtils.MarkerToPosition('Tdeath2'))
            end
            
            for k, v in units:GetPlatoonUnits() do
            while (v:IsUnitState('Attached')) do
                WaitSeconds(1)
            end
            if (v and not v:IsDead()) then
                ScenarioFramework.GiveUnitToArmy(v, 'Player1')
            end
        end
        
        end)
    end

    ScenarioInfo.M2ReinforcementPing = PingGroups.AddPingGroup('Signal reinforcements', nil, 'move', 'Benson has prepared some prototype units to tackle the UEF. Signal them when you are ready.')
    ScenarioInfo.M2ReinforcementPing:AddCallback(M2SendPlayerReinforcements)
end

function M2UnlockT2Air()
    
    ScenarioFramework.PlayUnlockDialogue()
    -- Air units
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0203)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0104)
    -- Land Units
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0208)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0203)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0205)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0111)
    -- Factories
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0201)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.znb9501)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.znb9502)
    -- T2 mass and power
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb1201)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb1202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb1104)
    -- Air staging
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb5202)
    -- T2 sonar and Radar
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb3201)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb3202)
    
    ScenarioFramework.RestrictEnhancements({
        'DoubleGuns',
        'IntelProbe',
        'IntelProbeAdv',
        'OrbitalBombardment',
        'PowerArmor',
        'RapidRepair',
        'ResourceAllocation',
        'T3Engineering'
    })  
end

function M2SendPlayerReinforcements()
    ForkThread(function()
        ScenarioFramework.Dialogue(OpStrings.M2_ReinforcementsCalled, nil, true)

        ScenarioInfo.M2ReinforcementPing:Destroy()

        local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P2Reinforements_D' .. Difficulty, 'AttackFormation')
        ScenarioFramework.PlatoonMoveChain(units, 'P2NomadRchain')
        
        WaitSeconds(15)
        
         for k, v in units:GetPlatoonUnits() do
            if (v and not v:IsDead()) then
                ScenarioFramework.GiveUnitToArmy(v, 'Player1')
            end
        end
        
        ScenarioFramework.CreateTimerTrigger(M2PlayerReinforcements, M2ReinforcementCoolDown[Difficulty])
    end)
end

function M2SendUEFEngineersToPlataeu()
    -- We need to create some transports and send them to drop Engineers off on the Plateau next to the Cybran base. They will attempt to build artillery.
    -- The AI file that is in place will take care of the Engineers once they are dropped off. We only care about what the Engineers are doing during the phase
    -- of M2P1 (Protect the town) being active.
    if ScenarioInfo.MissionNumber == 2 then
        WaitSeconds(60)
        
        local destination = ScenarioUtils.MarkerToPosition('P2UEngineerdrop1')

        local transports = ScenarioUtils.CreateArmyGroup('UEF', 'P2UTransports')
        local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UEngineers', 'GrowthFormation')

        import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)

        for _, transport in transports do
            ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('P2UTransportdeath'), 15)

            IssueTransportUnload({transport}, destination)
            IssueMove({transport}, ScenarioUtils.MarkerToPosition('P2UTransportdeath'))
        end
        
        -- Disband the Platoon
        ArmyBrains[UEF]:DisbandPlatoon(units)
        UEFaiP2:P2UEFBase3AI()
    end
end

function M2T3Artybase()

    AIBuildStructures.CreateBuildingTemplate( ArmyBrains[UEF], 'UEF', 'UEFArtybase1' )
    AIBuildStructures.AppendBuildingTemplate(ArmyBrains[UEF], 'UEF', 'UEFArtybase', 'UEFArtybase1')
    
    AIBuildStructures.AppendBuildingTemplate( ArmyBrains[UEF], 'UEF', 'UEFArtybaseBD', 'UEFArtybase1')
    
    ScenarioUtils.CreateArmyGroup( 'UEF', 'UEFArtybase')
    
    plat = ScenarioUtils.CreateArmyGroupAsPlatoon( 'UEF', 'UEFArtybaseENG', 'NoFormation' )
    plat.PlatoonData.MaintainBaseTemplate = 'UEFArtybase1'
    plat.PlatoonData.PatrolChain = 'P2UENG1'
    plat:ForkAIThread(ScenarioPlatoonAI.StartBaseEngineerThread)
end

function M2T3ArtybaseObjective()

    ScenarioInfo.M2S2 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy UEF Artillery',                 -- title
        'Destroy the UEF Engineers constructing a T3 Artillery weapon.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2SOBJ2',
                    Category = categories.ueb2302 + categories.ENGINEER,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
            },
        }
    )
    ScenarioInfo.M2S2:AddResultCallback(
        function(result)
            if (result) then
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2S2)
end

function M2NomadScouts()

    WaitSeconds(5*60)
    ScenarioFramework.Dialogue(OpStrings.M2_Scout_Dialogue_1, nil, true)

    local units1 = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P2nScouts1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units1, 'P2Nscout1')
    
    units2 = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P2nScouts2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units2, 'P2Nscout2')
   
    units3 = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P2nScouts3', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units3, 'P2Nscout3')  
end

--M3 Functions

function M3NISIntro()
    
    if ScenarioInfo.MissionNumber == 3 then
        return
    end
    ScenarioInfo.MissionNumber = 3
    
    --let dialogue Finish 
    WaitSeconds(5)
    
    -- Spawn M3 Units
    ScenarioInfo.UEFCommander = ScenarioFramework.SpawnCommander('UEF', 'P3UACU', false, 'Colonel Berry', true, false,
    {'HeavyAntiMatterCannon', 'AdvancedEngineering', 'ShieldGeneratorField'})
    
    ScenarioInfo.P3CybranACU = ScenarioFramework.SpawnCommander('Cybran', 'P3CACU', false, 'Jerrax', true, false,
    {'NaniteTorpedoTube', 'StealthGenerator', 'T3Engineering'})
    
    ScenarioInfo.UEFCommander:AddBuildRestriction(categories.ueb2205 + categories.ueb2204 + categories.ueb4201 + categories.ueb0103 + categories.ueb2303 + categories.ueb1202 + categories.ueb1103 + categories.ueb1106)
    
    -- Spawn Air patrols
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UPatrol1_D'.. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3UB1Airdefense1')))
    end
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UPatrol2_D'.. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3UB2Airdefense1')))
    end
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UPatrol3_D'.. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3UB3Airdefense1')))
    end
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UPatrol4_D'.. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3UB4Airdefense1')))
    end
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3CPatrol2_D'.. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3CB1Airdefense1')))
    end
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3CPatrol1_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3CB1Navaldefense1')
    
    -- Call the AI
    UEFaiP3:P3UEFBase1AI()
    UEFaiP3:P3UEFBase2AI()
    UEFaiP3:P3UEFBase3AI()
    UEFaiP3:P3UEFBase4AI()
    CybranaiP2:P3CybranBaseAI()

    -- Expand the necessary areas 
    ScenarioFramework.SetPlayableArea('M3_Zone', true)
    
    ScenarioUtils.CreateArmyGroup('UEF', 'P3UWalls')
     
    Cinematics.EnterNISMode()
    WaitSeconds(1)
    
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UNISunits1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UNISunits2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3CNISunits1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack2')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3CNISunits2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack2')
    
    local VisMarker3_1 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision1', 0, ArmyBrains[Player1])
    local VisMarker3_3 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision2', 0, ArmyBrains[Player1])
    local VisMarker3_2 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision3', 0, ArmyBrains[Player1])
    local VisMarker3_4 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision4', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam1'), 2)
    ScenarioFramework.Dialogue(OpStrings.M3_Intro_Dialogue, nil, true)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam2'), 2)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam3'), 2)
    WaitSeconds(2)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam4'), 2)
    ScenarioFramework.Dialogue(OpStrings.M3_Intro_Dialogue2, nil, true)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam5'), 2)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam6'), 2)
    WaitSeconds(2)
    VisMarker3_1:Destroy()
    VisMarker3_2:Destroy()
    VisMarker3_3:Destroy()
    VisMarker3_4:Destroy()
    Cinematics.ExitNISMode()
    -- End Cutscene
    
    ForkThread(UEFNISattacks)
    ForkThread(M3UnlockT2Land)
    ForkThread(PrimaryObjective)
    
    ArmyBrains[UEF]:GiveResource('MASS', 10000)
    ArmyBrains[UEF]:GiveResource('ENERGY', 6000)
    
    ScenarioFramework.SetSharedUnitCap(1500)
    
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(UEF):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
       
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2.5

       for _, u in GetArmyBrain(Cybran):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end   
end

function SecondaryObjective()

    ScenarioInfo.M3S1 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy UEF Secondary Bases',                 -- title
        'The UEF commander has a number of support bases, destroy them.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P3SOBJ1',
                    Category = categories.FACTORY + categories.ENGINEER + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
                {   
                    Area = 'P3SOBJ2',
                    Category = categories.FACTORY + categories.ENGINEER + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
                {   
                    Area = 'P3SOBJ3',
                    Category = categories.FACTORY + categories.ENGINEER + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
            },
        }
    )
    ScenarioInfo.M3S1:AddResultCallback(
        function(result)
            if (result) then
            ScenarioFramework.Dialogue(OpStrings.M3_SBases_Destroyed, nil, true)
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
    
    ScenarioInfo.M3P2 = Objectives.Protect(
        'primary',
        'incomplete',                   
        'Protect Cybran Commander',            
        'The Cybran is attempting to help defeat the UEF, make sure he does not die.',      
        { 
            MarkUnits = true,                              
            Units = {ScenarioInfo.P3CybranACU}         
        }
    )
    ScenarioInfo.M3P2:AddResultCallback(
        function(result)
            if (not result) then
                ScenarioFramework.PlayerLose(OpStrings.M2_Cybran_Defeated)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P1)

    ForkThread(M3UnlockT2Land)

    ForkThread(SecondaryObjective)    
end

function UEFNISattacks()
   
   --Spawn starting attacks and send at player base, to rough them up a bit
   
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UAssault3_D' .. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3UAssault1')))
    end  
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UAssault4_D' .. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3UAssault2')))
    end 
    
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UAssault1_D'.. Difficulty, 'GrowthFormation')
        ScenarioFramework.PlatoonPatrolChain(units, 'P3UAssault3')

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UAssault2_D'.. Difficulty, 'GrowthFormation')
        ScenarioFramework.PlatoonPatrolChain(units, 'P3UAssault4')  
        
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UPatrolNaval1_D'.. Difficulty, 'GrowthFormation')
        ScenarioFramework.PlatoonPatrolChain(units, 'P3UNavaldefense1')
        
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UPatrolNaval2_D'.. Difficulty, 'GrowthFormation')
        ScenarioFramework.PlatoonPatrolChain(units, 'P3UNavaldefense2')
    
    ForkThread(function()
    
            local destination = ScenarioUtils.MarkerToPosition('P3UDrop1')

            local transports = ScenarioUtils.CreateArmyGroup('UEF', 'P3UDropattacktrans1_D' .. Difficulty)
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UDropattack1_D' .. Difficulty, 'AttackFormation')
            WaitSeconds(6)
            import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)
            
            for _, transport in transports do
                ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('Tdeath2'), 15)

                IssueTransportUnload({transport}, destination)
                IssueMove({transport}, ScenarioUtils.MarkerToPosition('Tdeath2'))
            end
        
            ScenarioFramework.PlatoonPatrolChain(units, 'P3UDropattack1')
        end)
        
    ForkThread(function()
    
            local destination = ScenarioUtils.MarkerToPosition('P3UDrop2')

            local transports = ScenarioUtils.CreateArmyGroup('UEF', 'P3UDropattacktrans2_D' .. Difficulty)
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UDropattack2_D' .. Difficulty, 'AttackFormation')
            WaitSeconds(9)
            import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)
            
            for _, transport in transports do
                ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('Tdeath2'), 15)

                IssueTransportUnload({transport}, destination)
                IssueMove({transport}, ScenarioUtils.MarkerToPosition('Tdeath2'))
            end
        
            ScenarioFramework.PlatoonPatrolChain(units, 'P3UDropattack2')
        end)
        
    ForkThread(function()
    
            local destination = ScenarioUtils.MarkerToPosition('P3UDrop3')

            local transports = ScenarioUtils.CreateArmyGroup('UEF', 'P3UDropattacktrans3_D' .. Difficulty)
            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UDropattack3_D' .. Difficulty, 'AttackFormation')
            WaitSeconds(12)
            import('/lua/ai/aiutilities.lua').UseTransports(units:GetPlatoonUnits(), transports, destination)
            
            for _, transport in transports do
                ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport,  ScenarioUtils.MarkerToPosition('Tdeath2'), 15)

                IssueTransportUnload({transport}, destination)
                IssueMove({transport}, ScenarioUtils.MarkerToPosition('Tdeath2'))
            end
        
            ScenarioFramework.PlatoonPatrolChain(units, 'P3UDropattack3')
        end)  
end

function M3UnlockT2Land()
    
    WaitSeconds(60)
    ScenarioFramework.Dialogue(OpStrings.M3_TechIntel, nil, true)
    
    ScenarioFramework.PlayUnlockDialogue()
    
    -- Destroyer
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0203)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.znb9503)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xns0201)
    --Defense structures
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2201)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2207)
end

function UEFCommanderKilled()

    ScenarioFramework.Dialogue(OpStrings.M3_UEFDeath, nil, true)
    ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.UEFCommander, 3)
    WaitSeconds(6)
    ForkThread(EndNIS)   
end

function EndNIS()

    Cinematics.EnterNISMode()
    WaitSeconds(1)
    ScenarioInfo.M2P1:ManualResult(true)
    ScenarioInfo.M3P2:ManualResult(true)
    ScenarioFramework.Dialogue(OpStrings.M3_Outro_Dialogue, nil, true)
    WaitSeconds(5)
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P3NNisunitsA', 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3NomadNISchain')))
    end
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam6'), 2)
    WaitSeconds(20)
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

function DropReinforcements(brain, targetBrain, units, DropLocation, TransportDestination)
    local strArmy = targetBrain
    local landUnits = {}
    local allTransports = {}

    ForkThread(
        function()
            local allUnits = ScenarioUtils.CreateArmyGroup(brain, units)

            for _, unit in allUnits do
                if EntityCategoryContains( categories.TRANSPORTATION, unit ) then
                    table.insert(allTransports, unit )
                else
                    table.insert(landUnits, unit )
                end
            end
            
            for _, transport in allTransports do
                ScenarioFramework.AttachUnitsToTransports(landUnits, {transport})
                WaitSeconds(1)
                IssueTransportUnload({transport}, ScenarioUtils.MarkerToPosition(DropLocation))
                IssueMove({transport}, ScenarioUtils.MarkerToPosition(TransportDestination))
                ScenarioFramework.CreateUnitToMarkerDistanceTrigger(DestroyUnit, transport, TransportDestination, 10)
            end

            for _, unit in landUnits do
                while (not unit:IsDead() and unit:IsUnitState('Attached')) do
                    WaitSeconds(1)
                end
                if (unit and not unit:IsDead()) then
                    --ArmyBrains[UEF]:AssignUnitsToPlatoon(platoon, {unit}, 'Attack', 'AttackFormation')
                    ScenarioFramework.GroupAttackChain(unit, 'P2UAssaultDropattack1')
                end
            end
        end
    )
end

function PlayerLose()
    if(not ScenarioInfo.OpEnded) then
        ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.PlayerCDR)
        ScenarioFramework.EndOperationSafety()
        ScenarioInfo.OpComplete = false
        for _, v in AssignedObjectives do
            if(v and v.Active) then
                v:ManualResult(false)
            end
        end
        WaitSeconds(3)
       KillGame()
  end   
end

-- Taunts
function UEFTaunts()
    if(not ScenarioInfo.OpEnded) then
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
end

