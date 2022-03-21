local Players = game:GetService('Players')
local DataStoreService = game:GetService("DataStoreService")

local winsStore = DataStoreService:GetDataStore("playerWins")

local ServerStorage = game:GetService("ServerStorage")

local ServerStorageData = ServerStorage.Data

local function onPlayerAdded(player)
	local leaderstats = Instance.new("Folder")

	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	--wins
	local wins = Instance.new('IntValue')

	wins.Name = 'Wins'
	wins.Value = 0

	local getSuccess, currentWins = pcall(function()
		return winsStore:GetAsync(player.UserId)
	end)

	if getSuccess then
		wins.Value = currentWins
	end

	wins.Parent = leaderstats

	local winsClone = wins:Clone()

	winsClone.Name = player.UserId

	winsClone.Parent = ServerStorageData.Wins
end


local function onPlayerRemoved(player)
	local wins = ServerStorageData.Wins[player.UserId]

	local getSuccess, errorMessage = pcall(function()
		winsStore:SetAsync(player.UserId, wins.Value)
	end)

	if not getSuccess then
		warn(errorMessage)
	end

	ServerStorageData.Wins[player.UserId]:Destroy()
end

Players.PlayerRemoving:Connect(onPlayerRemoved)

Players.PlayerAdded:Connect(onPlayerAdded)
