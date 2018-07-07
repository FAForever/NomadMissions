function IssueGuardOrder(platoon)
	local data = platoon.PlatoonData
	if data then
		if data.UnitToGuard then
			for _, unit in platoon:GetPlatoonUnits() do
				IssueGuard({unit}, data.UnitToGuard)
			end
		else
			error('*CUSTOM FUNCTIONS AI ERROR: Unit to guard not defined', 2)
		end
	else
		error('*CUSTOM FUNCTIONS AI ERROR: PlatoonData not defined', 2)
	end
end