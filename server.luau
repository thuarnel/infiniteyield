local replicatedStorage = game:GetService('ReplicatedStorage')
local remoteEvent = Instance.new('RemoteEvent')
remoteEvent.Name = 'IYEvent'
remoteEvent.OnServerEvent:Connect(function(speaker: Player, action: string, ...)
	if action == 'kill' then
		local players = ...
		
		if type(players) ~= 'table' then
			players = {speaker}
		end
		
		for _, player in pairs(players) do
			local character = player.Character
			local humanoid = character and character:FindFirstChildWhichIsA('Humanoid')

			if humanoid then
				humanoid.Health = 0
			end
		end
	elseif action == 'respawn' then
		local players = ...

		if type(players) ~= 'table' then
			players = {speaker}
		end

		for _, player in pairs(players) do
			coroutine.wrap(player.LoadCharacter)(player)
		end
	elseif action == 'refresh' then
		local players = ...

		if type(players) ~= 'table' then
			players = {speaker}
		end

		for _, player in pairs(players) do
			task.spawn(function()
				local character = player.Character
				local humanoid = character and character:FindFirstChildWhichIsA('Humanoid')
				local rootpart = humanoid and humanoid.RootPart
				local rootCFrame = rootpart and rootpart.CFrame

				character = nil
				player:LoadCharacter()
				while not character do
					character = player.Character
					wait()
				end
				if typeof(character) == 'Instance' and character:IsA('Model') and typeof(rootCFrame) == 'CFrame' then
					local position = rootCFrame.Position
					local lookVector = rootCFrame.LookVector * Vector3.new(1, 0, 1)
					local newCFrame = CFrame.lookAt(position, position + lookVector)
					character:PivotTo(newCFrame)
				end
			end)
		end
	end
end)
remoteEvent.Parent = replicatedStorage