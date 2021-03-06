-- Some variables you can change

-- How often (in seconds) player can teleport
-- Set it to 0 to disable
local cooldown = 0
-- Max distance player can teleport, otherwise he will see error messsage
-- Set it to 0 to disable
local max_distance = 0
----------------------------------

local homes_file = minetest.get_worldpath().."/homes"
local homepos = {}
local last_moved = {}

local function loadhomes()
    local input = io.open(homes_file, "r")
    if input == nil then
		return
    end
    local text = ""
	for line in input:lines() do
		text = text..line
	end
    homepos = minetest.deserialize(text)
    io.close(input)
end

loadhomes()

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

local changed = false

minetest.register_chatcommand("sethome", {
	params = "",
	description = "",
	func = function(name, param)
        local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Unknown player"
		end
        local pos = player:getpos()
        homepos[name] = pos
        changed = true
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
		if homepos[name] then
			local time = get_time()
            if cooldown ~= 0 and last_moved[name] ~= nil and time - last_moved[name] < cooldown then
				return false, "You can teleport only once in "..cooldown.." seconds. Wait another "..round(cooldown - (time - last_moved[name]), 3).." secs..."
			end
			local pos = player:getpos()
			local dst = distance(pos, homepos[name])
			if max_distance ~= 0 and distance(pos, homepos[name]) > max_distance then
				return false, "You are too far away from your home. You must be "..round(dst - max_distance, 3).." meters closer to teleport to your home."
			end
			last_moved[name] = time
			player:setpos(homepos[name])
            return true, "Teleported to home!"
        else
            return false, "You don't have a home now! Set it using /sethome"
        end
        return true
	end,
})

local delta = 0

minetest.register_globalstep(function(dtime)
	if changed then
		local output = io.open(homes_file, "w")
		local text = minetest.serialize(homepos)
		output:write(text)
		io.close(output)
		changed = false
    end
end)
