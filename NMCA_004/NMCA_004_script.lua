------------------------------
-- Nomad Campaign - Mission 4 Blood Runs Cold
--
-- Author: Shadowlorda1
------------------------------
local Buff = import('/lua/sim/Buff.lua')
local Cinematics = import('/lua/cinematics.lua')
local Objectives = import('/lua/ScenarioFramework.lua').Objectives
local ScenarioFramework = import('/lua/ScenarioFramework.lua')
local ScenarioPlatoonAI = import('/lua/ScenarioPlatoonAI.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local Utilities = import('/lua/Utilities.lua')  
local OpStrings = import('/maps/NMCA_004/NMCA_004_strings.lua')
local P1QAIAI = import('/maps/NMCA_004/QAIaiP1.lua')

ScenarioInfo.Player1 = 1
ScenarioInfo.Nomads = 2
ScenarioInfo.QAI = 3
ScenarioInfo.Player2 = 4
ScenarioInfo.Player3 = 5
ScenarioInfo.Player4 = 6

local Difficulty = ScenarioInfo.Options.Difficulty

local Player1 = ScenarioInfo.Player1
local Player2 = ScenarioInfo.Player2
local Player3 = ScenarioInfo.Player3
local Player4 = ScenarioInfo.Player4
local Nomads = ScenarioInfo.Nomads
local QAI = ScenarioInfo.QAI

local SkipNIS2 = false

local NIS1InitialDelay = 3

function OnPopulate(self)
    ScenarioUtils.InitializeScenarioArmies()
	
	ScenarioFramework.SetCybranEvilColor(QAI)
	
	local colors = {
    ['Player1'] = {225, 135, 62},
    ['Player2'] = {189, 183, 107},
    ['Player3'] = {255, 255, 165},
	['Nomads'] = {183, 101, 24},
    }
   
	
	   local tblArmy = ListArmies()
    for army, color in colors do
       if tblArmy[ScenarioInfo[army]] then
       ScenarioFramework.SetArmyColor(ScenarioInfo[army], unpack(color))
       end
    end

    SetArmyUnitCap(Nomads, 2000)
    SetArmyUnitCap(QAI, 2000)
	ScenarioFramework.SetSharedUnitCap(4000)
	
	ArmyBrains[QAI]:PBMSetCheckInterval(10)

end

function OnStart(self)

    ScenarioFramework.SetPlayableArea('AREA_1', false)   
    
	 for _, Player in ScenarioInfo.HumanPlayers do
        ScenarioFramework.AddRestriction(Player,
	        categories.TECH3 +  
			categories.EXPERIMENTAL	+
			categories.xnb4205 +
			categories.urb4203 
			)
	end
	
	ScenarioFramework.RestrictEnhancements({
        'IntelProbeAdv',
        'DoubleGuns',
        'PowerArmor',
        'T3Engineering',
        'OrbitalBombardment'
    })
	
	ScenarioUtils.CreateArmyGroup('Player1', 'P1Pbase1')
	ScenarioUtils.CreateArmyGroup('Nomads', 'P1ShipD')
	P1QAIAI.P1NBase1AI()
	P1QAIAI.P1NBase2AI()
	ScenarioUtils.CreateArmyGroup('QAI', 'P1Nukes')
	
	ScenarioInfo.NACU1 = ScenarioFramework.SpawnCommander('Nomads', 'Com1', false, 'Nomad commander', false, false)
	ScenarioInfo.NACU2 = ScenarioFramework.SpawnCommander('Nomads', 'Com2', false, 'Nomad commander', false, false)		

	units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P1NUnits1', 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
       ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P1NAirDefence2')))
    end
	
	units = ScenarioUtils.CreateArmyGroupAsPlatoon('Nomads', 'P1NUnits2', 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
       ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P1NAirDefence1')))
    end
	
	 -- Crashed Ship
    ScenarioInfo.CrashedShip = ScenarioUtils.CreateArmyUnit('Nomads', 'Ship1')
    ScenarioInfo.CrashedShip:SetCustomName('Crusier')
    ScenarioInfo.CrashedShip:SetReclaimable(false)
    ScenarioInfo.CrashedShip:SetCapturable(false) 
    -- Adjust the position
    local pos = ScenarioInfo.CrashedShip:GetPosition()
    ScenarioInfo.CrashedShip:SetPosition({pos[1], pos[2] - 3, pos[3]}, true)
    ScenarioInfo.CrashedShip:StopRotators()
	
	 -- Crashed Ship
    ScenarioInfo.CrashedShip1 = ScenarioUtils.CreateArmyUnit('Nomads', 'Ship2')
    ScenarioInfo.CrashedShip1:SetCustomName('Frigate')
    ScenarioInfo.CrashedShip1:SetReclaimable(false)
    ScenarioInfo.CrashedShip1:SetCapturable(false) 
    -- Adjust the position
    local pos = ScenarioInfo.CrashedShip1:GetPosition()
    ScenarioInfo.CrashedShip1:SetPosition({pos[1], pos[2] - 3, pos[3]}, true)
    ScenarioInfo.CrashedShip1:StopRotators()
	
	 -- Crashed Ship
    ScenarioInfo.CrashedShip2 = ScenarioUtils.CreateArmyUnit('Nomads', 'Ship3')
    ScenarioInfo.CrashedShip2:SetCustomName('Frigate')
    ScenarioInfo.CrashedShip2:SetReclaimable(false)
    ScenarioInfo.CrashedShip2:SetCapturable(false) 
    -- Adjust the position
    local pos = ScenarioInfo.CrashedShip2:GetPosition()
    ScenarioInfo.CrashedShip2:SetPosition({pos[1], pos[2] - 3, pos[3]}, true)
    ScenarioInfo.CrashedShip2:StopRotators()
	
	ForkThread(IntroP1)

end

function IntroP1()
    
	 if not SkipNIS2 then
    Cinematics.EnterNISMode()
    
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam1'), 0)
	
	ScenarioFramework.SpawnCommander( 'Player1', 'NACU1', 'Warp', true, true, false)
	ScenarioFramework.Dialogue(OpStrings.M1IntroP1, nil, true)
    WaitSeconds(6)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam2'), 3)
    WaitSeconds(4)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam3'), 3)
	WaitSeconds(3)
	ScenarioFramework.Dialogue(OpStrings.M1IntroP2, nil, true)
    Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam4'), 3)
	WaitSeconds(3)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam5'), 3)
	ScenarioFramework.Dialogue(OpStrings.M1IntroP3, nil, true)
	WaitSeconds(5)
	
	ForkThread(Nukeparty)
	
	local units = ScenarioUtils.CreateArmyGroupAsPlatoon('QAI', 'P1QAttack1', 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
       ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P1NAirDefence2')))
    end
	
	units = ScenarioUtils.CreateArmyGroupAsPlatoon('QAI', 'P1QAttack2', 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
       ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P1NAirDefence1')))
    end
	
	units = ScenarioUtils.CreateArmyGroupAsPlatoon('QAI', 'P1QAttack3' , 'AttackFormation')
                ScenarioFramework.PlatoonPatrolChain(units, 'P1QIntattack1' )
				
	units = ScenarioUtils.CreateArmyGroupAsPlatoon('QAI', 'P1QAttack4' , 'AttackFormation')
                ScenarioFramework.PlatoonPatrolChain(units, 'P1QIntattack2' )
				
	units = ScenarioUtils.CreateArmyGroupAsPlatoon('QAI', 'P1QAttack5' , 'AttackFormation')
                ScenarioFramework.PlatoonPatrolChain(units, 'P1QIntattack3' )
	
	units = ScenarioUtils.CreateArmyGroupAsPlatoon('QAI', 'P1QAttack6' , 'AttackFormation')
                ScenarioFramework.PlatoonPatrolChain(units, 'P1QIntattack4' )
	
	ScenarioUtils.CreateArmyGroup('QAI', 'P1Qwalls')
	P1QAIAI.P1Q1base1AI()
	P1QAIAI.P1Q1base2AI()
	
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam6'), 3)
	WaitSeconds(5)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam7'), 3)
	ScenarioFramework.Dialogue(OpStrings.M1IntroP4, nil, true)
	WaitSeconds(3)
	local basereval1 = ScenarioFramework.CreateVisibleAreaLocation(50, ScenarioUtils.MarkerToPosition('Vision1P1'), 0, ArmyBrains[Player1])
	
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam8'), 3)
	WaitSeconds(4)
	Cinematics.CameraMoveToMarker(ScenarioUtils.GetMarker('P1Cam1'), 2)
	
	ForkThread(
            function()
                WaitSeconds(1)
                basereval1:Destroy()
		    end
		)
	
    Cinematics.ExitNISMode()
	
	ForkThread(MissionP1)
	
	buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 2

       for _, u in GetArmyBrain(QAI):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end
	   
    buffDef = Buffs['CheatIncome']
    buffAffects = buffDef.Affects
    buffAffects.EnergyProduction.Mult = 1.5
    buffAffects.MassProduction.Mult = 1.5

       for _, u in GetArmyBrain(Nomads):GetPlatoonUniquelyNamed('ArmyPool'):GetPlatoonUnits() do
               Buff.ApplyBuff(u, 'CheatIncome')
       end	   		
	
	 else
	    ScenarioFramework.SpawnCommander( 'Player1', 'NACU1', 'Warp', true, true, false)
		ForkThread(MissionP1)
    end
	
end

function Nukeparty()

    local QAINuke = ArmyBrains[QAI]:GetListOfUnits(categories.urb2305, false)
	for k,v in QAINuke do
        v:GiveNukeSiloAmmo(2)
    end
    WaitSeconds(0.5)
    IssueNuke({QAINuke[1]}, ScenarioUtils.MarkerToPosition('P1Nuke1'))
    WaitSeconds(0.5)
    IssueNuke({QAINuke[1]}, ScenarioUtils.MarkerToPosition('P1Nuke2'))

end

function MissionP1()
    
	ScenarioUtils.CreateArmyGroup('QAI', 'P1SecondaryObjective')
	ScenarioInfo.Stealth = ScenarioUtils.CreateArmyUnit('QAI', 'SecObjP1')
    ScenarioInfo.Stealth:SetCustomName('Stealth Generator')
    ScenarioInfo.Stealth:SetReclaimable(false)
    ScenarioInfo.Stealth:SetCapturable(true)
    ScenarioInfo.Stealth:SetCanTakeDamage(false)
    ScenarioInfo.Stealth:SetDoNotTarget(true)	

	ScenarioFramework.CreateArmyIntelTrigger(M1SecondaryObjective, ArmyBrains[Player1], 'LOSNow', false, true, categories.urb5202, true, ArmyBrains[QAI])
	
	local units = ScenarioUtils.CreateArmyGroupAsPlatoon('QAI', 'P1QDefence1', 'GrowthFormation')
    for _, v in units:GetPlatoonUnits() do
       ScenarioFramework.GroupPatrolRoute({v}, ScenarioPlatoonAI.GetRandomPatrolRoute(ScenarioUtils.ChainToPositions('P1SecondaryAirD')))
    end
	
     ScenarioInfo.M1P1 = Objectives.CategoriesInArea(
        'primary',                      -- type
        'incomplete',                   -- complete
        'Destroy Cybran Bases',                 -- title
        'The Cybrans have betrayed us! Destroy the enemy bases in the area.',  -- description
        'kill',                         -- action
        {                               -- target
            MarkUnits = true,
			ShowProgress = true,
            Requirements = {
                {   
                    Area = 'ObjPart1',
                    Category = categories.FACTORY + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = QAI,
                },
				{   
                    Area = 'ObjPart2',
                    Category = categories.FACTORY + categories.TECH2 * categories.STRUCTURE * categories.ECONOMIC,
                    CompareOp = '<=',
                    Value = 0,
                    ArmyIndex = QAI,
                },
            },
        }
   )
    ScenarioInfo.M1P1:AddResultCallback(
    function(result)
	  if(result) then
		
	  end
	end
   )
   
    ScenarioInfo.M2P1 = Objectives.Protect(
     'primary',                      -- type
     'incomplete',                   -- complete
     'Protect the Fleet',    -- title
     'Several ships are still refueling, protect them.',  -- description
    
    {                              -- target
        Units = {ScenarioInfo.CrashedShip, ScenarioInfo.CrashedShip1, ScenarioInfo.CrashedShip2},
		 MarkUnits = true,
        }
    
   )
   ScenarioInfo.M2P1:AddResultCallback(
    function(result)
	if(result) then
     end
	end
	)

end

function M1SecondaryObjective()
    
	ScenarioFramework.Dialogue(OpStrings.SecondaryP1, nil, true)
	
    ScenarioInfo.M1P1S1 = Objectives.Capture(
     'secondary',                      -- type
     'incomplete',                   -- complete
     'Capture the Cybran Stealth Field Generator',    -- title
     'The Cybrans have powerful stealth tech, capture one so we may study it.',  -- description
    
    {                              -- target
        MarkUnits = true,
        Units = {ScenarioInfo.Stealth},
        }
    
   )
   ScenarioInfo.M1P1S1:AddResultCallback(
    function(result)
	if(result) then
	
		ForkThread(M1SecondaryObjectiveComplete)
     end
	end
	)

end

function M1SecondaryObjectiveComplete()
    
	ScenarioFramework.Dialogue(OpStrings.SecondaryCompleteP1, nil, true)
	
    local function Unlock()
        ScenarioFramework.RemoveRestrictionForAllHumans(categories.xnb4205 + categories.urb4203, true)

		end
		
end

function P1offmapattacks()



end
