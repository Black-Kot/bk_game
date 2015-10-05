-- Some variables you can change

-- How often (in seconds) player can teleport
-- Set it to 0 to disable
local cooldown = 0
-- Max distance player can teleport, otherwise he will see error messsage
-- Set it to 0 to disable
local max_distance = 0
----------------------------------

local last_moved = {}

local function get_time()
	return os.time()
end

local function distance(a, b)
	return math.sqrt(math.pow(a.x-b.x, 2) + math.pow(a.y-b.y, 2) + math.pow(a.z-b.z, 2))
end

local function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end


minetest.register_chatcommand("sethome", {
	params = "",
	description = "",
	func = function(name, param)
        local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Are you a ghost?"
		end
        local pos = player:getpos()
        bk_game.kv.set(name, pos, "home")
		return true, "Home set!"
	end,
})
minetest.register_chatcommand("home", {
	params = "",
	description = "",
	func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then
			return false
		end
		if bk_game.kv.get(name, "home") then
			local time = get_time()
            if cooldown ~= 0 and last_moved[name] ~= nil and time - last_moved[name] < cooldown then
				return false, "You can teleport only once in "..cooldown.." seconds. Wait another "..round(cooldown - (time - last_moved[name]), 3).." secs..."
			end
			local pos = player:getpos()
			local dst = distance(pos, bk_game.kv.get(name, "home"))
			if max_distance ~= 0 and distance(pos, bk_game.kv.get(name, "home")) > max_distance then
				return false, "You are too far away from your home. You must be "..round(dst - max_distance, 3).." nodes closer to teleport to your home."
			end
			last_moved[name] = time
			player:setpos(bk_game.kv.get(name, "home"))
            return true, "Teleported to home!"
        else
            return false, "You don't have a home now! Set it using /sethome"
        end
        return true
	end,
})
