-- Some variables you can change

-- How often (in seconds) mines file saves
local save_delta = 10
-- How often (in seconds) player can teleport
-- Set it to 0 to disable
local cooldown = 0
-- Max distance player can teleport, otherwise he will see error messsage
-- Set it to 0 to disable
local max_distance = 0
----------------------------------

local mines_file = minetest.get_modpath('setmine')..'/mines'
local minepos = {}
local last_moved = {}

local function loadmines()
    local input = io.open(mines_file, "r")
    while true do
        local x = input:read("*n")
        if x == nil then
            break
        end
        local y = input:read("*n")
        local z = input:read("*n")
        local name = input:read("*l")
        minepos[name:sub(2)] = {x = x, y = y, z = z}
    end
    io.close(input)
end

loadmines()

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

minetest.register_on_chat_message(function(name, message)
    if message == '/setmine' then
        local player = minetest.env:get_player_by_name(name)
        local pos = player:getpos()
        minepos[name] = pos
        minetest.chat_send_player(name, "Mine set!")
        changed = true
		return true
    elseif message == "/mine" then
        local player = minetest.env:get_player_by_name(name)
        if player == nil then
			-- just a check to prevent server death
			return false
		end
		if minepos[name] then
			local time = get_time()
            if cooldown ~= 0 and last_moved[name] ~= nil and time - last_moved[name] < cooldown then
				minetest.chat_send_player(name, "You can teleport only once in "..cooldown.." seconds. Wait another "..round(cooldown - (time - last_moved[name]), 3).." secs...")
				return true
			end
			local pos = player:getpos()
			local dst = distance(pos, minepos[name])
			if max_distance ~= 0 and distance(pos, minepos[name]) > max_distance then
				minetest.chat_send_player(name, "You are too far away from your mine. You must be "..round(dst - max_distance, 3).." meters closer to teleport to your mine.")
				return true
			end
			last_moved[name] = time
			player:setpos(minepos[name])
            minetest.chat_send_player(name, "Teleported to mine!")
        else
            minetest.chat_send_player(name, "You don't have a mine now! Set it using /setmine")
        end
        return true
    end
end)

local delta = 0
minetest.register_globalstep(function(dtime)
    delta = delta + dtime
    -- save it every <save_delta> seconds
    if delta > save_delta then
        delta = delta - save_delta
		if changed then
			local output = io.open(mines_file, "w")
			for i, v in pairs(minepos) do
				output:write(v.x.." "..v.y.." "..v.z.." "..i.."\n")
			end
			io.close(output)
		end
    end
end)
