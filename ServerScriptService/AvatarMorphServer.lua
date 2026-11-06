local Players = game:GetService("Players")

-- Replace this example ID with your Roblox UserId.
local ADMIN_USER_IDS = {
	[123456789] = true,
}

local MAX_USERNAME_LENGTH = 20
local COMMAND_COOLDOWN_SECONDS = 3
local originalStates = {}
local lastCommandAt = {}

local function getHumanoid(player)
	local character = player.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function sendMessage(player, message)
	local character = player.Character
	if character then
		local success = pcall(function()
			local head = character:FindFirstChild("Head")
			if head then
				game:GetService("Chat"):Chat(head, message, Enum.ChatColor.Blue)
			end
		end)
		if success then
			return
		end
	end
	print("[AvatarMorph] " .. player.Name .. ": " .. message)
end

local function morphPlayer(player, username)
	if #username == 0 or #username > MAX_USERNAME_LENGTH then
		return "Enter a valid Roblox username."
	end

	local humanoid = getHumanoid(player)
	if not humanoid then
		return "Your character is not ready yet."
	end

	local lookupSuccess, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)
	if not lookupSuccess then
		return "That Roblox username could not be found."
	end

	local descriptionSuccess, description = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(userId)
	end)
	if not descriptionSuccess then
		return "Roblox could not load that avatar right now."
	end

	if not originalStates[player] then
		originalStates[player] = {
			description = humanoid:GetAppliedDescription(),
			displayName = humanoid.DisplayName,
		}
	end

	local success, err = pcall(function()
		humanoid:ApplyDescriptionReset(description)
		humanoid.DisplayName = username
	end)
	if not success then
		warn("Avatar morph failed for " .. player.Name .. ": " .. tostring(err))
		return "The avatar could not be applied."
	end
	return "You are now using " .. username .. "'s avatar."
end

local function restorePlayer(player)
	local state = originalStates[player]
	if not state then
		return "You are not currently morphed."
	end
	local humanoid = getHumanoid(player)
	if not humanoid then
		return "Your character is not ready yet."
	end

	local success, err = pcall(function()
		humanoid:ApplyDescriptionReset(state.description)
		humanoid.DisplayName = state.displayName
	end)
	if not success then
		warn("Avatar restore failed for " .. player.Name .. ": " .. tostring(err))
		return "Your original avatar could not be restored."
	end
	originalStates[player] = nil
	return "Your original avatar has been restored."
end

local function handleCommand(player, message)
	if not ADMIN_USER_IDS[player.UserId] then
		return
	end
	local now = os.clock()
	if lastCommandAt[player] and now - lastCommandAt[player] < COMMAND_COOLDOWN_SECONDS then
		return
	end

	local command, argument = message:match("^/(%S+)%s*(.*)$")
	if not command then
		return
	end
	command = string.lower(command)
	argument = argument:match("^%s*(.-)%s*$")
	if command ~= "morph" and command ~= "unmorph" then
		return
	end
	lastCommandAt[player] = now

	local response
	if command == "morph" then
		response = argument == "" and "Usage: /morph username" or morphPlayer(player, argument)
	else
		response = restorePlayer(player)
	end
	sendMessage(player, response)
end

local function setupPlayer(player)
	player.Chatted:Connect(function(message)
		handleCommand(player, message)
	end)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(function(player)
	originalStates[player] = nil
	lastCommandAt[player] = nil
end)
for _, player in Players:GetPlayers() do
	setupPlayer(player)
end
