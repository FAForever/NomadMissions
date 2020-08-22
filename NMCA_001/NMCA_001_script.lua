--****************************************************************************
--**
--**  File     :  /maps/NMCA_001/NMCA_001_script.lua
--**  Author(s):  JJ173, Tokyto_, speed2, Exotic_Retard, zesty_lime, biass, Shadowlorda1, and Wise Old Dog (AKA The 'Mad Men)
--**
--**  Summary  :  Ths script for the first mission of the Nomads campaign.
--**
--****************************************************************************

local Buff = import('/lua/sim/Buff.lua')
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
local P1UEFBases = import('/maps/NMCA_001/NMCA_001_M1_AI.lua')
local P2UEFBases = import('/maps/NMCA_001/NMCA_001_M2_AI.lua')
local P3UEFBases = import('/maps/NMCA_001/NMCA_001_M3_AI.lua')


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

local Spotted = false
local PlayerLost = false
local FactoryCaptured = false

local AssignedObjectives = {}

local MassAmount = {6000, 4000, 2000}
local PowerAmount = {40000, 30000, 20000}

-- Timed Expansions
local M1ExpansionTime = {24 * 60, 20 * 60, 16 * 60}
local M2ExpansionTime = {30 * 60, 25 * 60, 20 * 60}

----------------
-- Taunt Managers
----------------
local M1UEFTM = TauntManager.CreateTauntManager('M1UEFTM', '/maps/NMCA_001/NMCA_001_strings.lua')

function OnPopulate()
    ScenarioUtils.InitializeScenarioArmies()
    ScenarioFramework.SetPlayableArea('AREA_1', false)

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

    --- decreases time factories wait to produce next platoon
    ArmyBrains[UEF]:PBMSetCheckInterval(10)

    ----------
    -- Unit Cap
    ----------
    ScenarioFramework.SetSharedUnitCap(1000)
    SetArmyUnitCap(UEF, 1000)
end
  
function OnStart(self)
    ----------
    -- Restrictions
    ----------
    ScenarioFramework.AddRestrictionForAllHumans(categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL)
    ScenarioFramework.AddRestrictionForAllHumans(categories.xna0103) -- Attack Bomber
    ScenarioFramework.AddRestrictionForAllHumans(categories.uel0105) -- UEF Engineer
    ScenarioFramework.AddRestrictionForAllHumans(categories.xna0107) -- Transport Drone
    ScenarioFramework.AddRestrictionForAllHumans(categories.xna0105) -- Light Gunship
    ScenarioFramework.AddRestrictionForAllHumans(categories.xnl0107) -- Tank Destroyer
    ScenarioFramework.AddRestrictionForAllHumans(categories.NAVAL) -- Navy

    ----------
    -- Spawn Things
    ----------
    ScenarioUtils.CreateArmyGroup('Player1', 'P1Storage_D'.. Difficulty)
    ScenarioInfo.Ship = ScenarioUtils.CreateArmyUnit('Nomads', 'Ship')
    ScenarioFramework.CreateUnitDeathTrigger(PlayerLose, ScenarioInfo.Ship)

    ScenarioInfo.Ship:SetCustomName('Command Ship')
    ScenarioInfo.Ship:SetCanBeKilled(false)
    ScenarioInfo.Ship:SetReclaimable(false)

    ScenarioInfo.Engineer1 = ScenarioUtils.CreateArmyGroup('Player1', 'P1P1Engis_D' .. Difficulty)
    
    local platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Player1', 'P1PUnits_D' .. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'P1PlayerPatrol')

    P1UEFBases.UEFBase1AI()
    P1UEFBases.UEFBase2AI()
    P1UEFBases.UEFBase3AI()

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P1Patrol', 'GrowthFormation')
    for k, v in units:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P1Masspatrol2')))
    end

    ScenarioUtils.CreateArmyGroup('UEF', 'P1Walls')
    ScenarioUtils.CreateArmyGroup('UEF', 'P1Mexs')
    ScenarioUtils.CreateArmyGroup('Civilian', 'P1Wreaks', true)

    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(UEF):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end  

    ----------
    -- Cinematics
    ----------
    ForkThread(M1NIS)
end

function PlayerWin()
    if(not ScenarioInfo.OpEnded) then
        ScenarioInfo.OpComplete = true

        WaitSeconds(1)
        ScenarioInfo.Ship:TakeOff()
        WaitSeconds(3)
        ScenarioInfo.Ship:StartRotators()

        KillGame()
    end
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

    ForkThread(
                    function()
                        WaitSeconds(1)
                        ScenarioInfo.Ship:TakeOff()
                        WaitSeconds(3)
                        ScenarioInfo.Ship:StartRotators()
                    end
                )

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

--M1 Functions

function M1NIS()

    ScenarioInfo.MissionNumber = 1

    ScenarioFramework.CreateUnitDamagedTrigger(PlayerLose, ScenarioInfo.Ship, .75)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam1'), 0)
    for _, player in ScenarioInfo.HumanPlayers do
        ArmyBrains[player]:GiveResource('MASS', MassAmount[Difficulty])
        ArmyBrains[player]:GiveResource('ENERGY', PowerAmount[Difficulty])
    end

    Cinematics.EnterNISMode()
    ScenarioFramework.Dialogue(OpStrings.IntroNIS_Dialogue, M1_Objectives, true)
    
    WaitSeconds(5)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam2'), 6)
    WaitSeconds(7)
    local VisMarker1_1 = ScenarioFramework.CreateVisibleAreaLocation(40, 'P1Vision1', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam3'), 4)
    WaitSeconds(4)
    local VisMarker1_2 = ScenarioFramework.CreateVisibleAreaLocation(40, 'P1Vision2', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam4'), 4)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Camstart'), 0)
    VisMarker1_1:Destroy()
    VisMarker1_2:Destroy()

    Cinematics.ExitNISMode()

    if (table.getsize(ScenarioInfo.HumanPlayers) == 2) then
        ScenarioUtils.CreateArmyGroup('Player2', 'Engineers')
    elseif(table.getsize(ScenarioInfo.HumanPlayers) == 3) then
        ScenarioUtils.CreateArmyGroup('Player2', 'Engineers')
        ScenarioUtils.CreateArmyGroup('Player3', 'Engineers')
    elseif(table.getsize(ScenarioInfo.HumanPlayers) == 4) then
        ScenarioUtils.CreateArmyGroup('Player2', 'Engineers')
        ScenarioUtils.CreateArmyGroup('Player3', 'Engineers')
        ScenarioUtils.CreateArmyGroup('Player4', 'Engineers')
    end
end

function M1_Objectives()

    local function MissionNameAnnouncement()
        ScenarioFramework.SimAnnouncement(ScenarioInfo.name, "Mission by The 'Mad Men")
    end

    ScenarioFramework.CreateTimerTrigger(MissionNameAnnouncement, 7)

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

    ScenarioInfo.M1P2 = Objectives.CategoriesInArea(
        'primary',
        'incomplete',
        OpStrings.M1P2Text,
        OpStrings.M1P2Desc,
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
            },
        }
    )
    ScenarioInfo.M1P2:AddResultCallback(
        function(result)
            if (result) then
            ScenarioFramework.Dialogue(OpStrings.UEFOutpost_Dead, M2NIS, true)    
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1P2)

    ScenarioInfo.M1S2 = Objectives.ArmyStatCompare(
            'secondary',
            'incomplete',
            OpStrings.M1S1Text,
            OpStrings.M1S1Desc,
            'build',
            {
                ShowProgress = true,
                Army = ScenarioInfo.Player1,
                StatName = 'Units_Active',
                CompareOp = '>=',
                Value = 4,
                ShowProgress = true,
                Category = categories.xnb1103,
            }
        )
        ScenarioInfo.M1S2:AddResultCallback(
            function(result)
                if result then
                end
            end
        )
    table.insert(AssignedObjectives, ScenarioInfo.M1S1)

    ScenarioFramework.CreateArmyIntelTrigger(P1SecondaryObj2, ArmyBrains[Player1], 'LOSNow', false, true,  categories.ueb1104, true, ArmyBrains[UEF] )
    WaitSeconds(10)
    ScenarioFramework.Dialogue(OpStrings.M1UnlockAirTech, M1UnlockAirTechForAllHumans, true)

    -- Expand to next part of the mission.
    if TimedExapansion then
        ScenarioFramework.CreateTimerTrigger(M2NIS, M1ExpansionTime[Difficulty])
    end
end

function P1SecondaryObj2()

    ScenarioInfo.M1S1 = Objectives.CategoriesInArea(
        'secondary',
        'incomplete',
        OpStrings.M1S2Text,
        OpStrings.M1S2Desc,
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P1SecOBJ1',
                    Category = categories.FACTORY + categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
                {   
                    Area = 'P1SecOBJ2',
                    Category = categories.FACTORY + categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
            },
        }
    )
    ScenarioInfo.M1S1:AddResultCallback(
        function(result)
            if (result) then
                
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M1S1)
end

function M1UnlockAirTechForAllHumans()
    ScenarioFramework.PlayUnlockDialogue()
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0103)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0107)
end

--M2 Functions

function M2NIS()

    if ScenarioInfo.MissionNumber == 2 or ScenarioInfo.MissionNumber == 3 then
        return
    end
    ScenarioInfo.MissionNumber = 2

    -- Expand the necessary areas 
    ScenarioFramework.SetPlayableArea('AREA_2', true)

    P2UEFBases.UEFP2Base1AI()
    P2UEFBases.UEFP2Base2AI()
    P2UEFBases.UEFP2Base3AI()

    ScenarioUtils.CreateArmyGroup('UEF', 'P2Walls')
    ScenarioUtils.CreateArmyGroup('UEF', 'P2Defenses_D'.. Difficulty)
    ScenarioUtils.CreateArmyGroup('Civilian', 'P2City2Wreak', true)
    ScenarioUtils.CreateArmyGroup('Civilian', 'P2City1')
    ScenarioUtils.CreateArmyGroup('Civilian', 'P2City2')

    ScenarioInfo.Researchlab = ScenarioUtils.CreateArmyUnit('UEF', 'ResearchLab')
    ScenarioInfo.Researchlab:SetCanBeKilled(false)
    ScenarioInfo.Researchlab:SetReclaimable(false)

    Cinematics.EnterNISMode()

    local units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2Landattack2_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2Intattack2')

    local VisMarker2_1 = ScenarioFramework.CreateVisibleAreaLocation(50, 'P2Vision1', 0, ArmyBrains[Player1])
    local VisMarker2_2 = ScenarioFramework.CreateVisibleAreaLocation(50, 'P2Vision2', 0, ArmyBrains[Player1])
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam1'), 4)
    ScenarioFramework.Dialogue(OpStrings.M2_Update_Commander, nil, true)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam2'), 4)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam3'), 4)
    WaitSeconds(3)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P2Cam4'), 3)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Camstart'), 0)

    VisMarker2_1:Destroy()
    VisMarker2_2:Destroy()

    ForkThread(P2Intattacks)

    Cinematics.ExitNISMode()

    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(UEF):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end

    ForkThread(M2Objectives)
end

function P2Intattacks()

    -- If player > 100 units, spawns Bombers for every 15 land units, up to 6 groups
    local num = ScenarioFramework.GetNumOfHumanUnits(categories.ALLUNITS - categories.WALL, false)
    
    if(num > 100) then
        local num = ScenarioFramework.GetNumOfHumanUnits((categories.LAND * categories.MOBILE) - categories.CONSTRUCTION, false)

        if(num > 0) then
            num = math.ceil(num/15)
            if(num > 6) then
                num = 6
            end
            for i = 1, num do
                units = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2AirattackAdapt1', 'GrowthFormation', 5)
                ScenarioFramework.PlatoonPatrolChain(units, 'P2Intattack' .. Random(1,5))
            end
        end
    end

    -- If player > 100 units, spawns Pillars for every 50 land units, up to 3 groups
    local num = ScenarioFramework.GetNumOfHumanUnits(categories.ALLUNITS - categories.WALL, false)
    
    if(num > 200) then
        local num = ScenarioFramework.GetNumOfHumanUnits((categories.LAND * categories.MOBILE) - categories.CONSTRUCTION, false)

        if(num > 0) then
            num = math.ceil(num/50)
            if(num > 3) then
                num = 3
            end
            for i = 1, num do
                units = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2LandattackAdapt1', 'GrowthFormation', 1)
                ScenarioFramework.PlatoonPatrolChain(units, 'P2Intattack' .. Random(1,5))
            end
        end
    end

    -- Spawns Interceptors for every 10 Air units, up to 8 groups
    local num = ScenarioFramework.GetNumOfHumanUnits(categories.AIR * categories.MOBILE, false)

    if(num > 0) then
        num = math.ceil(num/10)
        if(num > 8) then
            num = 8
        end
        for i = 1, num do
            units = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2AirattackAdapt2', 'GrowthFormation', 5)
            ScenarioFramework.PlatoonPatrolChain(units, 'P2Intattack' .. Random(1,5))
        end
    end
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2Landattack1_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2Intattack1')

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P2Landattack3_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P2Intattack3')

    local platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P2Airattack1_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        for k, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P2Intattackpatrol')))
        end
end

function M2Objectives()

    ScenarioInfo.M2P1 = Objectives.Capture(
        'primary',
        'incomplete',
        OpStrings.M2P1Text,
        OpStrings.M2P1Desc,
        {                               
             Units = {ScenarioInfo.Researchlab},
        }
    )
    ScenarioInfo.M2P1:AddResultCallback(
        function(result)
            if (result) then
            ScenarioFramework.Dialogue(OpStrings.M2TechCaptured, M3NIS, true)
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M2P1)

    ScenarioFramework.CreateArmyIntelTrigger(M2SecObjectives, ArmyBrains[Player1], 'LOSNow', false, true,  categories.uel0202, true, ArmyBrains[UEF] )

    if TimedExapansion then
        ScenarioFramework.CreateTimerTrigger(M3NIS, M2ExpansionTime[Difficulty])
    end
end

function M2SecObjectives()

    ScenarioFramework.PlayUnlockDialogue()
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnl0107)

    ScenarioInfo.M2S1 = Objectives.CategoriesInArea(
        'secondary',
        'incomplete',
        OpStrings.M2S1Text,
        OpStrings.M2S1Desc,
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P2SecOBJ1',
                    Category = categories.FACTORY + categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = UEF,
                },
                {   
                    Area = 'P2SecOBJ2',
                    Category = categories.FACTORY + categories.ECONOMIC,
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

function P3Intattacks()

    -- If player > 100 units, spawns Bombers for every 20 land units, up to 8 groups
    local num = ScenarioFramework.GetNumOfHumanUnits(categories.ALLUNITS - categories.WALL, false)
    
    if(num > 100) then
        local num = ScenarioFramework.GetNumOfHumanUnits((categories.LAND * categories.MOBILE) - categories.CONSTRUCTION, false)

        if(num > 0) then
            num = math.ceil(num/20)
            if(num > 8) then
                num = 8
            end
            for i = 1, num do
                units = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P3Airattack1', 'GrowthFormation', 5)
                ScenarioFramework.PlatoonPatrolChain(units, 'P3IntAirattack' .. Random(1,4))
            end
        end
    end

    -- Spawns Interceptors for every 10 Air units, up to 6 groups
    local num = ScenarioFramework.GetNumOfHumanUnits(categories.AIR * categories.MOBILE, false)

    if(num > 0) then
        num = math.ceil(num/10)
        if(num > 8) then
            num = 8
        end
        for i = 1, num do
            units = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('UEF', 'P3Airattack2', 'GrowthFormation', 5)
            ScenarioFramework.PlatoonPatrolChain(units, 'P3IntAirattack' .. Random(1,4))
        end
    end
    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3Landattack1_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3Intlandattack1')

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3Landattack2_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3Intlandattack2')

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3Landattack3_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3Intlandattack3')

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3Landattack4_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3Intlandattack4')

    units = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3Navalattack1_D'.. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(units, 'P3B5Navalattack2')

    local extractors = ScenarioFramework.GetListOfHumanUnits(categories.MASSEXTRACTION)
    local num = table.getn(extractors)
    quantity = {4, 6, 8}
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
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3Airattack4', 'GrowthFormation')
            IssueAttack(platoon:GetPlatoonUnits(), extractors[i])

        end
    end

    local Defenses = ScenarioFramework.GetListOfHumanUnits(categories.xnb2102)
    local num = table.getn(Defenses)
    quantity = {5, 7, 10}
    if num > 0 then
        if ScenarioFramework.GetNumOfHumanUnits(categories.ALLUNITS - categories.WALL) < 500 then
            if num > quantity[Difficulty] then
                num = quantity[Difficulty]
            end
        else
            quantity = {5, 10, 15}
            if num > quantity[Difficulty] then
                num = quantity[Difficulty]
            end
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('UEF', 'P3Airattack3', 'GrowthFormation')
            IssueAttack(platoon:GetPlatoonUnits(), Defenses[i])

        end
    end
end

--M3 Functions

function M3NIS()

    if ScenarioInfo.MissionNumber == 3 then
        return
    end
    ScenarioInfo.MissionNumber = 3

    ScenarioFramework.SetPlayableArea('AREA_3', true)

    P3UEFBases.UEFP3Base1AI()
    P3UEFBases.UEFP3Base2AI()
    P3UEFBases.UEFP3Base3AI()
    P3UEFBases.UEFP3Base4AI()
    P3UEFBases.UEFP3Base5AI()

    ScenarioUtils.CreateArmyGroup('UEF', 'P3Walls')

    ScenarioInfo.UEFCommander = ScenarioFramework.SpawnCommander('UEF', 'P3ACU1', false, 'CDR Parker', true, false,
    {'HeavyAntiMatterCannon', 'AdvancedEngineering', 'Teleporter'})
    ScenarioInfo.UEFCommander:SetAutoOvercharge(true)
    ScenarioFramework.CreateUnitDamagedTrigger(ParkerDamaged, ScenarioInfo.UEFCommander, .5)
        
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

    for _, u in GetArmyBrain(UEF):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
        Buff.ApplyBuff(u, 'CheatIncome')
    end  

        ----------
        -- Cinematics
        ----------
        local VisMarker3_1 = ScenarioFramework.CreateVisibleAreaLocation(70, 'P3Vision1', 0, ArmyBrains[Player1])
        local VisMarker3_2 = ScenarioFramework.CreateVisibleAreaLocation(70, 'P3Vision2', 0, ArmyBrains[Player1])
        local VisMarker3_3 = ScenarioFramework.CreateVisibleAreaLocation(70, 'P3Vision3', 0, ArmyBrains[Player1])
        local VisMarker3_4 = ScenarioFramework.CreateVisibleAreaLocation(70, 'P3Vision4', 0, ArmyBrains[Player1])

        Cinematics.EnterNISMode()

        Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam1'), 4)
        WaitSeconds(3)

        Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam2'), 4)
        WaitSeconds(3)

        Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P3Cam3'), 4)
        WaitSeconds(3)
        ScenarioFramework.Dialogue(OpStrings.M3_Update_Commander, nil, true)
        Cinematics.CameraTrackEntity(ScenarioInfo.UEFCommander, 40, 2)
        WaitSeconds(2)
        Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Camstart'), 0)

        VisMarker3_1:Destroy()
        VisMarker3_2:Destroy()
        VisMarker3_3:Destroy()
        VisMarker3_4:Destroy()

        Cinematics.ExitNISMode()

        ForkThread(P3Intattacks)
        ForkThread(P3Objectives)
end

function P3Objectives()

    ScenarioInfo.M3P1 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        OpStrings.M3P1Text,
        OpStrings.M3P1Desc,
        {                               
             Units = {ScenarioInfo.UEFCommander},
        }
    )
    ScenarioInfo.M3P1:AddResultCallback(
        function(result)
            if (result) then
            UEFCommanderKilled()       
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3P1)

    ScenarioFramework.CreateArmyIntelTrigger(P3SecObjective, ArmyBrains[Player1], 'LOSNow', false, true,  categories.ues0103, true, ArmyBrains[UEF] )
end

function P3SecObjective()

    ScenarioFramework.PlayUnlockDialogue()
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xna0105)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xns0203)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xns0103)
    ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb0103)

    ScenarioInfo.M3S1 = Objectives.CategoriesInArea(
        'secondary',
        'incomplete',
        OpStrings.M3S1Text,
        OpStrings.M3S1Desc,
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
            Requirements = {
                {   
                    Area = 'P3SecOBJ1',
                    Category = categories.FACTORY + categories.ECONOMIC,
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
                
            end
        end
    )
    table.insert(AssignedObjectives, ScenarioInfo.M3S1)
end

function ParkerDamaged()
    if ScenarioFramework.NumCatUnitsInArea(categories.STRUCTURE - categories.WALL, 'P3Base2', ArmyBrains[UEF]) > 10 then
        ForkThread(TeleportB4)
    elseif ScenarioFramework.NumCatUnitsInArea(categories.STRUCTURE - categories.WALL, 'P3Base4', ArmyBrains[UEF]) > 10 then
        ForkThread(TeleportB2)
    else
        ForkThread(TeleportB3)
    end
end

function TeleportB2()
    ScenarioInfo.UEFCommander:SetCanTakeDamage(false)
    ScenarioFramework.Dialogue(OpStrings.TAUNT4, nil, true)
    ScenarioFramework.FakeTeleportUnit(ScenarioInfo.UEFCommander)
    Warp(ScenarioInfo.UEFCommander, ScenarioUtils.MarkerToPosition('P3TeleMK1'))
    ScenarioInfo.UEFCommander:SetCanTakeDamage(true)
    UpdateACUPlatoon('P3UEFBase2')
end

function ParkerDamaged2()
    ForkThread(TeleportB2)
end

function TeleportB4()
    ScenarioInfo.UEFCommander:SetCanTakeDamage(false)
    ScenarioFramework.FakeTeleportUnit(ScenarioInfo.UEFCommander)
     ScenarioFramework.Dialogue(OpStrings.TAUNT5, nil, true)
    Warp(ScenarioInfo.UEFCommander, ScenarioUtils.MarkerToPosition('P3TeleMK2'))
    ScenarioFramework.CreateUnitDamagedTrigger(ParkerDamaged2, ScenarioInfo.UEFCommander, .7)
    ScenarioInfo.UEFCommander:SetCanTakeDamage(true)
    UpdateACUPlatoon('P3UEFBase4')
end

function TeleportB3()
    ScenarioInfo.UEFCommander:SetCanTakeDamage(false)
    ScenarioFramework.FakeTeleportUnit(ScenarioInfo.UEFCommander)
     ScenarioFramework.Dialogue(OpStrings.TAUNT6, nil, true)
    Warp(ScenarioInfo.UEFCommander, ScenarioUtils.MarkerToPosition('P3TeleMK3'))
    ScenarioInfo.UEFCommander:SetCanTakeDamage(true)
    UpdateACUPlatoon('P3UEFBase3')
end

function UpdateACUPlatoon(location)
    local function FindACUPlatoon()
        for _, platoon in ArmyBrains[UEF]:GetPlatoonsList() do
            for _, unit in platoon:GetPlatoonUnits() do
                if unit == ScenarioInfo.UEFCommander then
                    return platoon
                end
            end
        end
        WARN('ACU Platoon Not Found')
    end
    local platoon = FindACUPlatoon()
    if location == 'None' then
        IssueClearCommands({ScenarioInfo.UEFCommander})
        LOG('Stopping CRD Platoon')
        platoon:StopAI()
        ArmyBrains[UEF]:DisbandPlatoon(platoon)
        return
    end
    LOG('Changing ACU platoon for location: ' .. location)
    LOG('Old PlatoonData: ', repr(platoon.PlatoonData))
    platoon:StopAI()
    platoon.PlatoonData = {
        BaseName = location,
        LocationType = location,
    }
    platoon:ForkAIThread(import('/lua/AI/OpAI/BaseManagerPlatoonThreads.lua').BaseManagerSingleEngineerPlatoon)
    LOG('New PlatoonData: ', repr(platoon.PlatoonData))
end

function UEFCommanderKilled()

    ScenarioFramework.Dialogue(OpStrings.EnemyDead, nil, true)
    ScenarioFramework.CDRDeathNISCamera(ScenarioInfo.UEFCommander, 5)
    PlayerWin()
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
