local AIUtils = import('/lua/ai/aiutilities.lua')
local Objectives = import('/lua/SimObjectives.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local SPAIFileName = '/lua/ScenarioPlatoonAI.lua'

function Reclaim(Type, Complete, Title, Description, Target)
    Target.reclaimed = 0
    Target.total = table.getn(Target.Units)
    local numRequired = Target.NumRequired or Target.total

    local image = Objectives.GetActionIcon("reclaim")
    local objective = Objectives.AddObjective(Type, Complete, Title, Description, image, Target)

    objective.ManualResult = function(self, result)
        self.Active = false
        self:OnResult(result)
        local resultStr
        if result then
            resultStr = 'complete'
        else
            resultStr = 'failed'
        end
        Objectives.UpdateObjective(Title, 'complete', resultStr, self.Tag)
    end

    objective.OnUnitReclaimed  = function(unit)
        if not objective.Active then
            return
        end

        Target.reclaimed = Target.reclaimed + 1
        local progress = string.format('(%s/%s)', Target.reclaimed, Target.total)
        objective:OnProgress(Target.reclaimed, Target.total)
        Objectives.UpdateObjective(Title, 'Progress', progress, objective.Tag)
        if Target.reclaimed == numRequired then
            objective.Active = false
            objective:OnResult(true)
            Objectives.UpdateObjective(Title, 'complete', "complete", objective.Tag)
        end
    end

    objective.OnUnitKilled = function(unit)
        if not objective.Active then
            return
        end
        objective.Active = false
        objective:OnResult(false)
        Objectives.UpdateObjective(Title, 'complete', 'failed', objective.Tag)
    end

    -- If the unit is captured it can still be reclaimed to complete the
    -- objective, so track the new unit created on a capture.
    objective.OnUnitCaptured = function(newUnit, captor)
        if not objective.Active then
            return
        end
        Objectives.OnUnitGivenBase(objective, Target, nil, newUnit, true)
        Objectives.CreateTriggers(newUnit, objective)
    end

    objective.OnUnitGiven = function(unit, newUnit)
        if not objective.Active then
            return
        end
        Objectives.OnUnitGivenBase(objective, Target, unit, newUnit, true)
        Objectives.CreateTriggers(newUnit, objective)
    end

    objective.AddTargetUnits = function(self, units)
        if not objective.Active then
            return
        end
        for _, unit in units do
            local ObjectiveArrow = import('/lua/objectiveArrow.lua').ObjectiveArrow
            local arrow = ObjectiveArrow {AttachTo = unit}
            Objectives.CreateTriggers(unit, objective)
            objective:AddUnitTarget(unit)
            Target.total = Target.total + 1
        end
        local progress = string.format('(%s/%s)', Target.reclaimed, Target.total)
        Objectives.UpdateObjective(Title, 'Progress', progress, objective.Tag)
    end

    for _, unit in Target.Units do
        local ObjectiveArrow = import('/lua/objectiveArrow.lua').ObjectiveArrow
        local arrow = ObjectiveArrow {AttachTo = unit}
        Objectives.CreateTriggers(unit, objective)
    end

    local progress = string.format('(%s/%s)', Target.reclaimed, Target.total)
    Objectives.UpdateObjective(Title, 'Progress', progress, objective.Tag)

    return objective
end

--- Build condition
-- Checks if any of the player's ACUs is close to the base
function PlayersACUsNearBase(aiBrain, baseName, distance)
    local bManager = aiBrain.BaseManagers[baseName]
    if not bManager then return false end

    local bPosition = bManager:GetPosition()
    if not distance then
        distance = bManager:GetRadius()
    end

    for _, v in ScenarioInfo.PlayersACUs or {} do
        if not v:IsDead() then
            local position = v:GetPosition()
            local value = VDist2(position[1], position[3], bPosition[1], bPosition[3])

            if value <= distance then
                return true
            end
        end
    end
    return false
end

--- Tries to attack the closest ACU to the base, else patrols
function MercyThread(platoon)
    local data = platoon.PlatoonData
    local aiBrain = platoon:GetBrain()
    local bManager = aiBrain.BaseManagers[data.Base]
    local bPosition = bManager:GetPosition()

    local target = false
    for _, v in ScenarioInfo.PlayersACUs or {} do
        if not v:IsDead() then
            local position = v:GetPosition()
            local value = VDist2(position[1], position[3], bPosition[1], bPosition[3])

            if value <= data.Distance and platoon:CanAttackTarget('Attack', v) then
                target = v
                break
            end
        end
    end

    if target then
        platoon:AttackTarget(target)
        platoon:AggressiveMoveToLocation(ScenarioUtils.MarkerToPosition('Player1'))
    else
        import(SPAIFileName).PatrolThread(platoon)
    end
end

--- Build condition
-- Returns true if mass in storage of <aiBrain> is less than <mStorage>
function LessMassStorageCurrent(aiBrain, mStorage)
    local econ = AIUtils.AIGetEconomyNumbers(aiBrain)
    if econ.MassStorage < mStorage then
        return true
    end
    return false
end

--- Build condition
function HaveGreaterThanUnitsWithCategoryInArea(aiBrain, numReq, category, area)
    local numUnits = ScenarioFramework.NumCatUnitsInArea(category, ScenarioUtils.AreaToRect(area), aiBrain)
    if numUnits < numReq then
        return true
    end
    return false
end