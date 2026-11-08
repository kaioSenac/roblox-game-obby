local Players = game:GetService("Players")

local M = {}

M.ADMIN_USERS_IDS = {
	9432540091
}

function M.getPlayerByName(name: string): Player?
	local players = Players:GetPlayers()
	local player

	for _, _player in players do
		if _player.Name == name then
			player = _player
		end
	end

	if not player then
		return
	end
	
	return player
end

function M.isAdmin(player: Player): boolean
	return table.find(M.ADMIN_USERS_IDS, player.UserId) ~= nil
end

function M.getPlayerByUserId(userId: number): Player?
	local player = Players:GetPlayerByUserId(userId)
	if not player then
		return
	end
	
	return player
end

return M