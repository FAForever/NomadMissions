------------------------------
-- Nomads Campaign - Mission 3
--
-- Author: speed2
------------------------------
local Buff = import('/lua/sim/Buff.lua')
local Cinematics = import('/lua/cinematics.lua')
local CustomFunctions = import('/maps/NMCA_003/NMCA_003_CustomFunctions.lua')
local Objectives = import('/lua/SimObjectives.lua')
local M1AeonAI = import('/maps/NMCA_003/NMCA_003_M1AeonAI.lua')
local M2AeonAI = import('/maps/NMCA_003/NMCA_003_M2AeonAI.lua')
local M3AeonAI = import('/maps/NMCA_003/NMCA_003_M3AeonAI.lua')
local M4AeonAI = import('/maps/NMCA_003/NMCA_003_M4AeonAI.lua')
local OpStrings = import('/maps/NMCA_003/NMCA_003_strings.lua')
local PingGroups = import('/lua/ScenarioFramework.lua').PingGroups
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TauntManager = import('/lua/TauntManager.lua')
local Weather = import('/lua/weather.lua')
   
----------
-- Globals
----------
ScenarioInfo.Player1 = 1
ScenarioInfo.Aeon = 2
ScenarioInfo.Crashed_Ship = 3
ScenarioInfo.Aeon_Neutral = 4
ScenarioInfo.Crystals = 5
ScenarioInfo.Player2 = 6
ScenarioInfo.Player3 = 7

ScenarioInfo.OperationScenarios = {
    M1 = {
        Events = {
            {
                CallFunction = function() M1AirAttack() end,
            },
            --{
            --    CallFunction = function() M1LandAttack() end,
            --},
            {
                CallFunction = function() M1NavalAttack() end,
            },
        },
    },
    M2 = {
        Bases = {
            {
                CallFunction = function(location)
                    M2AeonAI.AeonM2NorthBaseAI(location)
                end,
                Types = {'WestNaval', 'SouthNaval'},
            },
            {
                CallFunction = function(location)
                    M2AeonAI.AeonM2SouthBaseAI(location)
                end,
                Types = {'NorthNaval', 'SouthNaval'},
            },
        },
    },
    M3 = {
        Events = {
            {
                CallFunction = function() M3AeonAI.M3sACUMainBase() end,
                Delay = 180,
            },
            {
                CallFunction = function() M3sACUM2Northbase() end,
                Delay = 180,
            },
        },
    },
    M4 = {
        Bases = {
            {
                CallFunction = function(location)
                    ForkThread(M4TMLOutpost, location)
                end,
                Types = {'North', 'Centre', 'South', 'None'}
            },
        },
    },
}

---------
-- Locals
---------
local Crystals = ScenarioInfo.Crystals
local Aeon = ScenarioInfo.Aeon
local Aeon_Neutral = ScenarioInfo.Aeon_Neutral
local Crashed_Ship = ScenarioInfo.Crashed_Ship
local Player1 = ScenarioInfo.Player1
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3

local Difficulty = ScenarioInfo.Options.Difficulty

local LeaderFaction
local LocalFaction

-- Max HP the ship can be regenerated to, increased by reclaiming the crystals
local ShipMaxHP = 3000
local CrystalBonuses = {
    { -- Crystal 1
        maxHP = 6480,
        addHP = 2500,
    },
    { -- Crystal 2
        maxHP = 9220,
        addHP = 2200,
        addProduction = {
            energy = 300,
            mass = 15,
        },
    },
    { -- Crystal 3
        maxHP = 13100,
        addHP = 3000,
    },
    { -- Crystal 4
        maxHP = 16560,
        addHP = 2400,
    },
    { -- Crystal 5
        maxHP = 20000,
        addHP = 2500,
    },
}

-- How long should we wait at the beginning of the NIS to allow slower machines to catch up?
local NIS1InitialDelay = 3

-----------------
-- Taunt Managers
-----------------
-- local AeonTM = TauntManager.CreateTauntManager('AeonTM', '/maps/NMCA_003/NMCA_003_strings.lua')
local NicholsTM = TauntManager.CreateTauntManager('NicholsTM', '/maps/NMCA_003/NMCA_003_strings.lua')

--------
-- Debug
--------
local SkipNIS1 = false
local SkipNIS2 = false
local SkipNIS3 = false

-----------
-- Start up
-----------
function OnPopulate(self)
    ScenarioUtils.InitializeScenarioArmies()
    LeaderFaction, LocalFaction = ScenarioFramework.GetLeaderAndLocalFactions()

    Weather.CreateWeather()
    
    ----------
    -- Aeon AI
    ----------
    M1AeonAI.AeonM1BaseAI()

    -- Extra resources outside of the base
    ScenarioUtils.CreateArmyGroup('Aeon', 'M1_Aeon_Extra_Resources_D' .. Difficulty)

    -- Walls
    ScenarioUtils.CreateArmyGroup('Aeon', 'M1_Walls')

    -- Refresh build restriction in support factories and engineers
    ScenarioFramework.RefreshRestrictions('Aeon')

    -- Initial Patrols
    -- Air Patrol
    local platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M1_Initial_Air_Patrol_D' .. Difficulty, 'NoFormation')
    for _, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M1_Aeon_Base_Air_Patrol_Chain')))
    end

    -- Land patrol
    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M1_Initial_Land_Patrol_D' .. Difficulty, 'NoFormation')
    for _, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioUtils.ChainToPositions('M1_Aeon_Base_Land_Patrol_Chain'))
    end
    
    -------------
    -- Objectives
    -------------
    -- Civilian town, Damage the UEF buildings a bit
    local units = ScenarioUtils.CreateArmyGroup('Aeon_Neutral', 'M1_Civilian_Town')
    for _, v in units do
        if EntityCategoryContains(categories.UEF, v) then
            v:AdjustHealth(v, Random(300, 700) * -1)
        end
    end

    -- Admin Center
    ScenarioInfo.M1_Admin_Centre = ScenarioInfo.UnitNames[Aeon_Neutral]['M1_Admin_Centre']
    ScenarioInfo.M1_Admin_Centre:SetCustomName('Administrative Centre')

    -- Crystals, spawn then and make sure they'll survive until the objective
    ScenarioInfo.M1Crystals = ScenarioUtils.CreateArmyGroup('Crystals', 'M1_Crystals')
    for _, v in ScenarioInfo.M1Crystals do
        v:SetReclaimable(false)
        v:SetCanTakeDamage(false)
        v:SetCapturable(false)
    end

    -- Crashed Ship
    --ScenarioInfo.CrashedShip = ScenarioUtils.CreateArmyUnit('Crashed_Ship', 'Crashed_Ship')
    ScenarioInfo.CrashedShip = ScenarioUtils.CreateArmyUnit('Crashed_Ship', 'Crashed_Cruiser')
    ScenarioInfo.CrashedShip:SetCustomName('Crashed Ship')
    ScenarioInfo.CrashedShip:SetReclaimable(false)
    ScenarioInfo.CrashedShip:SetCapturable(false) 
    ScenarioInfo.CrashedShip:SetHealth(ScenarioInfo.CrashedShip, 2250)
    -- Adjust the position
    local pos = ScenarioInfo.CrashedShip:GetPosition()
    ScenarioInfo.CrashedShip:SetPosition({pos[1], pos[2] - 4.5, pos[3]}, true)
    ScenarioInfo.CrashedShip:StopRotators()
    local thread = ForkThread(ShipHPThread)
    ScenarioInfo.CrashedShip.Trash:Add(thread)

    -- Wreckages
    ScenarioUtils.CreateArmyGroup('Crystals', 'M1_Wrecks', true)
end

function OnStart(self)
    -- Set Unit Restrictions
    ScenarioFramework.AddRestrictionForAllHumans(
        categories.TECH3 +
        categories.EXPERIMENTAL +
        categories.inu3008 + -- Nomads Field Engineer
        categories.inb2208 + -- Nomads TML
        categories.inb2303 + -- Nomads T2 Arty
        categories.inb4204 + -- Nomads TMD
        categories.inb4202 + -- Nomads T2 Shield
        categories.ins2002 + -- Nomads Cruiser
        categories.ins2003 + -- Nomads Railgun boat

        categories.uab2108 + -- Aeon TML
        categories.uab2303 + -- Aeon T2 Arty
        categories.uab4201 + -- Aeon TMD
        categories.uab4202 + -- Aeon T2 Shield
        categories.ues0202 + -- Aeon Cruiser
        categories.xas0204   -- Aeon Sub Hunter
    )

    ScenarioFramework.RestrictEnhancements({
        -- Allowed: AdvancedEngineering, Capacitator, GunUpgrade, RapidRepair, MovementSpeedIncrease
        'IntelProbe',
        'IntelProbeAdv',
        'DoubleGuns',
        'RapidRepair',
        'ResourceAllocation',
        'PowerArmor',
        'T3Engineering',
        'OrbitalBombardment'
    })

    -- Set Unit Cap
    ScenarioFramework.SetSharedUnitCap(1000)

    -- Set Army Colours, 4th number for hover effect
    local colors = {
        ['Player1'] = {{225, 135, 62}, 5},
        ['Player2'] = {{189, 183, 107}, 4},
        ['Player3'] = {{255, 255, 165}, 13},
    }
    local tblArmy = ListArmies()
    for army, color in colors do
        if tblArmy[ScenarioInfo[army]] then
            ScenarioFramework.SetArmyColor(ScenarioInfo[army], unpack(color[1]))
            ScenarioInfo.ArmySetup[army].ArmyColor = color[2]
        end
    end
    ScenarioFramework.SetAeonColor(Aeon)
    SetArmyColor('Crashed_Ship', 255, 191, 128)
    SetArmyColor('Aeon_Neutral', 16, 86, 16)

    -- Set playable area
    ScenarioFramework.SetPlayableArea('M1_Area', false)

    -- Initialize camera
    if not SkipNIS1 then
        Cinematics.CameraMoveToMarker('Cam_Intro_1')
    end

    ForkThread(IntroMission1NIS)
end

-----------
-- End Game
-----------
function PlayerDeath(commander)
    ScenarioFramework.PlayerDeath(commander, OpStrings.PlayerDies1)
end

function ShipDeath()
    ScenarioFramework.PlayerDeath(ScenarioInfo.CrashedShip, OpStrings.ShipDestroyed)
end

function PlayerWin()
    ForkThread(
        function()
            ScenarioFramework.FlushDialogueQueue()
            while ScenarioInfo.DialogueLock do
                WaitSeconds(0.2)
            end

            ScenarioInfo.M1P1:ManualResult(true) -- Complete protect ship objective

            WaitSeconds(2)

            if not ScenarioInfo.OpEnded then
                ScenarioFramework.EndOperationSafety({ScenarioInfo.CrashedShip})
                ScenarioInfo.OpComplete = true

                Cinematics.EnterNISMode()
                WaitSeconds(2)

                ScenarioFramework.Dialogue(OpStrings.PlayerWin1, nil, true)
                Cinematics.CameraMoveToMarker('Cam_Final_1', 3)


                ForkThread(
                    function()
                        WaitSeconds(1)
                        ScenarioInfo.CrashedShip:TakeOff()
                        WaitSeconds(3)
                        ScenarioInfo.CrashedShip:StartRotators()
                    end
                )

                WaitSeconds(3)

                Cinematics.CameraMoveToMarker('Cam_Final_2', 5)

                WaitSeconds(1)

                Cinematics.CameraMoveToMarker('Cam_Final_3', 4)

                KillGame()
            end
        end
    )
end

function KillGame()
    UnlockInput()
    local secondary = Objectives.IsComplete(ScenarioInfo.M1S1) and
                      Objectives.IsComplete(ScenarioInfo.M2S1) and
                      Objectives.IsComplete(ScenarioInfo.M3S1) and
                      Objectives.IsComplete(ScenarioInfo.M4S1)
    local bonus = Objectives.IsComplete(ScenarioInfo.M1B1) and
                  Objectives.IsComplete(ScenarioInfo.M1B2) and
                  Objectives.IsComplete(ScenarioInfo.M1B3) and
                  Objectives.IsComplete(ScenarioInfo.M2B1) and
                  Objectives.IsComplete(ScenarioInfo.M2B2) and
                  Objectives.IsComplete(ScenarioInfo.M4B1)
    ScenarioFramework.EndOperation(ScenarioInfo.OpComplete, ScenarioInfo.OpComplete, secondary, bonus)
end

------------
-- Mission 1
------------
function IntroMission1NIS()
    local function SpawnPlayers(armyList)
        ScenarioInfo.PlayersACUs = {}
        local i = 1
        while armyList[ScenarioInfo['Player' .. i]] do
            ScenarioInfo['Player' .. i .. 'CDR'] = ScenarioFramework.SpawnCommander('Player' .. i, 'ACU', 'Warp', true, true, PlayerDeath)
            table.insert(ScenarioInfo.PlayersACUs, ScenarioInfo['Player' .. i .. 'CDR'])
            WaitSeconds(1)
            local ship = GetArmyBrain('Player' .. i).NomadsMothership
            if ship then
                IssueClearCommands({ship})
                IssueMove({ship}, ScenarioUtils.MarkerToPosition('Player' .. i .. '_Frigate_Destination'))
            end
            i = i + 1
        end

    end

    local tblArmy = ListArmies()

    if not SkipNIS1 then
        -- Gets player number and joins it to a string to make it refrence a camera marker e.g Player1_Cam N.B. Observers are called nilCam
        local strCameraPlayer = tostring(tblArmy[GetFocusArmy()])
        local CameraMarker = strCameraPlayer .. '_Cam'

        -- Vision for NIS location
        local VisMarker1 = ScenarioFramework.CreateVisibleAreaLocation(30, 'VizMarker_1', 0, ArmyBrains[Player1])
        local VisMarker2 = ScenarioFramework.CreateVisibleAreaLocation(36, 'VizMarker_2', 0, ArmyBrains[Player1])
        
        --Intro Cinematic
        Cinematics.EnterNISMode()

        WaitSeconds(NIS1InitialDelay)

        -- Look at the Aeon base
        ScenarioFramework.Dialogue(OpStrings.M1Intro1, nil, true)
        WaitSeconds(1)
        Cinematics.CameraMoveToMarker('Cam_Intro_2', 4)
        WaitSeconds(2)

        -- Move cam to the crashed ship
        ScenarioFramework.Dialogue(OpStrings.M1Intro2, nil, true)
        WaitSeconds(1)
        Cinematics.CameraMoveToMarker('Crashed_Ship_Camera', 4)
        WaitSeconds(1)

        -- "Sending you in"
        ScenarioFramework.Dialogue(OpStrings.M1Intro3, nil, true)
        WaitSeconds(4)

        -- Spawn Players
        ForkThread(SpawnPlayers, tblArmy)

        Cinematics.CameraMoveToMarker(CameraMarker, 2)
        WaitSeconds(3)

        VisMarker1:Destroy()
        --VisMarker2:Destroy()

        -- Remove intel on the Aeon base on high difficulty
        if Difficulty == 3 then
            ScenarioFramework.ClearIntel(ScenarioUtils.MarkerToPosition('VizMarker_1'), 40)
        end

        Cinematics.ExitNISMode()
    else
        -- Spawn Players
        ForkThread(SpawnPlayers, tblArmy)
    end

    IntroMission1()
end

function IntroMission1()
    ScenarioInfo.MissionNumber = 1

    -- Give initial resources to the AI
    local num = {2000, 3500, 5000}
    ArmyBrains[Aeon]:GiveResource('MASS', num[Difficulty])
    ArmyBrains[Aeon]:GiveResource('ENERGY', 8000)

    -- Rainbow effect for crystals
    ForkThread(RainbowEffect)

    -- "Aeons are attacking, defend the ship", assign objectives
    ScenarioFramework.Dialogue(OpStrings.M1PostIntro, StartMission1, true)
end

function StartMission1()
    -----------------------------------------------
    -- Primary Objective - Protect the crashed ship
    -----------------------------------------------
    ScenarioInfo.M1P1 = Objectives.Protect(
        'primary',
        'incomplete',
        OpStrings.M1P1Title,
        OpStrings.M1P1Description,
        {
            Units = {ScenarioInfo.CrashedShip},
        }
    )
    ScenarioInfo.M1P1:AddResultCallback(
        function(result)
            if not result then
                ShipDeath()
            end
        end
    )

    -- VOs when ship takes damage
    SetupNicholsM1Warnings()

    ----------------------------------------
    -- Primary Objective - Destroy Aeon Base
    ----------------------------------------
    ScenarioInfo.M1P2 = Objectives.CategoriesInArea(
        'primary',
        'incomplete',
        OpStrings.M1P2Title,
        OpStrings.M1P2Description,
        'killorcapture',
        {
            --MarkArea = true,
            Requirements = {
                {
                    Area = 'M1_Aeon_South_Base',
                    Category = categories.FACTORY + categories.ENGINEER,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Aeon,
                },
            },
        }
    )
    ScenarioInfo.M1P2:AddResultCallback(
        function(result)
            if result then
                ScenarioFramework.Dialogue(OpStrings.M1AeonBaseDestroyed, nil, true)
            end
        end
    )

    -- Reminder
    ScenarioFramework.CreateTimerTrigger(M1P2Reminder1, 600)

    ---------------------------------------------------
    -- Bonus Objective - Capture Aeon Construction Unit
    ---------------------------------------------------
    ScenarioInfo.M1B1 = Objectives.ArmyStatCompare(
        'bonus',
        'incomplete',
        OpStrings.M1B1Title,
        OpStrings.M1B1Description,
        'capture',
        {
            Armies = {'HumanPlayers'},
            StatName = 'Units_Active',
            CompareOp = '>=',
            Value = 1,
            Category = categories.AEON * categories.CONSTRUCTION,
            Hidden = true,
        }
    )
    ScenarioInfo.M1B1:AddResultCallback(
        function(result)
            if result then
                ScenarioFramework.Dialogue(OpStrings.M1AeonUnitCaptured)
            end
        end
    )

    -----------
    -- Triggers
    -----------
    -- Capture Admin Building Objective once seen
    ScenarioFramework.CreateArmyIntelTrigger(M1SecondaryObjective, ArmyBrains[Player1], 'LOSNow', false, true, categories.CIVILIAN, true, ArmyBrains[Aeon_Neutral])

    -- Aeon units are close the Players' bases
    ScenarioFramework.CreateAreaTrigger(M1AeonAttackWarning, 'M1_UEF_Base_Area', categories.ALLUNITS - categories.SCOUT - categories.ENGINEER, true, false, ArmyBrains[Aeon])

    -- Players see the dead UEF Base (make sure the orbital frigate wont trigger it)
    for _, player in ScenarioInfo.HumanPlayers do
        ScenarioFramework.CreateAreaTrigger(M1UEFBaseDialogue, 'M1_UEF_Base_Area', categories.ALLUNITS - categories.ino0001, true, false, ArmyBrains[player])
    end

    -- Unlock T2 shiel
    ScenarioFramework.CreateTimerTrigger(M1ShieldUnlock, 180)

    -- Sending engineers to player's position
    ScenarioFramework.CreateTimerTrigger(M1EnginnersDrop, 250)

    -- Attack from the west
    local delay = {23, 20, 17}
    ScenarioFramework.CreateTimerTrigger(M1AttackFromWest, delay[Difficulty] * 60)

    -- Annnounce the mission name after few seconds
    WaitSeconds(8)
    ScenarioFramework.SimAnnouncement(OpStrings.OPERATION_NAME, 'mission by [e]speed2')
end

function M1SecondaryObjective()
    ScenarioFramework.Dialogue(OpStrings.M1SecondaryObjective)

    ---------------------------------------------------------------
    -- Secondary Objective - Capture the Aeon administrative centre
    ---------------------------------------------------------------
    ScenarioInfo.M1S1 = Objectives.Capture(
        'secondary',
        'incomplete',
        OpStrings.M1S1Title,
        OpStrings.M1S1Description,
        {
            Units = {ScenarioInfo.M1_Admin_Centre},
            FlashVisible = true,
        }
    )
    ScenarioInfo.M1S1:AddResultCallback(
        function(result)
            if result then
                -- TODO: Decide what bonus to give player for this.
                ScenarioFramework.Dialogue(OpStrings.M1SecondaryDone)
            else
                ScenarioFramework.Dialogue(OpStrings.M1SecondaryFailed)
            end
        end
   )

   -- Reminder
    ScenarioFramework.CreateTimerTrigger(M1S1Reminder, 600)
end

function M1AeonAttackWarning()
    ScenarioFramework.Dialogue(OpStrings.M1AeonAttackWarning)
end

function M1UEFBaseDialogue()
    if not ScenarioInfo.M1UEFDialoguePlayed then
        ScenarioInfo.M1UEFDialoguePlayed = true
        ScenarioFramework.Dialogue(OpStrings.M1UEFBaseDialogue)
    end
end

function M1ShieldUnlock()
    local function Unlock()
        ScenarioFramework.RemoveRestrictionForAllHumans(categories.inb4202 + categories.uab4202, true)

        -------------------------------------------------
        -- Bonus Objective - Build a shield over the ship
        -------------------------------------------------
        ScenarioInfo.M1B2 = Objectives.CategoriesInArea(
            'bonus',
            'incomplete',
            OpStrings.M1B2Title,
            OpStrings.M1B2Description,
            'build',
            {
                Hidden = true,
                Requirements = {
                    {
                        Area = 'M1_Shield_Area',
                        Category = categories.SHIELD * categories.TECH2 * categories.STRUCTURE,
                        CompareOp = '>=',
                        Value = 1,
                        Armies = {'HumanPlayers'},
                    },
                },
            }
        )
        ScenarioInfo.M1B2:AddResultCallback(
            function(result)
                if result then
                    ScenarioFramework.Dialogue(OpStrings.M1ShieldConstructed)
                end
            end
        )
    end

    -- First play the dialogue, then unlock
    ScenarioFramework.Dialogue(OpStrings.M1ShieldUnlock, Unlock, true)
end

function M1EnginnersDrop()
    ScenarioFramework.Dialogue(OpStrings.M1Enginners1, nil, true)

    WaitSeconds(45)

    ScenarioFramework.Dialogue(OpStrings.M1Enginners2, nil, true)

    ScenarioInfo.M1Engineers = {}

    -- Drop the engineers, start repairing the ship
    for i = 1, 4 do
        ForkThread(function(i)
            local transport = ScenarioUtils.CreateArmyUnit('Crashed_Ship', 'Transport' .. i)
            local engineer = ScenarioUtils.CreateArmyUnit('Crashed_Ship', 'Engineer' .. i)
            table.insert(ScenarioInfo.M1Engineers, engineer)

            ScenarioFramework.AttachUnitsToTransports({engineer}, {transport})
            IssueTransportUnload({transport}, ScenarioUtils.MarkerToPosition('Drop_Marker_'.. i))

            while engineer and not engineer:IsDead() and engineer:IsUnitState('Attached') do
                WaitSeconds(3)
            end

            IssueMove({engineer}, ScenarioUtils.MarkerToPosition('Move_Marker_'.. i))
            IssueRepair({engineer}, ScenarioInfo.CrashedShip)

            WaitSeconds(3)
            ScenarioFramework.GiveUnitToArmy(transport, 'Player1')
            WaitSeconds(3)

            M1RepairingShip()
        end, i)
    end

    -- Wait one seconds for the engineers to spawn and assign a bonus objective to protect them
    WaitSeconds(1)

    --------------------------------------
    -- Bonus Objective - Protect engineers
    --------------------------------------
    ScenarioInfo.M1B3 = Objectives.Protect(
        'bonus',
        'incomplete',
        OpStrings.M1B3Title,
        OpStrings.M1B3Description,
        {
            Units = ScenarioInfo.M1Engineers,
            MarkUnits = false,
            Hidden = true,
        }
    )
end

function M1RepairingShip()
    if not ScenarioInfo.ShipBeingRepaired then
        ScenarioInfo.ShipBeingRepaired = true
        ScenarioFramework.Dialogue(OpStrings.M1Enginners3, nil, true)

        WaitSeconds(10)
        ScenarioFramework.Dialogue(OpStrings.M1CrystalsObjective, M1CrystalsObjective, true)
    end
end

function M1CrystalsObjective()
    -- Debug check to prevent running the same code twice when skipping through the mission
    if ScenarioInfo.MissionNumber ~= 1 then
        return
    end

    -- Allow reclaiming of the crystals
    for _, v in ScenarioInfo.M1Crystals do
        v:SetReclaimable(true)
    end

    -----------------------------------------------------
    -- Primary Objective - Find things to repair the ship
    -----------------------------------------------------
    ScenarioInfo.M1P3 = CustomFunctions.Reclaim(
        'primary',
        'incomplete',
        OpStrings.M1P3Title,
        OpStrings.M1P3Description,
        {
            Units = ScenarioInfo.M1Crystals,
            NumRequired = 5,
        }
    )
    ScenarioInfo.M1P3:AddProgressCallback(
        function(current, total)
            CrystalReclaimed(current)

            if current == 1 then
                ScenarioFramework.Dialogue(OpStrings.FirstCrystalReclaimed, nil, true)
            elseif current == 2 then
                -- Resource bonus
                if ScenarioInfo.MissionNumber == 1 then
                    -- Expand the map
                    ScenarioFramework.Dialogue(OpStrings.SecondCrystalReclaimed1, IntroMission2, true)
                else
                    ScenarioFramework.Dialogue(OpStrings.SecondCrystalReclaimed2, nil, true)
                end
            elseif current == 3 then
                ScenarioFramework.Dialogue(OpStrings.ThirdCrystalReclaimed, nil, true)
            elseif current == 4 then
                -- Atry satellite
                ForkThread(SpawnArtillery)

                ScenarioFramework.Dialogue(OpStrings.FourthCrystalReclaimed, nil, true)
            end
        end
    )
    ScenarioInfo.M1P3:AddResultCallback(
        function(result)
            if result then
                -- Finish objective to protect the engineers repairing the ship
                if ScenarioInfo.M1B3.Active then
                    ScenarioInfo.M1B3:ManualResult(true)
                end

                if ScenarioInfo.MissionNumber == 2 then
                    -- Warn about attack and expand the map
                    ScenarioFramework.Dialogue(OpStrings.AllCrystalReclaimed1, M2AttackWarning, true)
                else
                    ScenarioFramework.Dialogue(OpStrings.AllCrystalReclaimed2, nil, true)
                end
            end
        end
    )

    -- Reminder
    ScenarioFramework.CreateTimerTrigger(M1P3Reminder1, 20*60)
end

function M1AttackFromWest()
    -- Debug check to prevent running the same code twice when skipping through the mission
    if ScenarioInfo.MissionNumber ~= 1 then
        return
    end
    -- Randomly pick the attack, "false" will start it right away
    ChooseRandomEvent(false)

    -- Wait few minutes and expand the map if it hasn't yet
    WaitSeconds(7*60)

    if ScenarioInfo.MissionNumber == 1 then
        -- When the timer runs out, expand the map even
        ScenarioFramework.Dialogue(OpStrings.M1MapExpansion, IntroMission2, true)
    end
end

function M1AirAttack()
    local platoon = nil
    local num = 0
    local quantity = {}

    -- Air attack
    -- Warn player the attack is coming
    ScenarioFramework.Dialogue(OpStrings.M1AirAttack)

    -- Basic air attack
    for i = 1, 3 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M1_Air_Attack_' .. i .. '_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'M1_Aeon_Air_Attack_West_Chain_' .. i)
    end

    -- Sends combat fighters if players has more than [20, 25, 30] air fighters
    num = ScenarioFramework.GetNumOfHumanUnits(categories.AIR * categories.MOBILE - categories.SCOUT)
    quantity = {20, 25, 30}
    if num > quantity[Difficulty] then
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M1_Air_SwiftWinds_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'M1_Aeon_Air_Attack_West_Chain_2')
    end

    -- Sends air attack on destroyers if player has more than [2, 3, 4]
    local destroyers = ScenarioFramework.GetListOfHumanUnits(categories.DESTROYER)
    num = table.getn(destroyers)
    quantity = {2, 3, 4}
    if num > 0 then
        if num > quantity[Difficulty] then
            num = quantity[Difficulty]
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M1_Air_Destroyer_Counter_D' .. Difficulty, 'GrowthFormation', 1 + Difficulty)
            IssueAttack(platoon:GetPlatoonUnits(), destroyers[i])
            ScenarioFramework.PlatoonPatrolChain(platoon, 'M1_Aeon_Naval_Atttack_Chain')
        end
    end

    -- Sends [1, 2, 3] Mercies at players' ACUs
    for _, v in ScenarioInfo.PlayersACUs do
        if not v:IsDead() then
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M1_Air_ACU_Counter_D' .. Difficulty, 'NoFormation', 5)
            IssueAttack(platoon:GetPlatoonUnits(), v)
            IssueAggressiveMove(platoon:GetPlatoonUnits(), ScenarioUtils.MarkerToPosition('Player1'))
        end
    end
end

function M1LandAttack()
    -- TODO: Decide if we want a land/hover/drops attack type as well
    local platoon = nil

    -- Land attack
    -- Warn player the attack is coming
    ScenarioFramework.Dialogue(OpStrings.M1LandAttack)
end

function M1NavalAttack()
    -- Naval attack
    -- Warn player the attack is coming
    ScenarioFramework.Dialogue(OpStrings.M1NavalAttack)

    -- First move ships to the map, then patrol, to make sure they won't shoot from off-map

    -- Destroyers
    local platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M1_Destroyers_D' .. Difficulty, 'AttackFormation', 2 + Difficulty)
    platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('M1_Destroyer_Entry'), false)
    ScenarioFramework.PlatoonPatrolChain(platoon, 'M1_Aeon_Destroyer_Chain')

    -- Cruiser, only on medium and high difficulty
    if Difficulty >= 2 then
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M1_Cruiser_D' .. Difficulty, 'AttackFormation', 1 + Difficulty)
        platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('M1_Frigate_Entry_2'), false)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'M1_Aeon_Frigate_Chain_2')
    end

    -- Frigates
    for i = 1, Difficulty do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M1_Frigates_' .. i, 'AttackFormation', Difficulty)
        platoon:MoveToLocation(ScenarioUtils.MarkerToPosition('M1_Frigate_Entry_' .. i), false)
        ScenarioFramework.PlatoonPatrolChain(platoon, 'M1_Aeon_Frigate_Chain_' .. i)
    end
end

------------
-- Mission 2
------------
function IntroMission2()
    ScenarioFramework.FlushDialogueQueue()
    while ScenarioInfo.DialogueLock do
        WaitSeconds(0.2)
    end

    -- Debug check to prevent running the same code twice when skipping through the mission
    if ScenarioInfo.MissionNumber ~= 1 then
        return
    end
    ScenarioInfo.MissionNumber = 2

    ----------
    -- Aeon AI
    ----------
    -- North and South base, using random pick for choosing naval factory location
    ChooseRandomBases()

    -- Extra resources outside of the bases
    ScenarioUtils.CreateArmyGroup('Aeon', 'M2_Aeon_Extra_Resources_D' .. Difficulty)

    -- Walls
    ScenarioUtils.CreateArmyGroup('Aeon', 'M2_Walls')

    -- Refresh build restriction in support factories and engineers
    ScenarioFramework.RefreshRestrictions('Aeon')

    -- Patrols
    -- North
    -- Air base patrol
    local platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Aeon_North_Base_Air_Patrol_D' .. Difficulty, 'NoFormation')
    for _, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M2_Aeon_North_Base_Air_Patrol_Chain')))
    end

    -- Naval base patrol
    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Init_North_Naval_Patrol_D' .. Difficulty, 'NoFormation')
    for _, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolChain({v}, 'M2_Aeon_North_Base_Naval_Defense_Chain')
    end

    -- Sub Hunters around the island
    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Init_SubmarineHunters_4_D' .. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'M2_Aeon_SubHunter_Full_Chain')


    -- South
    -- Air base patrol
    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Aeon_South_Base_Air_Patrol_D' .. Difficulty, 'NoFormation')
    for _, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('M2_Aeon_South_Base_Air_Patrol_Chain')))
    end

    -- Land base patrol
    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Init_South_Land_Patrol_D' .. Difficulty, 'NoFormation')
    for _, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolChain({v}, 'M2_Aeon_South_Base_Land_Patrol_Chain')
    end

    -- Naval base patrol
    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Init_South_Naval_Patrol_D' .. Difficulty, 'NoFormation')
    for _, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolChain({v}, 'M2_Aeon_South_Base_Naval_Defense_Chain')
    end


    -- Middle
    -- Submarine hunters, 3 groups of {2, 3, 4}
    for i = 1, 3 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Init_SubmarineHunters_' .. i .. '_D' .. Difficulty, 'AttackFormation')
        ScenarioFramework.PlatoonPatrolChain(platoon, 'M2_Aeon_SubHunter_Mid_Chain')
    end

    -- Torpedo bombers
    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Init_Torpedo_Bombers_D' .. Difficulty, 'NoFormation')
    for _, v in platoon:GetPlatoonUnits() do
        ScenarioFramework.GroupPatrolChain({v}, 'M2_Aeon_SubHunter_Mid_Chain')
    end

    -- South
    platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M2_Init_SubmarineHunters_5_D' .. Difficulty, 'AttackFormation')
    ScenarioFramework.PlatoonPatrolChain(platoon, 'M2_Aeon_SubHunter_South_Chain')

    -------------
    -- Objectives
    -------------
    -- Crystals, spawn then and make sure they'll survive until the objective
    ScenarioInfo.M2Crystals = ScenarioUtils.CreateArmyGroup('Crystals', 'M2_Crystals')
    for _, v in ScenarioInfo.M2Crystals do
        v:SetCanTakeDamage(false)
        v:SetCapturable(false)
    end

    -- Wreckages
    ScenarioUtils.CreateArmyGroup('Crystals', 'M2_Wrecks', true)

    -- Give initial resources to the AI
    local num = {10000, 14000, 18000}
    ArmyBrains[Aeon]:GiveResource('MASS', num[Difficulty])
    ArmyBrains[Aeon]:GiveResource('ENERGY', 30000)

    IntroMission2NIS()
end

function IntroMission2NIS()
    -- Playable area
    ScenarioFramework.SetPlayableArea('M2_Area', true)

    if not SkipNIS2 then
        Cinematics.EnterNISMode()
        Cinematics.SetInvincible('M1_Area')

        -- Visible locations
        -- Show crystal positons
        ScenarioFramework.CreateVisibleAreaLocation(5, ScenarioInfo.M2Crystals[1]:GetPosition(), 1, ArmyBrains[Player1])
        ScenarioFramework.CreateVisibleAreaLocation(20, ScenarioInfo.M2Crystals[2]:GetPosition(), 1, ArmyBrains[Player1])
        ScenarioFramework.CreateVisibleAreaLocation(5, ScenarioInfo.M2Crystals[3]:GetPosition(), 1, ArmyBrains[Player1])
        -- Aeon base
        local VizMarker1 = ScenarioFramework.CreateVisibleAreaLocation(50, 'M2_Viz_Marker_1', 0, ArmyBrains[Player1])

        local fakeMarker1 = {
            ['zoom'] = FLOAT(35),
            ['canSetCamera'] = BOOLEAN(true),
            ['canSyncCamera'] = BOOLEAN(true),
            ['color'] = STRING('ff808000'),
            ['editorIcon'] = STRING('/textures/editor/marker_mass.bmp'),
            ['type'] = STRING('Camera Info'),
            ['prop'] = STRING('/env/common/props/markers/M_Camera_prop.bp'),
            ['orientation'] = VECTOR3(-3.14159, 1.19772, 0),
            ['position'] = ScenarioInfo.Player1CDR:GetPosition(),
        }
        Cinematics.CameraMoveToMarker(fakeMarker1, 0)

        ScenarioFramework.Dialogue(OpStrings.M2Intro1, nil, true)
        WaitSeconds(5)

        ScenarioFramework.Dialogue(OpStrings.M2Intro2, nil, true)
        Cinematics.CameraMoveToMarker('Cam_M2_Intrro_1', 4)
        WaitSeconds(1)

        ScenarioFramework.Dialogue(OpStrings.M2Intro3, nil, true)
        Cinematics.CameraMoveToMarker('Cam_M2_Intrro_2', 3)
        WaitSeconds(2)

        Cinematics.CameraMoveToMarker('Cam_M2_Intrro_3', 3)
        WaitSeconds(1)

        VizMarker1:Destroy()

        -- Remove intel on the Aeon base on high difficulty
        if Difficulty >= 3 then
            ScenarioFramework.ClearIntel(ScenarioUtils.MarkerToPosition('M2_Viz_Marker_1'), 60)
        end

        Cinematics.SetInvincible('M1_Area', true)
        Cinematics.ExitNISMode()
    end

    ScenarioFramework.Dialogue(OpStrings.M2PostIntro, StartMission2, true)
end

function StartMission2()
    -- Add crystals to the objective
    ScenarioInfo.M1P3:AddTargetUnits(ScenarioInfo.M2Crystals)

    ---------------------------------------------
    -- Secondary Objective - Destroy 2 Aeon bases
    ---------------------------------------------
    ScenarioInfo.M1S1 = Objectives.CategoriesInArea(
        'secondary',
        'incomplete',
        OpStrings.M2S1Title,
        OpStrings.M2S1Description,
        'killorcapture',
        {
            Requirements = {
                {
                    Area = 'M2_Aeon_North_Base',
                    Category = categories.FACTORY + categories.ENGINEER + categories.CONSTRUCTION,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Aeon
                },
                {
                    Area = 'M2_Aeon_South_Base',
                    Category = categories.FACTORY + categories.ENGINEER + categories.CONSTRUCTION,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Aeon
                },
            },
        }
    )
    ScenarioInfo.M1S1:AddProgressCallback(
        function(current, total)
            if current == 1 then
                ScenarioFramework.Dialogue(OpStrings.M2OneBaseDestroyed)
            end
        end
    )
    ScenarioInfo.M1S1:AddResultCallback(
        function(result)
            if result then
                ScenarioFramework.Dialogue(OpStrings.M2BasesDestroyed)
            end
        end
    )

    ---------------------------------
    -- Bonus Objective - Kill T2 Subs
    ---------------------------------
    local num = {40, 50, 60}
    ScenarioInfo.M2B1 = Objectives.ArmyStatCompare(
        'bonus',
        'incomplete',
        OpStrings.M2B1Title,
        LOCF(OpStrings.M2B1Description, num[Difficulty]),
        'kill',
        {
            Armies = {'HumanPlayers'},
            StatName = 'Enemies_Killed',
            CompareOp = '>=',
            Value = num[Difficulty],
            Category = categories.xas0204,
            Hidden = true,
        }
    )

    -- Triggers
    -- Start naval attacks from the south base if the first Aeon base naval factories are destroyed
    ScenarioFramework.CreateAreaTrigger(M2SouthBaseNavalAttacks, 'M1_Aeon_Naval_Area', categories.FACTORY * categories.NAVAL, true, true, ArmyBrains[Aeon])

    -- Complete bonus objective to shoot down engie drop if player kills the south base before it can send the engineers
    ScenarioFramework.CreateAreaTrigger(M2BonusObjectiveSkipped, 'M2_Aeon_South_Base', categories.FACTORY + categories.ENGINEER + categories.CONSTRUCTION, true, true, ArmyBrains[Aeon])

    -- Unlock Rail Boat
    ScenarioFramework.CreateTimerTrigger(M2RailBoatUnlock, 2*60)

    -- Build engineers drop for bonus objective
    ScenarioFramework.CreateTimerTrigger(M2AeonAI.AeonM2SouthBaseEngineerDrop, 5*60)

    -- Warn player to hurry up
    ScenarioFramework.CreateTimerTrigger(M2Dialogue, 7*60)

    -- Look at the Aeon ACU building a base
    ScenarioFramework.CreateTimerTrigger(M2EnemyACUNIS, 8*60)

    -- Unlock T2 Arty
    ScenarioFramework.CreateTimerTrigger(M2T2ArtyUnlock, 11*60)

    -- Continue to the third part of the mission
    local delay = {24, 21, 18}
    ScenarioFramework.CreateTimerTrigger(M2AttackWarning, delay[Difficulty]*60)
end

function M2SouthBaseNavalAttacks()
    M2AeonAI.AeonM2SouthBaseStartNavalAttacks()
end

function M2RailBoatUnlock()
    local function Unlock()
        ScenarioFramework.RemoveRestrictionForAllHumans(categories.ins2003 + categories.xas0204, true)
    end

    -- First play the dialogue, then unlock
    ScenarioFramework.Dialogue(OpStrings.M2RailBoatUnlock, Unlock, true)
end

function M2Dialogue()
    -- We're detecting increasing enemy activity
    ScenarioFramework.Dialogue(OpStrings.M2Dialogue)
end

function M2T2ArtyUnlock()
    local function Unlock()
        ScenarioFramework.RemoveRestrictionForAllHumans(categories.inb2303 + categories.uab2303, true)
    end

    -- First play the dialogue, then unlock
    ScenarioFramework.Dialogue(OpStrings.M2T2ArtyUnlock, Unlock, true)
end

function M2DropEngineersPlatoonFormed(platoon)
    local units = platoon:GetPlatoonUnits()
    local engineers = {}

    for _, v in units do
        if EntityCategoryContains(categories.ENGINEER, v) then
            table.insert(engineers, v)
        end
    end

    --[[ -- TODO: Decide if we want to wait for the engineers to be loaded in the transport
    local attached = false
    for _, v in engineers do
        while not attached and v and not v:IsDead() do
            if v:IsUnitState('Attached') then
                attached = true
                break
            end
            WaitSeconds(.5)
        end
    end

    if not attached then
        LOG('All engineers died')
        return
    end
    --]]
    -- Make sure the engies won't get built again
    ArmyBrains[Aeon]:PBMRemoveBuilder('OSB_Child_EngineerAttack_T2Engineers_Aeon_M2_AeonOffMapEngineers')

    ---------------------------------------
    -- Bonus Objective - Kill Engineer Drop
    ---------------------------------------
    ScenarioInfo.M2B2 = Objectives.Kill(
        'bonus',
        'incomplete',
        OpStrings.M2B2Title,
        OpStrings.M2B2Description,
        {
            Units = engineers,
            MarkUnits = false,
            Hidden = true,
        }
    )
    ScenarioInfo.M2B2:AddResultCallback(
        function(result)
            if result then
                ScenarioInfo.M2EngineersKilled = true
                ScenarioFramework.Dialogue(OpStrings.M2EngieDropKilled)
            end
        end
    )

    local function BonusObjFail(unit)
        if ScenarioInfo.M2B2.Active then
            ScenarioInfo.M2B2:ManualResult(false)
        end
        unit:Destroy()
    end

    -- If units get to this marker, player didnt shot it down
    for _, v in units do
        ScenarioFramework.CreateUnitToMarkerDistanceTrigger(BonusObjFail, v, 'M2_Aeon_Engineers_Drop_Marker', 60)
    end
end

function M2BonusObjectiveSkipped()
    -- In case player kills the south base before the engineer drop even happens
    if not ScenarioInfo.M2B2 then
        ------------------------------------------
        -- Bonus Objective - Prevent Engineer Drop
        ------------------------------------------
        ScenarioInfo.M2B2 = Objectives.Basic(
            'bonus',
            'complete',
            OpStrings.M2B2Title,
            OpStrings.M2B2Description,
            Objectives.GetActionIcon('kill'),
            {}
        )

        ScenarioInfo.M2EngineersKilled = true
    end
end

function M2EnemyACUNIS()
    ScenarioFramework.FlushDialogueQueue()
    while ScenarioInfo.DialogueLock do
        WaitSeconds(0.2)
    end

    -- Debug check to prevent running the same code twice when skipping through the mission
    if ScenarioInfo.MissionNumber ~= 2 then
        return
    end

    ScenarioFramework.Dialogue(OpStrings.M2ACUNIS1, nil, true)

    WaitSeconds(5)

    -- Factory and some pgens
    local units = ScenarioUtils.CreateArmyGroup('Aeon', 'M2_Aeon_NIS_Base')
    for _, v in units do
        if EntityCategoryContains(categories.FACTORY, v) then
            IssueBuildFactory({v}, 'ual0105', 2)
        end
    end

    -- ACU to build some stuff
    local unit = ScenarioFramework.EngineerBuildUnits('Aeon', 'Aeon_ACU', 'Mex_To_Built', 'Fac_To_Built')

    Cinematics.SetInvincible('M2_Area')
    ScenarioFramework.SetPlayableArea('M3_Area', false)
    WaitSeconds(.1)
    Cinematics.EnterNISMode()

    local VizMarker1 = ScenarioFramework.CreateVisibleAreaLocation(20, unit:GetPosition(), 0, ArmyBrains[Player1])

    WaitSeconds(2)

    Cinematics.CameraMoveToMarker('Cam_M2_ACU_1', 0)
    ScenarioFramework.Dialogue(OpStrings.M2ACUNIS2, nil, true)

    WaitSeconds(2)

    Cinematics.CameraMoveToMarker('Cam_M2_ACU_2', 7)

    WaitSeconds(2)

    VizMarker1:Destroy()
    Cinematics.CameraMoveToMarker('Cam_M2_Intrro_3', 0)
    Cinematics.ExitNISMode()
    Cinematics.SetInvincible('M2_Area', true)
    ScenarioFramework.SetPlayableArea('M2_Area', false)

    -- Cleanup, destroy the offmap units, the base will get spawned later
    for _, v in GetUnitsInRect(ScenarioUtils.AreaToRect('M3_Aeon_Main_Base_Area')) do
        v:Destroy()
    end

    WaitSeconds(1)

    -- ACU
    M3AeonAI.AeonM3MainBaseAI()

    ScenarioInfo.M3AeonACU = ScenarioFramework.SpawnCommander('Aeon', 'Aeon_ACU', 'Warp', 'AeonACUName', true, false, -- TODO: Name for the ACU
        {'AdvancedEngineering', 'Shield', 'HeatSink'})
    ScenarioInfo.M3AeonACU:SetAutoOvercharge(true)
    ScenarioInfo.M3AeonACU:SetVeterancy(1 + Difficulty)
end

function M2AttackWarning()
    if not ScenarioInfo.M2AttackWarningPlayed then
        ScenarioInfo.M2AttackWarningPlayed = true
        -- Warn about the attack from the north and get into M3
        ScenarioFramework.Dialogue(OpStrings.M2AttackWarning, IntroMission3, true)
    end
end

------------
-- Mission 3
------------
function IntroMission3()
    ScenarioFramework.FlushDialogueQueue()
    while ScenarioInfo.DialogueLock do
        WaitSeconds(0.2)
    end

    -- Debug check to prevent running the same code twice when skipping through the mission
    if ScenarioInfo.MissionNumber ~= 2 then
        return
    end
    ScenarioInfo.MissionNumber = 3

    ----------
    -- Aeon AI
    ----------
    -- Main Base
    M3AeonAI.SpawnGate()

    -- Start attacks
    M3AeonAI.StartAttacks()

    -- Orbital Cannon Base
    ScenarioUtils.CreateArmyGroup('Aeon', 'M3_Aeon_Orbital_Base_D' .. Difficulty)
    HandleT3Arties()

    -- Walls
    ScenarioUtils.CreateArmyGroup('Aeon', 'M3_Walls')

    -- Patrols

    -- Wreckages
    ScenarioUtils.CreateArmyGroup('Crystals', 'M3_Wrecks', true)

    -- Give initial resources to the AI
    local num = {6000, 8000, 10000}
    ArmyBrains[Aeon]:GiveResource('MASS', num[Difficulty])
    ArmyBrains[Aeon]:GiveResource('ENERGY', 30000)

    -- Cunter attack
    M3CounterAttack()

    IntroMission3NIS()
end

function M3CounterAttack()
    -- All the units that need to be killed to finish the objective
    ScenarioInfo.M3CounterAttackUnits = {}

    local quantity = {}
    local trigger = {}
    local platoon
    local crashedShipPos = ScenarioInfo.CrashedShip:GetPosition()

    local function AddUnitsToObjTable(platoon)
        for _, v in platoon:GetPlatoonUnits() do
            if not EntityCategoryContains(categories.TRANSPORTATION + categories.SCOUT + categories.SHIELD, v) then
                table.insert(ScenarioInfo.M3CounterAttackUnits, v)
            end
        end
    end

    --------
    -- Drops
    --------
    for i = 1, 2 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M3_Aeon_Drops_Counter_' .. i, 'AttackFormation')
        ScenarioFramework.PlatoonAttackWithTransports(platoon, 'M3_Aeon_CA_Landing_Chain_' .. i, 'M3_Aeon_CA_Drop_Attack_Chain_' .. i, true)
        AddUnitsToObjTable(platoon)
    end

    -------------
    -- Amphibious
    -------------
    for i = 1, 3 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M3_Aeon_Amph_Attack_' .. i .. '_D' ..  Difficulty, 'GrowthFormation')
        ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_Aeon_Main_Base_Base_Amphibious_Chain_' .. i)
        AddUnitsToObjTable(platoon)
    end
    
    ------
    -- Air
    ------
    for i = 1, 3 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M3_Air_Counter_' ..  i, 'GrowthFormation')
        ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_Aeon_Main_Base_Air_Attack_Chain_' .. i)
        AddUnitsToObjTable(platoon)
    end

    -- sends gunships and strats at mass extractors up to 4, 6, 8 if < 500 units, up to 6, 8, 10 if >= 500 units
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
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M3_Aeon_Adapt_Mex_Gunships_D' .. Difficulty, 'GrowthFormation')
            IssueAttack(platoon:GetPlatoonUnits(), extractors[i])
            IssueAggressiveMove(platoon:GetPlatoonUnits(), crashedShipPos)
            AddUnitsToObjTable(platoon)

            local guard = ScenarioUtils.CreateArmyGroup('Aeon', 'M3_Aeon_Adapt_GunshipGuard')
            IssueGuard(guard, platoon:GetPlatoonUnits()[1])
        end
    end

    -- sends T2 gunships at every other shield, up to [2, 4, 10]
    quantity = {2, 4, 10}
    local shields = ScenarioFramework.GetListOfHumanUnits(categories.SHIELD * categories.STRUCTURE)
    num = table.getn(shields)
    if num > 0 then
        num = math.ceil(num/2)
        if num > quantity[Difficulty] then
            num = quantity[Difficulty]
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M3_Aeon_Adapt_T2Gunship', 'GrowthFormation', 5)
            IssueAttack(platoon:GetPlatoonUnits(), shields[i])
            IssueAggressiveMove(platoon:GetPlatoonUnits(), crashedShipPos)
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
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M3_Aeon_Adapt_Swifts', 'GrowthFormation', 5)
            ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_Aeon_Main_Base_Air_Attack_Chain_' .. Random(1, 3))
            AddUnitsToObjTable(platoon)
        end
    end

    -- sends swift winds if player has torpedo gunships, up to 10, 18, 26
    local torpGunships = ScenarioFramework.GetListOfHumanUnits(categories.ina2003)
    num = table.getn(torpGunships)
    quantity = {10, 18, 26}
    if num > 0 then
        if num > quantity[Difficulty] then
            num = quantity[Difficulty]
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M3_Aeon_Adapt_TorpGunshipHunt', 'GrowthFormation', 5)
            IssueAttack(platoon:GetPlatoonUnits(), torpGunships[i])
            ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_Aeon_CA_Default_Air_Patrol_Chain')
            AddUnitsToObjTable(platoon)
        end
    end

    -- sends torpedo bombers if player has more than [14, 12, 10] T2 naval, up to 6, 8, 10 groups
    local T2Naval = ScenarioFramework.GetListOfHumanUnits(categories.NAVAL * categories.MOBILE * categories.TECH2)
    num = table.getn(T2Naval)
    quantity = {6, 8, 10}
    trigger = {14, 12, 10}
    if num > trigger[Difficulty] then
        if num > quantity[Difficulty] then
            num = quantity[Difficulty]
        end
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M3_Aeon_Adapt_TorpBombers', 'GrowthFormation', 5)
            IssueAttack(platoon:GetPlatoonUnits(), T2Naval[i])
            IssueAggressiveMove(platoon:GetPlatoonUnits(), crashedShipPos)
            ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_Aeon_CA_Default_Air_Patrol_Chain')
            AddUnitsToObjTable(platoon)
        end
    end

    --------
    -- Naval
    --------
    for i = 1, 2 do
        platoon = ScenarioUtils.CreateArmyGroupAsPlatoon('Aeon', 'M3_Aeon_CA_Naval_Attack_' ..  i, 'GrowthFormation')
        ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_Aeon_Main_Base_Naval_Attack_Chain_' .. i)
        AddUnitsToObjTable(platoon)
    end
    
    -- sends either destroyer or sub hunter on player's T2 units, up to 8, 10, 12
    local T2Naval = ScenarioFramework.GetListOfHumanUnits(categories.NAVAL * categories.MOBILE * categories.TECH2)
    num = table.getn(T2Naval)
    quantity = {8, 12, 16}
    if num > 0 then
        if num > quantity[Difficulty] then
            num = quantity[Difficulty]
        end
        for i = 1, num do
            if Random(1,3) == 1 then -- Higher chance to get destroyer
                platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M3_Aeon_CA_SubHunters', 'AttackFormation', 1 + Difficulty)
            else
                platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M3_Aeon_CA_Destroyers', 'AttackFormation', 1 + Difficulty)
            end
            IssueAttack(platoon:GetPlatoonUnits(), T2Naval[i])
            ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_Aeon_CA_Default_Air_Patrol_Chain')
            AddUnitsToObjTable(platoon)
        end
    end

    -- sends 1 cruiser for every 70, 60, 50 air units
    local air = ScenarioFramework.GetListOfHumanUnits(categories.AIR * categories.MOBILE)
    num = table.getn(air)
    quantity = {70, 60, 50}
    if num > quantity[Difficulty] then
        num = math.ceil(num/quantity[Difficulty])
        for i = 1, num do
            platoon = ScenarioUtils.CreateArmyGroupAsPlatoonVeteran('Aeon', 'M3_Aeon_CA_Cruiser', 'AttackFormation', 1 + Difficulty)
            ScenarioFramework.PlatoonPatrolChain(platoon, 'M3_Aeon_Main_Base_Naval_Attack_Chain_' .. Random(1, 2))
            AddUnitsToObjTable(platoon)
        end
    end
end

function IntroMission3NIS()
    ScenarioFramework.SetPlayableArea('M3_Area', true)

    if not SkipNIS3 then
        Cinematics.EnterNISMode()

        ScenarioFramework.Dialogue(OpStrings.M3Intro1, nil, true)
        WaitSeconds(1)

        -- Vision for NIS location
        local VisMarker1 = ScenarioFramework.CreateVisibleAreaLocation(40, 'VizMarker_3', 0, ArmyBrains[Player1])
        local VisMarker2 = ScenarioFramework.CreateVisibleAreaLocation(50, 'VizMarker_4', 0, ArmyBrains[Player1])
        local VisMarker3 = ScenarioFramework.CreateVisibleAreaLocation(50, 'VizMarker_5', 0, ArmyBrains[Player1])

        --Cinematics.CameraTrackEntity(ScenarioInfo.UnitNames[Aeon]['M3_NIS_Unit_1'], 30, 3)
        
        Cinematics.CameraMoveToMarker('Cam_M3_Intro_1', 4)

        WaitSeconds(2)

        --Cinematics.CameraTrackEntity(ScenarioInfo.UnitNames[Aeon]['M3_NIS_Unit_2'], 30, 2)
        ScenarioFramework.Dialogue(OpStrings.M3Intro2, nil, true)
        Cinematics.CameraMoveToMarker('Cam_M3_Intro_2', 4)

        WaitSeconds(2)

        Cinematics.CameraMoveToMarker('Cam_M3_Intro_3', 2)

        VisMarker1:Destroy()
        VisMarker2:Destroy()
        VisMarker3:Destroy()

        WaitSeconds(1)

        Cinematics.ExitNISMode()
    end

    StartMission3()
end

function StartMission3()
    ScenarioFramework.Dialogue(OpStrings.M3PostIntro, nil, true)

    --------------------------------------------
    -- Primary Objective - Defeat Counter Attack
    --------------------------------------------
    ScenarioInfo.M3P1 = Objectives.KillOrCapture(
        'primary',
        'incomplete',
        OpStrings.M3P1Title,
        OpStrings.M3P1Description,
        {
            Units = ScenarioInfo.M3CounterAttackUnits,
            MarkUnits = false,
        }
    )
    ScenarioInfo.M3P1:AddResultCallback(
        function(result)
            if result then
                ScenarioFramework.Dialogue(OpStrings.M3CounterAttackDefeated, M3MapExpansionTimer, true)
            end
        end
    )

    ChooseRandomEvent()

    -----------
    -- Triggers
    -----------
    -- Objective to locate Orbital Cannons
    ScenarioFramework.CreateTimerTrigger(M3LocateOrbitalCannons, 30)

    -- Unlock RAS
    ScenarioFramework.CreateTimerTrigger(M3RASUnlock, 2*60)

    -- Secondary objective to kill Aeon ACU
    ScenarioFramework.CreateArmyIntelTrigger(M3SecondaryKillAeonACU, ArmyBrains[Player1], 'LOSNow', false, true, categories.COMMAND, true, ArmyBrains[Aeon])

    -- Base Triggers
    -- Add Land factories to the main base
    ScenarioFramework.CreateTimerTrigger(M3AeonAI.AddLandFactories, 4*60)

    -- Add Air factories to the main base
    ScenarioFramework.CreateTimerTrigger(M3AeonAI.AddAirFactories, 8*60)

    -- Add defenses to the main base on medium and hard difficulty
    if Difficulty >= 2 then
        ScenarioFramework.CreateTimerTrigger(M3AeonAI.AddDefenses, 12*60)
    end

    -- Add Naval factories to the main base
    ScenarioFramework.CreateTimerTrigger(M3AeonAI.AddNavalFactories, 16*60)

    -- Add reesources to the main base on high difficulty
    if Difficulty >= 3 then
        ScenarioFramework.CreateTimerTrigger(M3AeonAI.AddResources, 20*60)
    end
end

function M3LocateOrbitalCannons()
    ScenarioFramework.Dialogue(OpStrings.M3LocateOrbitalCannons, nil, true)

    local units = ArmyBrains[Aeon]:GetListOfUnits(categories.uab2302, false)
    --------------------------------------------
    -- Primary Objective - Locate Orbital Cannons
    --------------------------------------------
    ScenarioInfo.M3P2 = Objectives.Locate(
        'primary',
        'incomplete',
        OpStrings.M3P2Title,
        OpStrings.M3P2Description,
        {
            Units = units,
        }
    )
    ScenarioInfo.M3P2:AddResultCallback(
        function(result)
            if result then
                ScenarioFramework.Dialogue(OpStrings.M3OrbitalCannonSpotted, M3MapExpansionTimer, true)
            end
        end
    )

    -- Reminder
    ScenarioFramework.CreateTimerTrigger(M3P2Reminder, 10*60)
end

function M3RASUnlock()
    ScenarioFramework.Dialogue(OpStrings.M3RASUnlock)
    ScenarioFramework.RestrictEnhancements({
        -- Allowed: AdvancedEngineering, Capacitator, GunUpgrade, RapidRepair, MovementSpeedIncrease, ResourceAllocation
        'IntelProbe',
        'IntelProbeAdv',
        'DoubleGuns',
        'RapidRepair',
        'PowerArmor',
        'T3Engineering',
        'OrbitalBombardment'
    })
end

function M3sACUM2Northbase()
    ScenarioInfo.M3sACU = ScenarioFramework.SpawnCommander('Aeon', 'M3_Aeon_sACU', 'Gate', false, false, false,
        {'EngineeringFocusingModule', 'ResourceAllocation'})

    local platoon = ArmyBrains[Aeon]:MakePlatoon('', '')
    ArmyBrains[Aeon]:AssignUnitsToPlatoon(platoon, {ScenarioInfo.M3sACU}, 'Support', 'AttackFormation')

    ScenarioFramework.PlatoonMoveChain(platoon, 'M3_Aeon_sACU_Move_Chain')

    local function AddsACUToBase()
        local platoon = ScenarioInfo.M3sACU.PlatoonHandle
        platoon:StopAI()
        platoon.PlatoonData = {
            BaseName = 'M2_Aeon_North_Base',
            LocationType = 'M2_Aeon_North_Base',
        }
        platoon:ForkAIThread(import('/lua/AI/OpAI/BaseManagerPlatoonThreads.lua').BaseManagerSingleEngineerPlatoon)
    end

    ScenarioFramework.CreateUnitToMarkerDistanceTrigger(AddsACUToBase, ScenarioInfo.M3sACU, 'M2_Aeon_North_Base_Marker', 15)
end

function M3SecondaryKillAeonACU()
    ScenarioFramework.Dialogue(OpStrings.M3Secondary)

    ----------------------------------------
    -- Secondary Objective - Defeat Aeon ACU
    ----------------------------------------
    ScenarioInfo.M3S1 = Objectives.Kill(
        'secondary',
        'incomplete',
        OpStrings.M3S1Title,
        OpStrings.M3S1Description,
        {
            Units = {ScenarioInfo.M3AeonACU},
        }
    )
    ScenarioInfo.M3S1:AddResultCallback(
        function(result)
            if result then
                ScenarioFramework.Dialogue(OpStrings.M3SecondaryDone)

                -- Disable the main base
                M3AeonAI.DisableBase()
            end
        end
    )
end

function M3MapExpansionTimer()
    if Objectives.IsComplete(ScenarioInfo.M3P1) and Objectives.IsComplete(ScenarioInfo.M3P2) then
        WaitSeconds(30)

        ScenarioFramework.Dialogue(OpStrings.M3MapExpansion, IntroMission4, true)
    end
end

------------
-- Mission 4
------------
function IntroMission4()
    ScenarioFramework.FlushDialogueQueue()
    while ScenarioInfo.DialogueLock do
        WaitSeconds(0.2)
    end

    -- Debug check to prevent running the same code twice when skipping through the mission
    if ScenarioInfo.MissionNumber ~= 3 then
        return
    end
    ScenarioInfo.MissionNumber = 4

    ----------
    -- Aeon AI
    ----------
    -- North Orbital Base
    M4AeonAI.AeonM4OrbitalBaseNorthAI()

    -- South Orbital Base, if player didn't catch the transport in M2, else just Orbital Cannon with few defenses
    if not ScenarioInfo.M2EngineersKilled then
        M4AeonAI.AeonM4OrbitalBaseSouthAI()
    else
        ScenarioUtils.CreateArmyGroup('Aeon', 'M4_Aeon_Orbital_Base_South_D' .. Difficulty)
    end

    -- East Orbital Base
    ScenarioUtils.CreateArmyGroup('Aeon', 'M4_Aeon_Orbital_Base_East_D' .. Difficulty)
    HandleT3Arties()

    -- TML Outposts, location picked randomly
    ChooseRandomBases()

    -- Start building the Tempest
    M4BuildTempest()

    -- Extra resources outside of the bases
    ScenarioUtils.CreateArmyGroup('Aeon', 'M4_Aeon_Extra_Resources_D' .. Difficulty)

    -- Walls
    ScenarioUtils.CreateArmyGroup('Aeon', 'M4_Walls')

    -- Refresh build restriction in support factories and engineers
    ScenarioFramework.RefreshRestrictions('Aeon')

    -- Expand the map, no cinematics in this part
    ScenarioFramework.SetPlayableArea('M4_Area', true)

    -- Wreckages
    ScenarioUtils.CreateArmyGroup('Crystals', 'M4_Wrecks', true)

    -----------
    -- Civilian
    -----------
    ScenarioUtils.CreateArmyGroup('Aeon_Neutral', 'M4_Civilian_Town')

    -- Give initial resources to the AI
    local num = {10000, 12000, 14000}
    ArmyBrains[Aeon]:GiveResource('MASS', num[Difficulty])
    ArmyBrains[Aeon]:GiveResource('ENERGY', 30000)

    -- Tell player to destroy the orbital cannons
    ScenarioFramework.Dialogue(OpStrings.M4DestroyCannons, StartMission4, true)
end

function M4TMLOutpost(location)
    local units = {}
    local dialogue = OpStrings.M4TechUnlock1

    if location == 'North' then
        units = ScenarioUtils.CreateArmyGroup('Aeon', 'M4_TML_Outpost_North_D' .. Difficulty)
    elseif location == 'Centre' then
        units = ScenarioUtils.CreateArmyGroup('Aeon', 'M4_TML_Outpost_Centre_D' .. Difficulty)
    elseif location == 'South' then
        units = ScenarioUtils.CreateArmyGroup('Aeon', 'M4_TML_Outpost_South_D' .. Difficulty)
    elseif location == 'None' then
        -- Unlock dialogue without a warning as there's no TML outpost
        dialogue = OpStrings.M4TechUnlock2
    end

    WaitSeconds(45)
    ScenarioFramework.Dialogue(dialogue)

    -- Unlock TML/TMD
    ScenarioFramework.RemoveRestrictionForAllHumans(
        categories.inb2208 + -- Nomads TML
        categories.inb4204 + -- Nomads TMD
        categories.uab2108 + -- Aeon TML
        categories.uab4201,  -- Aeon TMD
        true
    )

    local delay = {105, 75, 45}
    WaitSeconds(delay[Difficulty])

    for _, v in units do
        if v and not v:IsDead() and EntityCategoryContains(categories.TACTICALMISSILEPLATFORM, v) then
            local plat = ArmyBrains[Aeon]:MakePlatoon('', '')
            ArmyBrains[Aeon]:AssignUnitsToPlatoon(plat, {v}, 'Attack', 'NoFormation')
            plat:ForkAIThread(plat.TacticalAI)
            WaitSeconds(4)
        end
    end
end

function StartMission4()
    ---------------------------------------------
    -- Primary Objective - Destroy Orbital Cannons
    ---------------------------------------------
    ScenarioInfo.M4P1 = Objectives.CategoriesInArea(
        'primary',
        'incomplete',
        OpStrings.M4P1Title,
        OpStrings.M4P1Description,
        'kill',
        {
            MarkUnits = true,
            MarkArea = true,
            Requirements = {
                {
                    Area = 'M3_Aeon_Orbital_Base_Area',
                    Category = categories.uab2302,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Aeon,
                },
                {
                    Area = 'M4_Aeon_Orbital_Base_North_Area',
                    Category = categories.uab2302,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Aeon,
                },
                {
                    Area = 'M4_Aeon_Orbital_Base_East_Area',
                    Category = categories.uab2302,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Aeon,
                },
                {
                    Area = 'M4_Aeon_Orbital_Base_South_Area',
                    Category = categories.uab2302,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = Aeon,
                },
            },
        }
    )
    ScenarioInfo.M4P1:AddProgressCallback(
        function(current, total)
            if current == 1 then
                ScenarioFramework.Dialogue(OpStrings.M4OrbicalCannonDestroyed1)
            elseif current == 2 then
                ScenarioFramework.Dialogue(OpStrings.M4OrbicalCannonDestroyed2)
            elseif current == 3 then
                ScenarioFramework.Dialogue(OpStrings.M4OrbicalCannonDestroyed3)
            end
        end
    )
    ScenarioInfo.M4P1:AddResultCallback(
        function(result)
            if result then
                ScenarioFramework.Dialogue(OpStrings.M4OrbicalCannonDestroyed4, nil, true)
            end
        end
    )

    -- Objective group to handle winning, Orbital cannons and reclaiming crystals
    ScenarioInfo.M4Objectives = Objectives.CreateGroup('M4Objectives', PlayerWin)
    ScenarioInfo.M4Objectives:AddObjective(ScenarioInfo.M4P1)
    if ScenarioInfo.M1P3.Active then
        ScenarioInfo.M4Objectives:AddObjective(ScenarioInfo.M1P3)
    end
    if ScenarioInfo.M2P1.Active then
        ScenarioInfo.M4Objectives:AddObjective(ScenarioInfo.M2P1)
    end

    -- Reminder
    ScenarioFramework.CreateTimerTrigger(M4P1Reminder1, 15*60)

    -----------
    -- Triggers
    -----------
    -- Secondary objective to kill Tempest
    ScenarioFramework.CreateArmyIntelTrigger(M4SecondaryKillTempest, ArmyBrains[Player1], 'LOSNow', false, true, categories.uas0401, true, ArmyBrains[Aeon])

    ScenarioFramework.CreateTimerTrigger(M4UnlockFiendEngie, 7*60)
end

function M4UnlockFiendEngie()
    local function Unlock()
        ScenarioFramework.RemoveRestrictionForAllHumans(categories.inu3008, true)
    end

    -- First play the dialogue, then unlock
    ScenarioFramework.Dialogue(OpStrings.M4FieldEngieUnlock, Unlock)
end

function M4BuildTempest()
    -- Makes the Tempest take 24, 16, 8 minutes to build
    local multiplier = {0.3, 0.5, 1}

    BuffBlueprint {
        Name = 'Op3M4EngBuildRate',
        DisplayName = 'Op3M4EngBuildRate',
        BuffType = 'AIBUILDRATE',
        Stacks = 'REPLACE',
        Duration = -1,
        EntityCategory = 'ENGINEER',
        Affects = {
            BuildRate = {
                Add = 0,
                Mult = multiplier[Difficulty],
            },
        },
    }

    local engineer = ScenarioUtils.CreateArmyUnit('Aeon', 'M4_Engineer')
    -- Apply buff here
    Buff.ApplyBuff(engineer, 'Op3M4EngBuildRate')

    -- Trigger to kill the Tempest if the engineer dies
    ScenarioFramework.CreateUnitDestroyedTrigger(M4EngineerDead, engineer)

    ScenarioInfo.M4TempestEngineer = engineer

    local platoon = ArmyBrains[Aeon]:MakePlatoon('', '')
    platoon.PlatoonData = {}
    platoon.PlatoonData.NamedUnitBuild = {'M4_Tempest'}
    platoon.PlatoonData.NamedUnitBuildReportCallback = M4TempestBuildProgressUpdate
    platoon.PlatoonData.NamedUnitFinishedCallback = M4TempestFinishBuild

    ArmyBrains[Aeon]:AssignUnitsToPlatoon(platoon, {engineer}, 'Support', 'None')

    platoon:ForkAIThread(ScenarioPlatoonAI.StartBaseEngineerThread)
end

function M4EngineerDead(unit)
    local tempest = unit.UnitBeingBuilt
    if tempest and not tempest:IsDead() then
        tempest:Kill()
    end
end

local LastUpdate = 0
function M4TempestBuildProgressUpdate(unit, eng)
    if unit:IsDead() then
        return
    end

    if not unit.UnitPassedToScript then
        unit.UnitPassedToScript = true
        M4TempestStarted(unit)
    end

    local fractionComplete = unit:GetFractionComplete()
    if math.floor(fractionComplete * 100) > math.floor(LastUpdate * 100) then
        LastUpdate = fractionComplete
        M4TempestBuildPercentUpdate(math.floor(LastUpdate * 100))
    end
end

function M4TempestStarted(unit)
    ScenarioInfo.M4Tempest = unit

    ----------------------------------------------------------
    -- Bonus Objective - Destroy Tempest before it's completed
    ----------------------------------------------------------
    ScenarioInfo.M4B1 = Objectives.Kill(
        'bonus',
        'incomplete',
        OpStrings.M4B1Title,
        OpStrings.M4B1Description,
        {
            Units = {unit},
            MarkUnits = false,
            Hidden = true,
        }
    )
    ScenarioInfo.M4B1:AddResultCallback(
        function(result)
            if result then
                ScenarioInfo.M4TempestKilledUnfinished = true

                ScenarioFramework.Dialogue(OpStrings.M4TempestKilledUnfinished)
            end
        end
    )
end

function M4TempestBuildPercentUpdate(percent)
    if percent == 25 and ScenarioInfo.M4TempestObjectiveAssigned and not ScenarioInfo.M4Tempest25Dialogue then
        ScenarioInfo.M4Tempest25Dialogue = true
        ScenarioFramework.Dialogue(OpStrings.M4Tempest25PercentDone)
    elseif percent == 50 and ScenarioInfo.M4TempestObjectiveAssigned and not ScenarioInfo.M4Tempest50Dialogue then
        ScenarioInfo.M4Tempest50Dialogue = true
        ScenarioFramework.Dialogue(OpStrings.M4Tempest50PercentDone)
    elseif percent == 75 and ScenarioInfo.M4TempestObjectiveAssigned and not ScenarioInfo.M4Tempest75Dialogue then
        ScenarioInfo.M4Tempest75Dialogue = true
        ScenarioFramework.Dialogue(OpStrings.M4Tempest75PercentDone)
    elseif percent == 90 and ScenarioInfo.M4TempestObjectiveAssigned and not ScenarioInfo.M4Tempest90Dialogue then
        ScenarioInfo.M4Tempest90Dialogue = true
        ScenarioFramework.Dialogue(OpStrings.M4Tempest90PercentDone)
    end
end

function M4SecondaryKillTempest()
    if ScenarioInfo.M4TempestObjectiveAssigned then
        return
    end
    ScenarioInfo.M4TempestObjectiveAssigned = true

    local dialogue = OpStrings.M4TempestSpottedUnfinished
    local description = OpStrings.M4S1Description1

    -- Different dialogue and mission description if the tempest is finished
    if not ScenarioInfo.M4B1.Active then
        dialogue = OpStrings.M4TempestBuilt
        description = OpStrings.M4S1Description2
    end

    ScenarioFramework.Dialogue(dialogue)
    
    ----------------------------------------
    -- Secondary Objective - Destroy Tempest
    ----------------------------------------
    ScenarioInfo.M4S1 = Objectives.Kill(
        'secondary',
        'incomplete',
        OpStrings.M4S1Title,
        description,
        {
            Units = {ScenarioInfo.M4Tempest},
        }
    )
    ScenarioInfo.M4S1:AddResultCallback(
        function(result)
            if result then
                if not ScenarioInfo.M4TempestKilledUnfinished then
                    ScenarioFramework.Dialogue(OpStrings.M4TempestKilled)
                end
            end
        end
    )
end

function M4TempestFinishBuild(unit)
    if not unit or unit:IsDead() then
        return
    end

    if ScenarioInfo.M4B1.Active then
        ScenarioInfo.M4B1:ManualResult(false)
    end

    -- If the secondary objective is assigned already, inform player that the Tempest is done
    if ScenarioInfo.M5S1.Active then
        ScenarioFramework.Dialogue(OpStrings.M4Tempest100PercentDone)
    end

    M4SecondaryKillTempest()

    ForkThread(M4TempestAI, unit)
end

function M4TempestAI(unit)
    local platoon = ArmyBrains[Aeon]:MakePlatoon('', '')
    ArmyBrains[Aeon]:AssignUnitsToPlatoon(platoon, {unit}, 'Attack', 'None')

    ScenarioFramework.PlatoonPatrolChain(platoon, 'M4_Aeon_North_Base_Naval_Attack_Chain')
end

------------
-- Reminders
------------
function M1P2Reminder1()
    if ScenarioInfo.M1P2.Active then
        ScenarioFramework.Dialogue(OpStrings.M1AeonBaseReminder1)

        ScenarioFramework.CreateTimerTrigger(M1P2Reminder2, 600)
    end
end

function M1P2Reminder2()
    if ScenarioInfo.M1P2.Active then
        ScenarioFramework.Dialogue(OpStrings.M1AeonBaseReminder2)
    end
end

function M1P3Reminder1()
    if ScenarioInfo.M1P3.Active then
        ScenarioFramework.Dialogue(OpStrings.CrystalsReminder1)

        ScenarioFramework.CreateTimerTrigger(M1P3Reminder2, 20*60)
    end
end

function M1P3Reminder2()
    if ScenarioInfo.M1P3.Active then
        ScenarioFramework.Dialogue(OpStrings.CrystalsReminder2)

        ScenarioFramework.CreateTimerTrigger(M1P3Reminder3, 20*60)
    end
end

function M1P3Reminder3()
    if ScenarioInfo.M1P3.Active then
        ScenarioFramework.Dialogue(OpStrings.CrystalsReminder3)
    end
end

function M1S1Reminder()
    if ScenarioInfo.M1S1.Active then
        ScenarioFramework.Dialogue(OpStrings.M1SecondaryReminder)
    end
end

function M2P1Reminder()
    if ScenarioInfo.M2P1.Active then
        ScenarioFramework.Dialogue(OpStrings.M2CrystalsReminder)
    end
end

function M3P2Reminder()
    if ScenarioInfo.M3P2.Active then
        ScenarioFramework.Dialogue(OpStrings.M3LocateCannonsReminder)
    end
end

function M4P1Reminder1()
    if ScenarioInfo.M4P1.Active then
        ScenarioFramework.Dialogue(OpStrings.M4OrbitalCannonsReminder1)

        ScenarioFramework.CreateTimerTrigger(M4P1Reminder2, 20*60)
    end
end

function M4P1Reminder2()
    if ScenarioInfo.M4P1.Active then
        ScenarioFramework.Dialogue(OpStrings.M4OrbitalCannonsReminder2)
    end
end

--------------------------
-- Taunt Manager Dialogues
--------------------------
function SetupNicholsM1Warnings()
    -- Ship damaged to x
    NicholsTM:AddDamageTaunt('M1ShipDamaged', ScenarioInfo.CrashedShip, .90)
    NicholsTM:AddDamageTaunt('M1ShipHalfDead', ScenarioInfo.CrashedShip, .95)
    NicholsTM:AddDamageTaunt('M1ShipAlmostDead', ScenarioInfo.CrashedShip, .98)
end

function SetupAeonM2Taunts()
end

function SetupAeonM3Taunts()
end

-------------------
-- Custom Functions
-------------------
-- Changes army color of the crystals
function RainbowEffect()
    local i = 1
    local frequency = math.pi * 2 / 255

    while not ScenarioInfo.OpEnded do
        WaitSeconds(0.1)

        if i >= 255 then i = 255 end

        local red   = math.sin(frequency * i + 2) * 127 + 128
        local green = math.sin(frequency * i + 0) * 127 + 128
        local blue  = math.sin(frequency * i + 4) * 127 + 128

        SetArmyColor('Crystals', red, green, blue)

        if i >= 255 then i = 1 end

        i = i + 1
    end
end

--- Handles reclaimed crystals
-- Adds max and current HP, resource production and other bonuses
function CrystalReclaimed(number)
    local tbl = CrystalBonuses[number]

    -- Increase HP
    ShipMaxHP = tbl.maxHP
    ScenarioInfo.CrashedShip:AdjustHealth(ScenarioInfo.CrashedShip, tbl.addHP)

    -- Add resource production
    if tbl.addProduction then
        ScenarioInfo.CrashedShip:SetProductionPerSecondEnergy(tbl.addProduction.energy)
        ScenarioInfo.CrashedShip:SetProductionPerSecondMass(tbl.addProduction.mass)
    end
end

-- Monitors Ships health and adjusts it depending on the mission progress
function ShipHPThread()
    local ship = ScenarioInfo.CrashedShip
    local originalMaxHP = ScenarioInfo.CrashedShip:GetMaxHealth()

    while true do
        if ShipMaxHP == originalMaxHP then
            return
        end

        local hp = ScenarioInfo.CrashedShip:GetHealth()
        if hp > ShipMaxHP then
            ship:SetHealth(ship, ShipMaxHP)
        end

        WaitSeconds(.1)
    end
end

-- Hold fire and set uncapturable
function HandleT3Arties()
    for _, v in ArmyBrains[Aeon]:GetListOfUnits(categories.uab2302, false) do
        v:SetFireState('HoldFire')
        v:SetCapturable(false)
    end
end

function SpawnArtillery()
    -- More storage for arty reload
    ArmyBrains[Crashed_Ship]:GiveStorage('ENERGY', 100000)
    ArmyBrains[Crashed_Ship]:GiveResource('ENERGY', 100000)

    -- Spawn arty
    ScenarioInfo.ArtilleryGun = ScenarioUtils.CreateArmyUnit('Crashed_Ship', 'Orbital_Artillery')
    ScenarioInfo.ArtilleryGun:SetCanTakeDamage(false)
    ScenarioInfo.ArtilleryGun:SetCanBeKilled(false)
    ScenarioInfo.ArtilleryGun:SetDoNotTarget(true)
    ScenarioInfo.ArtilleryGun:SetIntelRadius('Vision', 0)
    ScenarioInfo.ArtilleryGun:SetFireState('HoldFire')

    -- Wait for the satellite to spawn
    while not ScenarioInfo.ArtilleryGun.ArtilleryUnit do
        WaitSeconds(1)
    end

    -- Teleport it to the crashed ship
    Warp(ScenarioInfo.ArtilleryGun.ArtilleryUnit, ScenarioUtils.MarkerToPosition('Artillery_Marker'))

    -- Set up attack ping for players
    SetUpArtilleryPing(true)
end

function SetUpArtilleryPing(skipDialogue)
    if not skipDialogue then
        ScenarioFramework.Dialogue(OpStrings.ArtilleryGunReady)
    end

    ScenarioInfo.AttackPing = PingGroups.AddPingGroup(OpStrings.ArtilleryGunTitle, nil, 'attack', OpStrings.ArtilleryGunDescription)
    ScenarioInfo.AttackPing:AddCallback(ArtilleryAttackLocation)
end

function ArtilleryAttackLocation(location)
    ForkThread(
        function(location)
            ScenarioInfo.ArtilleryGun:SetFireState('ReturnFire')

            IssueStop({ScenarioInfo.ArtilleryGun})
            IssueClearCommands({ScenarioInfo.ArtilleryGun})

            IssueAttack({ScenarioInfo.ArtilleryGun}, location)

            ScenarioInfo.AttackPing:Destroy()

            WaitSeconds(40)

            ScenarioInfo.ArtilleryGun:SetFireState('HoldFire')

            ScenarioFramework.CreateTimerTrigger(SetUpArtilleryPing, 5*60)
        end, location
    )
end


-- Functions for randomly picking scenarios
function ChooseRandomBases()
    local data = ScenarioInfo.OperationScenarios['M' .. ScenarioInfo.MissionNumber].Bases

    if not ScenarioInfo.MissionNumber then
        error('*RANDOM BASE: ScenarioInfo.MissionNumber needs to be set.')
    elseif not data then
        error('*RANDOM BASE: No bases specified for mission number: ' .. ScenarioInfo.MissionNumber)
    end

    for _, base in data do
        local num = Random(1, table.getn(base.Types))

        base.CallFunction(base.Types[num])
    end
end

function ChooseRandomEvent(useDelay, customDelay)
    local data = ScenarioInfo.OperationScenarios['M' .. ScenarioInfo.MissionNumber].Events
    local num = ScenarioInfo.MissionNumber

    if not num then
        error('*RANDOM EVENT: ScenarioInfo.MissionNumber needs to be set.')
    elseif not data then
        error('*RANDOM EVENT: No events specified for mission number: ' .. num)
    end
    
    -- Randomly pick one event
    local function PickEvent(tblEvents)
        local availableEvents = {}
        local event

        -- Check available events
        for _, event in tblEvents do
            if not event.Used then
                table.insert(availableEvents, event)
            end
        end

        -- Pick one, mark as used
        local num = table.getn(availableEvents)

        if num ~= 0 then
            local event = availableEvents[Random(1, num)]
            event.Used = true

            return event
        else
            -- Reset availability and try to pick again
            for _, event in tblEvents do
                event.Used = false
            end
            
            return PickEvent(tblEvents)
        end
    end

    local event = PickEvent(data)

    ForkThread(StartEvent, event, num, useDelay, customDelay)
end

function StartEvent(event, missionNumber, useDelay, customDelay)
    if useDelay or useDelay == nil then
        local waitTime = customDelay or event.Delay -- Delay passed as a function parametr can over ride the delay from the OperationScenarios table
        local Difficulty = ScenarioInfo.Options.Difficulty

        if type(waitTime) == 'table' then
            WaitSeconds(waitTime[Difficulty])
        else
            WaitSeconds(waitTime)
        end
    end

    -- Check if the mission didn't end while we were waiting
    if ScenarioInfo.MissionNumber ~= missionNumber then
        return
    end

    event.CallFunction()
end

------------------
-- Debug Functions
------------------
function OnCtrlF3()
    ForkThread(M2EnemyACUNIS)
end

function OnCtrlF4()
    if ScenarioInfo.MissionNumber == 1 then
        M1CrystalsObjective()
        ForkThread(IntroMission2)
    elseif ScenarioInfo.MissionNumber == 2 then
        ForkThread(IntroMission3)
    elseif ScenarioInfo.MissionNumber == 3 then
        ForkThread(IntroMission4)
    end
end

function OnShiftF3()
    ForkThread(SpawnArtillery)
end

function OnShiftF4()
    for _, v in ArmyBrains[Aeon]:GetListOfUnits(categories.ALLUNITS - categories.WALL, false) do
        v:Kill()
    end
end

