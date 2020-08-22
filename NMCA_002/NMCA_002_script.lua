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
local CybranaiP3 = import('/maps/NMCA_002/CybranaiP3.lua')
local UEFaiP1 = import('/maps/NMCA_002/UEFaiP1.lua')
local UEFaiP2 = import('/maps/NMCA_002/UEFaiP2.lua')
local UEFaiP3 = import('/maps/NMCA_002/UEFaiP3.lua')

local UEFTM = TauntManager.CreateTauntManager('UEF1TM', '/maps/NMCA_002/NMCA_002_strings.lua')

-- Global Variables
ScenarioInfo.Player1 = 1
ScenarioInfo.Cybran = 2
ScenarioInfo.NomadsEnemy = 3
ScenarioInfo.UEF = 4
ScenarioInfo.Player2 = 6
ScenarioInfo.Player3 = 7
ScenarioInfo.Player4 = 8
ScenarioInfo.Nomads = 5
ScenarioInfo.PlayerACU = {}

-- Local Variables
local Player1 = ScenarioInfo.Player1
local Cybran = ScenarioInfo.Cybran
local NomadsEnemy = ScenarioInfo.NomadsEnemy
local UEF = ScenarioInfo.UEF
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3
local Player4 = ScenarioInfo.Player4
local Nomads = ScenarioInfo.Nomads

local Difficulty = ScenarioInfo.Options.Difficulty
local TimedExapansion = ScenarioInfo.Options.Expansion

local AssignedObjectives = {}

local SkipNIS1 = false

M2ReinforcementsIntro = false

local M1ExpansionTime = {35*60, 30*60, 25*60}  
local M2ExpansionTime = {35*60, 30*60, 25*60}

local M2ReinforcementCoolDown = {5*60, 5*60, 5*60} 


function OnPopulate(self)
    ScenarioUtils.InitializeScenarioArmies()
    ScenarioFramework.SetPlayableArea('M1_Zone', false)

    SetArmyColor('UEF', 41, 40, 140)
    SetArmyColor('Cybran',  128, 39, 37)
    SetArmyColor('NomadsEnemy', 255, 120, 100)
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
    
    ScenarioFramework.SetSharedUnitCap(1200)
    SetArmyUnitCap(UEF, 4000)
    SetArmyUnitCap(Cybran, 4000)
    SetArmyUnitCap(NomadsEnemy, 300)
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

    local function SpawnPlayers(armyList)
        ScenarioInfo.PlayersACUs = {}
        local i = 1

        while armyList[ScenarioInfo['Player' .. i]] do
            ScenarioInfo['Player' .. i .. 'CDR'] = ScenarioFramework.SpawnCommander('Player' .. i, 'Commander', 'Warp', true, true, PlayerDeath)
            table.insert(ScenarioInfo.PlayersACUs, ScenarioInfo['Player' .. i .. 'CDR'])
            WaitSeconds(1)
            i = i + 1
        end
    end

    local tblArmy = ListArmies()

    -- Spawn Players
        ForkThread(SpawnPlayers, tblArmy)
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P1CIntattack0', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P1CNispatrol0')
    WaitSeconds(3)

    ScenarioFramework.Dialogue(OpStrings.M1_Intro_CDR_Dropped_Dialogue, nil, true)
    WaitSeconds(5)

    local UEF_NIS_Units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P1UIntattack1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(UEF_NIS_Units, 'P1NISpatrol1' )

    local VisMarker1_1 = ScenarioFramework.CreateVisibleAreaLocation(30, 'P1Vision1', 0, ArmyBrains[Player1])
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P1CIntattack1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P1NISpatrol2')


 
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam2'), 2)
    WaitSeconds(1)
   
    ScenarioFramework.Dialogue(OpStrings.M1_Intro_Fight_Dialogue, nil, true)
    local VisMarker1_2 = ScenarioFramework.CreateVisibleAreaLocation(40, 'P1Vision2', 0, ArmyBrains[Player1])

    WaitSeconds(8)
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P1CIntattack2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P1NISpatrol2' )
    
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam3'), 2)
    WaitSeconds(2)
    ScenarioFramework.Dialogue(OpStrings.M1_Intro_CDR_Dropped_Dialogue_2, nil, true)
    local VisMarker1_3 = ScenarioFramework.CreateVisibleAreaLocation(60, 'P1Vision3', 0, ArmyBrains[Player1])
    local VisMarker1_4 = ScenarioFramework.CreateVisibleAreaLocation(60, 'P1Vision4', 0, ArmyBrains[Player1])
    local VisMarker1_5 = ScenarioFramework.CreateVisibleAreaLocation(60, 'P1Vision5', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam1'), 1)
    
    VisMarker1_1:Destroy()
    VisMarker1_2:Destroy()
    VisMarker1_3:Destroy()
    VisMarker1_4:Destroy()
    VisMarker1_5:Destroy()
    
    if Difficulty == 3 then
            ScenarioFramework.ClearIntel(ScenarioUtils.MarkerToPosition('P1Vision3'), 70)
            ScenarioFramework.ClearIntel(ScenarioUtils.MarkerToPosition('P1Vision4'), 70)
            ScenarioFramework.ClearIntel(ScenarioUtils.MarkerToPosition('P1Vision5'), 70)
    end

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

    ForkThread(M1SendPlayerReinforcements) 
end

function M1_Play_Berry_Dialogue()

    ScenarioFramework.Dialogue(OpStrings.M1_Berry_Cybran_Interaction, nil, true)  
end

function M1Objectives() 
  
    ScenarioInfo.M1P1 = Objectives.CategoriesInArea(
        'primary',
        'incomplete',
        'Eliminate All Enemy Bases',
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
                {   
                    Area = 'P1OBJ3',
                    Category = categories.FACTORY + categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
                {   
                    Area = 'P1OBJ4',
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
                ForkThread(StartM1attacks) 
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P1)
    
    
    
    -- Expand to next part of the mission.
    if TimedExapansion then
        ScenarioFramework.CreateTimerTrigger(StartM1attacks, M1ExpansionTime[Difficulty])
    end

    WaitSeconds(1*60)
    ScenarioFramework.Dialogue(OpStrings.M1_ACUTest_Dialogue_Start, M1SecondaryObj, true)
end

function M1SecondaryObj()

    local quantity = {20, 40, 60}
    
    ScenarioInfo.M1S3 = Objectives.UnitStatCompare(
        'secondary',
        'incomplete',
        'ACU Prototype Weapon Test',
        'Kill '..quantity[Difficulty]..' enemy units with your prototype ACU.',
        'kill',
        {
            Unit = ScenarioInfo.Player1CDR,
            StatName = 'KILLS',
            CompareOp = '>=',
            Value = quantity[Difficulty],
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
end

function M1GunUpgrade()
   
    ScenarioFramework.Dialogue(OpStrings.M1_ACUTest_Dialogue_Complete, nil, true)  

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

function M1SendPlayerReinforcements()

    WaitSeconds(12*60)

    ForkThread(function()
        ScenarioFramework.Dialogue(OpStrings.M1_ReinforcementsCalled, nil, true)

        local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P1Reinforements_D' .. Difficulty, 'AttackFormation')
        ScenarioFramework.PlatoonMoveChain(units, 'P1NomadRchain')
        
        WaitSeconds(15)
        
         for k, v in units:GetPlatoonUnits() do
            if (v and not v:IsDead()) then
                ScenarioFramework.GiveUnitToArmy(v, 'Player1')
            end
        end
        
    end)

    ScenarioFramework.PlayUnlockDialogue()

    -- Factories
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0201)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.znb9501)
    -- Land Units
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0208)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0203)
end

--M1 End Attacks

function StartM1attacks()

    if ScenarioInfo.MissionNumber == 2 or ScenarioInfo.MissionNumber == 3 then
        return
    end
    ScenarioInfo.MissionNumber = 2
    
    if not SkipNIS1 then
    ScenarioFramework.Dialogue(OpStrings.M1_OffMapAttack_Dialogue_Start, nil, true)

    ScenarioInfo.M1CounterAttackUnits = {}

    local quantity = {}
    local trigger = {}
    local platoon

    local function AddUnitsToObjTable(platoon)
        for _, v in platoon:GetPlatoonUnits() do
            if not EntityCategoryContains(categories.TRANSPORTATION + categories.SCOUT + categories.SHIELD, v) then
                table.insert(ScenarioInfo.M1CounterAttackUnits, v)
            end
        end
    end

     -- Air attack

    -- Basic air attack
    for i = 1, 2 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2UAssaultsAir_' .. i .. '_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P2UAssaultAir' .. i)
        AddUnitsToObjTable(platoon)
    end

    -- Sends combat fighters if players has more than [20, 25, 30] air fighters
    num = ScenarioFramework.GetNumOfHumanUnits(categories.AIR * categories.MOBILE - categories.SCOUT)
    quantity = {20, 25, 30}
    if num > quantity[Difficulty] then
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2UAssaultsAirHunt_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        for k, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2CAssault2')))
        end
        AddUnitsToObjTable(platoon)
    end


    -- Sends [3, 3, 5] Gunships at players' ACUs
    for _, v in ScenarioInfo.PlayersACUs do
        if not v:IsDead() then
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2UAssaultsAirSnipe_D' .. Difficulty, 'NoFormation', 5)
            IssueAttack(platoon:GetPlatoonUnits(), v)
            IssueAggressiveMove(platoon:GetPlatoonUnits(), ScenarioUtils.MarkerToPosition('Player1'))
            AddUnitsToObjTable(platoon)
        end
    end


    -- First move ships to the map, then patrol, to make sure they won't shoot from off-map

    -- Destroyers
    num = ScenarioFramework.GetNumOfHumanUnits(categories.NAVAL * categories.MOBILE)
    quantity = {30, 30, 25}
    if num > quantity[Difficulty] then
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2UAssaultsDestroyer_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('M1_Destroyer_Entry_1'), false)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P2UAssaultDes1')
        AddUnitsToObjTable(platoon)
    end

    -- Cruiser, only on medium and high difficulty

    if Difficulty >= 2 then
        num = ScenarioFramework.GetNumOfHumanUnits(categories.AIR * categories.MOBILE)
        quantity = {0, 35, 30}
        if num > quantity[Difficulty] then
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2UAssaultsCrusier_D' .. Difficulty, 'AttackFormation', 1 + Difficulty)
            platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('M1_Frigate_Entry_2'), false)
            ScenarioFramework.PlatoonPatrolChain(platoon, 'P2UAssaultDes1')
            AddUnitsToObjTable(platoon)
        end
    end

    -- Frigates
    for i = 1, 2 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2UAssaultsFrigate_' .. i .. '_D' .. Difficulty, 'AttackFormation', Difficulty)
        platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('M1_Frigate_Entry_' .. i), false)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P2UAssaultFrig' .. i)
        AddUnitsToObjTable(platoon)
    end

    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UAssaultsLand_D' .. Difficulty, 'AttackFormation')
        ScenarioFramework.PlatoonAttackWithTransports(platoon, 'P2CB1Drop2', 'P2UAssaultDropattack1', true)
        AddUnitsToObjTable(platoon)


    ScenarioUtils.CreateArmyGroup('Cybran', 'P2CPower')

    platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Cybran', 'P2CAssaultsLand_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P2CAssault1')
        AddUnitsToObjTable(platoon)

    platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Cybran', 'P2CAssaultsLand2_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P2CAssault1')
        AddUnitsToObjTable(platoon)

    local extractors = ScenarioFramework.GetListOfHumanUnits(categories.MASSEXTRACTION)
    local num = table.getn(extractors)
    quantity = {3, 4, 6}
    if num > 0 then
        if ScenarioFramework.GetNumOfHumanUnits(categories.ALLUNITS - categories.WALL) < 300 then
            if num > quantity[Difficulty] then
                num = quantity[Difficulty]
            end
        else
            quantity = {6, 6, 8}
            if num > quantity[Difficulty] then
                num = quantity[Difficulty]
            end
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2CAssaultsAir_D' .. Difficulty, 'GrowthFormation')
            IssueAttack(platoon:GetPlatoonUnits(), extractors[i])
            IssueAggressiveMove(platoon:GetPlatoonUnits(), ScenarioUtils.MarkerToPosition('Player1'))
            AddUnitsToObjTable(platoon)

            local guard = ScenarioUtils.CreateArmyGroup('Cybran', 'P2CAssaultsAirGuard')
            IssueGuard(guard, platoon:GetPlatoonUnits()[1])
        end
    end

   --------------------------------------------
    -- Primary Objective - Defeat Counter Attack
    --------------------------------------------
    ScenarioInfo.M4P1 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        'Defeat Enemy Assault',
        'UEF and Cybran forces are attmepting to retake the zone, hold them off.',
        {
            Units = ScenarioInfo.M1CounterAttackUnits,
            MarkUnits = false,
        }
    )
    ScenarioInfo.M4P1:AddResultCallback(
        function(result)
            if result then
            ScenarioFramework.Dialogue(OpStrings.M1_OffMapAttack_Dialogue_End, M2NISIntro, true)
            end
        end
    )

   else 

   ForkThread(M2NISIntro)
   end
end

-- M2 Functions

function M2NISIntro()

    WaitSeconds(5)

    -- Call the AI
    CybranaiP2:CybranBase1AI()
    CybranaiP2:CybranBase2AI()

    -- Expand the necessary areas 
    ScenarioFramework.SetPlayableArea('M2_Zone', true)

    -- Create Cybran Town and defenses
    ScenarioUtils.CreateArmyGroup('Cybran', 'P2CColonyDefenses_D'.. Difficulty)
    ScenarioInfo.Town = ScenarioUtils.CreateArmyGroup('Cybran', 'P2CybranCity')

    --Wreakage for flavor
    ScenarioUtils.CreateArmyGroup('Cybran', 'P2Wreaks', true)
    
    -- Spawn the UEF AI
    UEFaiP2:P2UEFBase1AI()
    UEFaiP2:P2UEFBase2AI()
    
    ScenarioUtils.CreateArmyGroup('Cybran', 'P2CWalls')
    ScenarioUtils.CreateArmyGroup('UEF', 'P2UWalls')
    
    -- Create the NIS Attacks 
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2Uintattack1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2CIntattack1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2CIntattack2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2NISattack2')

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2Uintattack2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2NISattack4')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2CIntattack3', 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2NISattack3')))
    end
    
    -- We need to create a cutscene!
    Cinematics.EnterNISMode()
    Cinematics.SetInvincible('M1_Zone')

    ScenarioFramework.Dialogue(OpStrings.M2_P2_Cutscene_Intro, nil, true)

    local VisMarker2_1 = ScenarioFramework.CreateVisibleAreaLocation(90, 'P2Vision1', 0, ArmyBrains[Player1])
    local VisMarker2_2 = ScenarioFramework.CreateVisibleAreaLocation(90, 'P2Vision2', 0, ArmyBrains[Player1])
    local VisMarker2_3 = ScenarioFramework.CreateVisibleAreaLocation(60, 'P2Vision3', 0, ArmyBrains[Player1])
    local VisMarker2_4 = ScenarioFramework.CreateVisibleAreaLocation(90, 'P2Vision4', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam1'), 3)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam2'), 3)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam3'), 3)
    WaitSeconds(3)
    ScenarioFramework.Dialogue(OpStrings.M2_P2_Cutscene_Dialogue, nil, true)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam5'), 3)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam1'), 0)
    VisMarker2_1:Destroy()
    VisMarker2_2:Destroy()
    VisMarker2_3:Destroy()
    VisMarker2_4:Destroy()

    WaitSeconds(0.5)
    Cinematics.SetInvincible('M1_Zone', true)
    Cinematics.ExitNISMode()
    -- End Cutscene
    
    --- T2 arty in UEF base 2 for bonus Obj
    ScenarioInfo.P2Arty = ScenarioUtils.CreateArmyGroup('UEF', 'P2UB2Arty')

    
    -- Patrols for UEF bases
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UB1intpatrol2_D' .. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2UB1Airdefense1')))
    end
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UB2intpatrol1_D' .. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2UB2Airdefense1')))
    end
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2UB1intpatrol1_D' .. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2UB1Navaldefense1')

    -- Assign some objectives.
    ForkThread(M2ScenarioChoice)
    
    -- Handle player reinforcements.
    ScenarioFramework.CreateTimerTrigger(M2PlayerReinforcements, 15)
    
    ArmyBrains[UEF]:GiveResource('MASS', 10000)
    ArmyBrains[UEF]:GiveResource('ENERGY', 60000)

    ArmyBrains[Cybran]:GiveResource('MASS', 10000)
    ArmyBrains[Cybran]:GiveResource('ENERGY', 60000)
    
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
end

function M2ScenarioChoice()
    local dialogue = CreateDialogue(OpStrings.M2ChoiceTitle, {OpStrings.M2ChoiceKill, OpStrings.M2ChoiceCapture}, 'right')
    dialogue.OnButtonPressed = function(self, info)
        dialogue:Destroy()
        if info.buttonID == 1 then
            -- Attack UEF
            ScenarioInfo.M2PlayersPlan = 'killC'
            ScenarioFramework.Dialogue(OpStrings.M2_P2_ChoiceCybranProgress, M2CybranObjectives, true)
        else
            -- Attack Cybran
            ScenarioInfo.M2PlayersPlan = 'killU'
            ScenarioFramework.Dialogue(OpStrings.M2_P2_ChoiceUEFProgress, M2UEFObjectives, true)
        end
    end

    WaitSeconds(40)

    -- Remind player to pick the plan
    if not ScenarioInfo.M2PlayersPlan then
        ScenarioFramework.Dialogue(OpStrings.M2ChoiceReminder, nil, true)
    else
        return
    end

    WaitSeconds(20)

    -- If player takes too long, continue with the mission
    if not ScenarioInfo.M2PlayersPlan then
        dialogue:Destroy()
        ScenarioInfo.M2PlayersPlan = 'killU'
        ScenarioFramework.Dialogue(OpStrings.M2ForceChoice, M2CybranObjectives, true)
    end
end

function M2UEFObjectives()


    ScenarioInfo.M1P2 = Objectives.CategoriesInArea(
        'primary',                      -- type
        'incomplete',                   -- complete
        'Destroy UEF Naval Base',                 -- title
        'UEF commander has overexended his base, destroy the naval base to punish him.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2UOBJ1',
                    Category = categories.FACTORY + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },

            },
        }
    )
    ScenarioInfo.M1P2:AddResultCallback(
        function(result)
            if (result) then
                ForkThread(M3Choicepath)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P2)

    ScenarioInfo.M2P2 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy Cybran stealth Fields',                 -- title
        'The Cybran are hiding this naval base from the UEF, If we take out the steath the UEF may attack it.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2SOBJ1',
                    Category = categories.urb4203,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Cybran,
                },

            },
        }
    )
    ScenarioInfo.M2P2:AddResultCallback(
        function(result)
            if (result) then
                ScenarioFramework.Dialogue(OpStrings.M2_P2_SecondaryObjUEF1, M2UCounterattack1, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P2)

    ScenarioInfo.M3P2 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy City Defenses',                 -- title
        'We may be able to weaken the Cybran city enough for the UEF to attack them for us.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2SOBJ3',
                    Category = categories.STRUCTURE * categories.DEFENSE - categories.WALL,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Cybran,
                },

            },
        }
    )
    ScenarioInfo.M3P2:AddResultCallback(
        function(result)
            if (result) then
                ScenarioFramework.Dialogue(OpStrings.M2_P2_SecondaryObjUEF2, M2UCounterattack2, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3P2)

    
    ScenarioFramework.CreateTimerTrigger(M3Choicepath, M2ExpansionTime[Difficulty])    
end

function M2CybranObjectives()

    ScenarioInfo.M1P2 = Objectives.CategoriesInArea(
        'primary',                      -- type
        'incomplete',                   -- complete
        'Destroy Cybran City',                 -- title
        'If we attack the city, the Cybran will lash out recklessly.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2COBJ1',
                    Category = categories.CIVILIAN,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Cybran,
                },

            },
        }
    )
    ScenarioInfo.M1P2:AddResultCallback(
        function(result)
            if (result) then
                ForkThread(M3Choicepath)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P2)

    ScenarioInfo.M2P2 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy UEF Naval Defenses',                 -- title
        'If we damage the UEF naval bases defense, the cybran might finish the job.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2UOBJ1',
                    Category = categories.ueb2109 + categories.ueb2205,
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
                ScenarioFramework.Dialogue(OpStrings.M2_P2_SecondaryObjCybran1, M2CCounterattack1, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P2)

    ScenarioInfo.M3P2 = Objectives.CategoriesInArea(
        'secondary',                      -- type
        'incomplete',                   -- complete
        'Destroy UEF Artillary and AA installations',                 -- title
        'Destroying the UEF long range defense may prompt the cybran to abuse that flaw.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2SOBJ2',
                    Category = categories.ueb2204 + categories.ueb2303,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },

            },
        }
    )
    ScenarioInfo.M3P2:AddResultCallback(
        function(result)
            if (result) then
                ScenarioFramework.Dialogue(OpStrings.M2_P2_SecondaryObjCybran2, M2CCounterattack2, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3P2)
    
    ScenarioFramework.CreateTimerTrigger(M3Choicepath, M2ExpansionTime[Difficulty])    
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

    ForkThread(M2SendPlayerReinforcements) 
end

function M2UnlockT2Air()
    
    ScenarioFramework.PlayUnlockDialogue()
    -- Air units
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0203)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0104)
    -- Land Units
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0205)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0111)
    -- Factories
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0202)
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
    if ScenarioInfo.MissionNumber == 2 then

        ForkThread(function()
            ScenarioFramework.Dialogue(OpStrings.M2_ReinforcementsCalled, nil, true)

            local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P2Reinforements_D' .. Difficulty, 'AttackFormation')
            ScenarioFramework.PlatoonMoveChain(units, 'P2NomadRchain')
        
            WaitSeconds(20)
        
            for k, v in units:GetPlatoonUnits() do
                if (v and not v:IsDead()) then
                    ScenarioFramework.GiveUnitToArmy(v, 'Player1')
                end
            end
        
            ScenarioFramework.CreateTimerTrigger(M2SendPlayerReinforcements, M2ReinforcementCoolDown[Difficulty])
        end)
    end
end

function M2CCounterattack1()

    -- Destroyers
    local platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Cybran', 'P2CSecattack1_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
    platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('P2COffmapattackMK'), false)
    ScenarioFramework.PlatoonPatrolChain(platoon, 'P2COffmapattack1')
end

function M2CCounterattack2()

    units = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Cybran', 'P2CSecattack3_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        for _, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupAttackChain({v}, 'P2COffmapattack2')
        end

    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P2CSecattack2_D' .. Difficulty, 'AttackFormation')
        ScenarioFramework.PlatoonAttackWithTransports(platoon, 'P2COffmapattackDrop1', 'P2COffmapattack2', true)
end

function M2UCounterattack1()

    units = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2USecattack1_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        for _, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupAttackChain({v}, 'P2UOffmapattack1')
        end
end

function M2UCounterattack2()

    platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2USecattack2_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P2UOffmapattack2')
        
    WaitSeconds(15)

    platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2USecattack2_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P2UOffmapattack2')
end

--M3 Functions

function M3Choicepath()

    if ScenarioInfo.M2PlayersPlan == 'killC' then

    ScenarioFramework.Dialogue(OpStrings.M3_Assault_DialogueCybran, CybranNISattacks, true)

    elseif ScenarioInfo.M2PlayersPlan == 'killU' then

    ScenarioFramework.Dialogue(OpStrings.M3_Assault_DialogueUEF, UEFNISattacks, true)

    end
end

function M3NISIntroUEF()
    
    if ScenarioInfo.MissionNumber == 4 then
        return
    end
    ScenarioInfo.MissionNumber = 4
    
    --let dialogue Finish 
    WaitSeconds(5)
    
    -- Spawn M3 Units
    ScenarioInfo.UEFCommander = ScenarioFramework.SpawnCommander('UEF', 'P3UACU', false, 'Colonel Berry', true, false,
    {'HeavyAntiMatterCannon', 'AdvancedEngineering', 'Shield'})
    
    ScenarioInfo.CybranCommander = ScenarioFramework.SpawnCommander('Cybran', 'P3CACU', false, 'Jerrax', true, false,
    {'NaniteTorpedoTube', 'StealthGenerator', 'AdvancedEngineering'})
    
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
    CybranaiP3:P3CybranBase1AI()

    --These two base are destroyed if player chose Cybran to focus
    ScenarioUtils.CreateArmyGroup('Cybran', 'P3CBase2', true)
    ScenarioUtils.CreateArmyGroup('Cybran', 'P3CBase3', true)

    -- Expand the necessary areas 
    ScenarioFramework.SetPlayableArea('M3_Zone', true)
    
    ScenarioUtils.CreateArmyGroup('UEF', 'P3UWalls')
    ScenarioUtils.CreateArmyGroup('Cybran', 'P3CWalls')
     
    Cinematics.EnterNISMode()
    WaitSeconds(1)
    
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UNisUnits1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UNisUnits2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3NisUnits1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack2')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3NisUnits2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack2')

    local VisMarker3_1 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision1', 0, ArmyBrains[Player1])
    local VisMarker3_3 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision2', 0, ArmyBrains[Player1])
    local VisMarker3_2 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision3', 0, ArmyBrains[Player1])

    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam1'), 2)
    ScenarioFramework.Dialogue(OpStrings.M3_IntroUEF_Dialogue, nil, true)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam2'), 2)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam3'), 3)
    WaitSeconds(2)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam4'), 2)
    ScenarioFramework.Dialogue(OpStrings.M3_Intro_Dialogue2, nil, true)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam5'), 3)
    WaitSeconds(3)
    VisMarker3_1:Destroy()
    VisMarker3_2:Destroy()
    VisMarker3_3:Destroy()
    Cinematics.ExitNISMode()
    -- End Cutscene
    
    ForkThread(M3UnlockT2Land)
    ForkThread(PrimaryObjective)
    
    ArmyBrains[UEF]:GiveResource('MASS', 10000)
    ArmyBrains[UEF]:GiveResource('ENERGY', 60000)
    
    ArmyBrains[Cybran]:GiveResource('MASS', 10000)
    ArmyBrains[Cybran]:GiveResource('ENERGY', 60000)

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
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(Cybran):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end   
end

function M3NISIntroCybran()
    
    if ScenarioInfo.MissionNumber == 4 then
        return
    end
    ScenarioInfo.MissionNumber = 4
    
    --let dialogue Finish 
    WaitSeconds(5)
    
    -- Spawn M3 Units
    ScenarioInfo.UEFCommander = ScenarioFramework.SpawnCommander('UEF', 'P3UACU', false, 'Colonel Berry', true, false,
    {'HeavyAntiMatterCannon', 'AdvancedEngineering', 'Shield'})
    
    ScenarioInfo.CybranCommander = ScenarioFramework.SpawnCommander('Cybran', 'P3CACU', false, 'Jerrax', true, false,
    {'NaniteTorpedoTube', 'StealthGenerator', 'AdvancedEngineering'})
    
    ScenarioInfo.UEFCommander:AddBuildRestriction(categories.ueb2205 + categories.ueb2204 + categories.ueb4201 + categories.ueb0103 + categories.ueb2303 + categories.ueb1202 + categories.ueb1103 + categories.ueb1106)
    
    -- Spawn Air patrols
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UPatrol1_D'.. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3UB1Airdefense1')))
    end

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3CPatrol2_D'.. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3CB1Airdefense1')))
    end

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3CPatrol3_D'.. Difficulty, 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P3CB2Airdefense1')))
    end
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3CPatrol1_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3CB1Navaldefense1')
    
    -- Call the AI
    UEFaiP3:P3UEFBase1AI()
    CybranaiP3:P3CybranBase1AI()
    CybranaiP3:P3CybranBase2AI()
    CybranaiP3:P3CybranBase3AI()

    --These two base are destroyed if player chose UEF to focus
    ScenarioUtils.CreateArmyGroup('UEF', 'P3UBase2', true)
    ScenarioUtils.CreateArmyGroup('UEF', 'P3UBase3', true)

    -- Expand the necessary areas 
    ScenarioFramework.SetPlayableArea('M3_Zone', true)
    
    ScenarioUtils.CreateArmyGroup('UEF', 'P3UWalls')
    ScenarioUtils.CreateArmyGroup('Cybran', 'P3CWalls')
     
    Cinematics.EnterNISMode()
    WaitSeconds(1)
    
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UNisUnits1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UNisUnits2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack1')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3NisUnits1', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack2')
    
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('Cybran', 'P3NisUnits2', 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3NISattack2')
    
    local VisMarker3_1 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision1', 0, ArmyBrains[Player1])
    local VisMarker3_3 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision2', 0, ArmyBrains[Player1])
    local VisMarker3_2 = ScenarioFramework.CreateVisibleAreaLocation(80, 'P3Vision3', 0, ArmyBrains[Player1])

    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam1'), 2)
    ScenarioFramework.Dialogue(OpStrings.M3_IntroCybran_Dialogue, nil, true)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam2'), 2)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam3'), 3)
    WaitSeconds(2)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam4'), 2)
    ScenarioFramework.Dialogue(OpStrings.M3_Intro_Dialogue2, nil, true)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam5'), 3)
    WaitSeconds(3)
    VisMarker3_1:Destroy()
    VisMarker3_2:Destroy()
    VisMarker3_3:Destroy()
    Cinematics.ExitNISMode()
    -- End Cutscene
    
    ForkThread(M3UnlockT2Land)
    ForkThread(PrimaryObjective)
    
    ArmyBrains[UEF]:GiveResource('MASS', 10000)
    ArmyBrains[UEF]:GiveResource('ENERGY', 60000)

    ArmyBrains[Cybran]:GiveResource('MASS', 10000)
    ArmyBrains[Cybran]:GiveResource('ENERGY', 60000)
    
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
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(Cybran):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end   
end

function UEFNISattacks()
   
    if ScenarioInfo.MissionNumber == 3 or ScenarioInfo.MissionNumber == 4 then
        return
    end
    ScenarioInfo.MissionNumber = 3

    if ScenarioInfo.M2P2.Active then
    ScenarioInfo.M2P2:ManualResult(false)
    end

    if ScenarioInfo.M3P2.Active then
    ScenarioInfo.M3P2:ManualResult(false)
    end

   --Spawn starting attacks and send at player base, to rough them up a bit
   
   ScenarioInfo.M3CounterAttackUnits = {}

    local quantity = {}
    local trigger = {}
    local platoon

    local function AddUnitsToObjTable(platoon)
        for _, v in platoon:GetPlatoonUnits() do
            if not EntityCategoryContains(categories.TRANSPORTATION + categories.SCOUT + categories.SHIELD, v) then
                table.insert(ScenarioInfo.M3CounterAttackUnits, v)
            end
        end
    end

    -- Frigates
    for i = 1, 2 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P3UAssaultDes' .. i .. '_D' .. Difficulty, 'AttackFormation', Difficulty)
        platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('M3_Destroyer_Entry_' .. i), false)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P3UAssaultPath' .. i)
        AddUnitsToObjTable(platoon)
    end
    
    local extractors = ScenarioFramework.GetListOfHumanUnits(categories.MASSEXTRACTION)
    local num = table.getn(extractors)
    quantity = {3, 6, 8}
    if num > 0 then
        if ScenarioFramework.GetNumOfHumanUnits(categories.ALLUNITS - categories.WALL) < 500 then
            if num > quantity[Difficulty] then
                num = quantity[Difficulty]
            end
        else
            quantity = {6, 8, 10}
            if num > quantity[Difficulty] then
                num = quantity[Difficulty]
            end
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UAssaultGunship', 'GrowthFormation')
            IssueAttack(platoon:GetPlatoonUnits(), extractors[i])
            IssueAggressiveMove(platoon:GetPlatoonUnits(), ScenarioUtils.MarkerToPosition('Player1'))
            AddUnitsToObjTable(platoon)

        end
    end

    -- sends swift winds if player has more than [60, 50, 40] planes, up to 12, 1 group per 10, 8, 6
    num = ScenarioFramework.GetNumOfHumanUnits(categories.AIR * categories.MOBILE)
    quantity = {60, 50, 40}
    trigger = {10, 8, 6}
    if num > quantity[Difficulty] then
        num = math.ceil(num/trigger[Difficulty])
        if(num > 12) then
            num = 12
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P3UAssaultFighter_D' .. Difficulty, 'GrowthFormation', 5)
            ScenarioFramework.PlatoonPatrolChain(platoon, 'P3UAssaultPath' .. Random(1, 4))
            AddUnitsToObjTable(platoon)
        end
    end

    -- sends torpedo bombers if player has more than [55, 50, 40] T1 naval, up to 6, 6, 8 groups
    local T2Naval = ScenarioFramework.GetListOfHumanUnits(categories.NAVAL * categories.MOBILE)
    num = table.getn(T2Naval)
    quantity = {6, 6, 8}
    trigger = {55, 50, 40}
    if num > trigger[Difficulty] then
        if num > quantity[Difficulty] then
            num = quantity[Difficulty]
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P3UAssaultTorp', 'GrowthFormation', 5)
            IssueAttack(platoon:GetPlatoonUnits(), T2Naval[i])
            IssueAggressiveMove(platoon:GetPlatoonUnits(), ScenarioUtils.MarkerToPosition('Player1'))
            ScenarioFramework.PlatoonPatrolChain(platoon, 'P3UAssaultPath' .. Random(1, 4))
            AddUnitsToObjTable(platoon)
        end
    end

    for i = 1, 3 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3UDropattack' .. i .. '_D' .. Difficulty, 'AttackFormation')
        ScenarioFramework.PlatoonAttackWithTransports(platoon, 'P3UDrop' .. i, 'P3UDropattack3', true)
        AddUnitsToObjTable(platoon)
    end


    --------------------------------------------
    -- Primary Objective - Defeat Counter Attack
    --------------------------------------------
    ScenarioInfo.M3P1 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        'Defeat UEF counter attack',
        'UEF Commander is throwing a large assault against you, stop it in its tracks.',
        {
            Units = ScenarioInfo.M3CounterAttackUnits,
            MarkUnits = false,
        }
    )
    ScenarioInfo.M3P1:AddResultCallback(
        function(result)
            if result then
            ScenarioFramework.Dialogue(OpStrings.M3_Assault_DialogueEnd, M3NISIntroCybran, true)
            end
        end
    )
end

function CybranNISattacks()
   
    if ScenarioInfo.MissionNumber == 3 or ScenarioInfo.MissionNumber == 4 then
        return
    end
    ScenarioInfo.MissionNumber = 3

    if ScenarioInfo.M2P2.Active then
    ScenarioInfo.M2P2:ManualResult(false)
    end

    if ScenarioInfo.M3P2.Active then
    ScenarioInfo.M3P2:ManualResult(false)
    end

   --Spawn starting attacks and send at player base, to rough them up a bit
   
   ScenarioInfo.M3CounterAttackUnits = {}

    local quantity = {}
    local trigger = {}
    local platoon

    local function AddUnitsToObjTable(platoon)
        for _, v in platoon:GetPlatoonUnits() do
            if not EntityCategoryContains(categories.TRANSPORTATION + categories.SCOUT + categories.SHIELD, v) then
                table.insert(ScenarioInfo.M3CounterAttackUnits, v)
            end
        end
    end

    -- Frigates
    for i = 1, 3 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Cybran', 'P3CAssaultDes' .. i .. '_D' .. Difficulty, 'AttackFormation', Difficulty)
        platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('M3C_Destroyer_Entry_' .. i), false)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'P3CAssaultPath' .. i)
        AddUnitsToObjTable(platoon)
    end
    
    -- sends gunships if player has more than [800, 700, 500] units, up to 12, 1 group per 10, 8, 6
    num = ScenarioFramework.GetNumOfHumanUnits(categories.ALLUNITS * categories.MOBILE - categories.ENGINEER)
    quantity = {800, 700, 500}
    trigger = {50, 40, 30}
    if num > quantity[Difficulty] then
        num = math.ceil(num/trigger[Difficulty])
        if(num > 12) then
            num = 12
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Cybran', 'P3CAssaultGunships_D' .. Difficulty, 'GrowthFormation', 5)
            ScenarioFramework.PlatoonPatrolChain(platoon, 'P3CAssaultPath' .. Random(1, 5))
            AddUnitsToObjTable(platoon)
        end
    end

    -- sends swift winds if player has more than [60, 50, 40] planes, up to 12, 1 group per 10, 8, 6
    num = ScenarioFramework.GetNumOfHumanUnits(categories.AIR * categories.MOBILE)
    quantity = {60, 50, 40}
    trigger = {10, 8, 6}
    if num > quantity[Difficulty] then
        num = math.ceil(num/trigger[Difficulty])
        if(num > 12) then
            num = 12
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Cybran', 'P3CAssaultFighters_D' .. Difficulty, 'GrowthFormation', 5)
            ScenarioFramework.PlatoonPatrolChain(platoon, 'P3CAssaultPath' .. Random(1, 5))
            AddUnitsToObjTable(platoon)
        end
    end

    -- sends torpedo bombers if player has more than [55, 50, 40] T1 naval, up to 6, 6, 8 groups
    local T2Naval = ScenarioFramework.GetListOfHumanUnits(categories.NAVAL * categories.MOBILE)
    num = table.getn(T2Naval)
    quantity = {6, 6, 8}
    trigger = {55, 50, 40}
    if num > trigger[Difficulty] then
        if num > quantity[Difficulty] then
            num = quantity[Difficulty]
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Cybran', 'P3CAssaultTorps', 'GrowthFormation', 5)
            IssueAttack(platoon:GetPlatoonUnits(), T2Naval[i])
            IssueAggressiveMove(platoon:GetPlatoonUnits(), ScenarioUtils.MarkerToPosition('Player1'))
            ScenarioFramework.PlatoonPatrolChain(platoon, 'P3CAssaultPath' .. Random(1, 5))
            AddUnitsToObjTable(platoon)
        end
    end

    --------------------------------------------
    -- Primary Objective - Defeat Counter Attack
    --------------------------------------------
    ScenarioInfo.M3P1 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        'Defeat Cybran counter attack',
        'Cybran Commander is throwing a large assault against you, stop it in its tracks.',
        {
            Units = ScenarioInfo.M3CounterAttackUnits,
            MarkUnits = true,
        }
    )
    ScenarioInfo.M3P1:AddResultCallback(
        function(result)
            if result then
            ScenarioFramework.Dialogue(OpStrings.M3_Assault_DialogueEnd, M3NISIntroUEF, true)
            end
        end
    )
end

function PrimaryObjective()
    
    ScenarioInfo.M1P3 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        'Kill The UEF Commander',
        'Kill the UEF Commander to secure this Planet.',
        {
            MarkUnits = true,
            Units = {ScenarioInfo.UEFCommander}
        }
    )
    ScenarioInfo.M1P3:AddResultCallback(
        function(result)
            if (result) then
                if ScenarioInfo.M2P3.Active then
                    ForkThread(UEFCommanderKilled)
                else
                    ForkThread(PlayerWin)
                end
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P3) 

    ScenarioInfo.M2P3 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        'Kill The Cybran Commander',
        'Kill the Cybran Commander to secure this Planet.',
        {
            MarkUnits = true,
            Units = {ScenarioInfo.CybranCommander}
        }
    )
    ScenarioInfo.M2P3:AddResultCallback(
        function(result)
            if (result) then
                if ScenarioInfo.M1P3.Active then
                    ForkThread(CybranCommanderKilled)
                else
                    ForkThread(PlayerWin)
                end
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P3) 
    
    --Trigger Mission when player spots T3 arty location
    ScenarioUtils.CreateArmyGroup('NomadsEnemy', 'ResearchBase')
    ScenarioInfo.LCenter = ScenarioUtils.CreateArmyUnit('NomadsEnemy', 'Rcenter')
    ScenarioFramework.CreateArmyIntelTrigger(SecondaryObjective, ArmyBrains[Player1], 'LOSNow', false, true, categories.xnb4205, true, ArmyBrains[NomadsEnemy]) 
end

function SecondaryObjective()
    
    ScenarioFramework.Dialogue(OpStrings.M3_ListeningPost, nil, true)

    ScenarioInfo.M4P3 = Objectives.KillOrCapture(
        'secondary',
        'incomplete',
        'Destroy or Capture Nomad Listening Post',
        'A different Nomad Fleet has a hidden listening post on planet.',
        {
            MarkUnits = true,
            Units = {ScenarioInfo.LCenter}
        }
    )
    ScenarioInfo.M1P3:AddResultCallback(
        function(result)
            if (result) then
            ScenarioFramework.Dialogue(OpStrings.M3_ListeningPostEnd, nil, true)    
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M4P3) 
end

function M3UnlockT2Land()
    
    WaitSeconds(60)
    ScenarioFramework.Dialogue(OpStrings.M3_TechIntel, nil, true)
    
    ScenarioFramework.PlayUnlockDialogue()
        
    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P3Reinforements_D' .. Difficulty, 'AttackFormation')
            ScenarioFramework.PlatoonMoveChain(units, 'P2NomadRchain')
        
            WaitSeconds(20)
        
            for k, v in units:GetPlatoonUnits() do
                if (v and not v:IsDead()) then
                    ScenarioFramework.GiveUnitToArmy(v, 'Player1')
                end
            end

    -- Destroyer
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0203)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.znb9503)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xns0201)
    --Defense structures
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2301)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2202)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb2207)
end

function UEFCommanderKilled()

    ScenarioFramework.Dialogue(OpStrings.M3_UEFDeath, nil, true)
    ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.UEFCommander, 3)  
end

function CybranCommanderKilled()

    ScenarioFramework.Dialogue(OpStrings.M3_CybranDeath, nil, true)
    ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.CybranCommander, 3)
end

-- Utility Functions
function PlayerDeath(Commander)
    ScenarioFramework.PlayerDeath(Commander, OpStrings.PlayerDies1)
end

function DestroyUnit(unit)

    unit:Destroy()
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

-- Taunts
function UEFTaunts()
    if(not ScenarioInfo.OpEnded) then
    UEFTM:AddUnitsKilledTaunt('TAUNT1', ArmyBrains[Player1], categories.MOBILE, 60)
    UEFTM:AddUnitsKilledTaunt('TAUNT2', ArmyBrains[Player1], categories.ALLUNITS, 95)
    UEFTM:AddUnitsKilledTaunt('TAUNT4', ArmyBrains[Player1], categories.MOBILE, 120)
    UEFTM:AddUnitsKilledTaunt('TAUNT5', ArmyBrains[Player1], categories.STRUCTURE, 8)
    UEFTM:AddUnitsKilledTaunt('TAUNT6', ArmyBrains[Player1], categories.STRUCTURE, 16)  
    UEFTM:AddUnitsKilledTaunt('TAUNT4', ArmyBrains[Player1], categories.MOBILE, 180)
    UEFTM:AddUnitsKilledTaunt('TAUNT1', ArmyBrains[Player1], categories.MOBILE, 200)
    UEFTM:AddUnitsKilledTaunt('TAUNT5', ArmyBrains[Player1], categories.STRUCTURE, 26)  
    end
end

