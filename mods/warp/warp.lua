local warps = bk_game.kv.get("warps", "warp")

local function teleport(name, param)
	local warp = param
    if warps[warp] then
        local player = minetest.get_player_by_name(name)
		if not player then return false, "Are you serious?" end
        minetest.chat_send_player(name, "Teleporting to "..warp.."...")
        player:setpos(warps[warp])
        return true, "Done"
    else
		return false, "Unknown warp"
	end
end

minetest.register_privilege("warp", {
	description = "Ability to add and remove warps",
	give_to_singleplayer = false,
})

minetest.register_chatcommand("addwarp", {
	params = "<name>",
	description = "Add new warp",
	privs = {warp=true},
	func = function(name, param)
		local warp = param
		local player = minetest.get_player_by_name(name)
		if not player then return false, "Are you serious?" end
		local pos = player:getpos()
		warps[warp] = pos
		bk_game.kv.set("warps", warps, "warp")
		return true, "Done"
	end,
})

minetest.register_chatcommand("removewarp", {
	params = "<name>",
	description = "Remove warp",
	privs = {warp=true},
	func = function(name, param)
		local name = param
		warps[name] = nil  -- This will remove warp from the table
		bk_game.kv.set("warps", warps, "warp")  -- Update storage
		return true, "Done"
	end,
})

minetest.register_chatcommand("warp", {
	params = "<name>",
	description = "Warp",
	func = teleport,
})

-- Shorthand for /warp
minetest.register_chatcommand("w", {
	params = "<name>",
	description = "Shorthand for /warp",
	func = teleport,
})

minetest.register_chatcommand("warps", {
	params = "<name>",
	description = "List all warps",
	func = function(name, param)
		for k, v in pairs(warps) do
			minetest.chat_send_player(name, k)
		end
	end,
})
