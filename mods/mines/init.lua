-- Some variables you can change

-- How often (in seconds) mines file saves
local save_delta = 30
-- How often (in seconds) player can teleport
-- Set it to 0 to disable
local cooldown = 0
-- Max distance player can teleport, otherwise he will see error messsage
-- Set it to 0 to disable
local max_distance = 0
----------------------------------

local mines_file = minetest.get_worldpath()..'/mines'
local minepos = {}
local last_moved = {}

local function loadmines()
    local input = io.open(mines_file, "r")
    if input == nil then
		return
    end
    local text = ""
	for line in input:lines() do
		text = text..line
	end
    minepos = minetest.deserialize(text)
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

minetest.register_chatcommand("setmine" , {
	params = "<name>",
	description = "Set pos of mine",
	privs = {},
	func = function(name, param)
        local player = minetest.env:get_player_by_name(name)
        if player == nil then return end
		if param == "" then
            minetest.chat_send_player(name, "Name of mine can`t be null")
		end
        local pos = player:getpos()
        if not minepos[name] then
			minepos[name] = {}
		end
        minepos[name][param] = pos
        minetest.chat_send_player(name, "Mine "..param.." set!")
        changed = true
    end,
    
})

minetest.register_chatcommand("delmine" , {
	params = "<name>",
	description = "Del pos of mine",
	privs = {},
	func = function(name, param)
        local player = minetest.env:get_player_by_name(name)
        if player == nil then return end
		if param == "" then			
            minetest.chat_send_player(name, "Name of mine can`t be null")
		end        
        if not minepos[name] then
			minetest.chat_send_player(name, "You don't have a mine`s now! Set it using /setmine <name>")
			return
		end
		if minepos[name][param] then
            minetest.chat_send_player(name, "You don't have a mine "..n.." now! Set it using /setmine <name>")
            return
		end
		removekey(minepos[name][param], name) 
        minetest.chat_send_player(name, "Mine "..param.." delete`d!")
        changed = true
    end,
    
})
  
minetest.register_chatcommand("mine", {
	params = "<name>",
	description = "Teleport to mine",
	privs = {},
	func = function(name, param)
        local player = minetest.env:get_player_by_name(name)
        if player == nil then
			-- just a check to prevent server death
		end
		local n = param
		
		if not minepos[name] then
			minetest.chat_send_player(name, "You don't have a mine`s now! Set it using /setmine <name>")
			return
		end
		if minepos[name][n] then
			local time = get_time()
            if cooldown ~= 0 and last_moved[name] ~= nil and time - last_moved[name] < cooldown then
				minetest.chat_send_player(name, "You can teleport only once in "..cooldown.." seconds. Wait another "..round(cooldown - (time - last_moved[name]), 3).." secs...")
			end
			local pos = player:getpos()
			local dst = distance(pos, minepos[name][n])
			if max_distance ~= 0 and distance(pos, minepos[name][n]) > max_distance then
				minetest.chat_send_player(name, "You are too far away from your mine. You must be "..round(dst - max_distance, 3).." meters closer to teleport to your mine.")
			end
			last_moved[name] = time
			player:setpos(minepos[name][n])
            minetest.chat_send_player(name, "Teleported to mine!")
        else
            minetest.chat_send_player(name, "You don't have a mine "..n.." now! Set it using /setmine <name>")
        end
    end,
})
 
minetest.register_chatcommand("mines" , {
	params = "",
	description = "List of mines",
	privs = {},
	func = function(name, param)
        if player == nil then
			-- just a check to prevent server death
		end
		if not minepos[name] then
			minetest.chat_send_player(name, "You don't have a mine`s now! Set it using /setmine <name>")
			return
		end
		local text = ""
		for i, v in pairs(minepos[name]) do
			text = text.."\n"..i..minetest.pos_to_string(vector.round(v))
		end
        minetest.chat_send_player(name, text)
    end,
    
}) 
 
local delta = 0

minetest.register_globalstep(function(dtime)
    delta = delta + dtime
    -- save it every <save_delta> seconds
    if delta > save_delta then
        delta = delta - save_delta
	if changed then
	    local output = io.open(mines_file, "w")
		local text = minetest.serialize(minepos)
			output:write(text)
			io.close(output)
		end
	changed = false
    end
end)

