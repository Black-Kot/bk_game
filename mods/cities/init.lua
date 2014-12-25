local cities = {}
local cities_file = minetest.get_worldpath().."/cities"
local spawns = {}
local spawns_file =  minetest.get_worldpath().."/spawns"
local changed = false


function load()
	local input = io.open(cities_file, "r")
    if input ~= nil then
    local text = ""
	for line in input:lines() do
		text = text..line
	end
    cities = minetest.deserialize(text)
    io.close(input)
    end
    if not cities then
		cities = {}
	end

	local input = io.open(spawns_file, "r")
    if input ~= nil then
    local text = ""
	for line in input:lines() do
		text = text..line
	end
    spawns = minetest.deserialize(text)
    io.close(input)
    end
    if not spawns then
		spawns = {}
	end
end

load()

minetest.register_privilege("city", {
	description = "Player can register city",
	give_to_singleplayer = false,
})

minetest.register_on_chat_message(function(name, message, playername, player)
    local city = string.match(message, "^/([^ ]+)")
    if cities[city] then
        local player = minetest.get_player_by_name(name)
        minetest.chat_send_player(player:get_player_name(), "Teleporting to "..city.."...")
        player:setpos(cities[city])
        return true
    else
		return false
	end
end)


minetest.register_chatcommand("setcity", {
	params = "<name>",
	description = "Set city",
	privs = {city=true},
	func = function(name, param)
		local can_access = minetest.check_player_privs(name, {city=true})
		if not can_access then
			minetest.chat_send_player(name, "You can`t set city!")
			return
		end
		local city = param
		local player = minetest.get_player_by_name(name)
		local pos = player:getpos()
		cities[city] = pos
		minetest.chat_send_all("Registered new city " .. city .. " at position " .. minetest.pos_to_string(pos))
		changed = true
	end,
})

minetest.register_chatcommand("delcity", {
	params = "<name>",
	description = "Del city",
	privs = {city=true},
	func = function(name, param)
		local can_access = minetest.check_player_privs(name, {city=true})
		if not can_access then
			minetest.chat_send_player(name, "You can`t set city!")
			return
		end
		local city = param
		if not cities[city] then
			minetest.chat_send_player(name, "Unknow city!")
			return
		end
		local pos = cities[city]
		removekey(cities, city)
		minetest.chat_send_all("Delete`d city " .. city .. " at position " .. minetest.pos_to_string(pos))
		changed = true
	end,
})

minetest.register_chatcommand("setspawn", {
	params = "<name>",
	description = "Set city for spawn point",
	privs = {},
	func = function(name, param)
		local city = param
		if not cities[city] then
			minetest.chat_send_player(name, "Unknow city!")
			return
		end
		spawns[name] = city
		minetest.chat_send_player(name, "Set spawn city ok!")
		changed = true
	end,
})

minetest.register_chatcommand("cities", {
	params = "<name>",
	description = "List known cities",
	privs = {},
	func = function(name, param)
		for n, p in pairs(cities) do
			minetest.chat_send_player(name, string.format("%s: %s",n,minetest.pos_to_string(vector.round(p))))
		end
	end
})

--Deds to Spawn
minetest.register_on_newplayer(function(player)
	if spawns[name] then
		player:setpos(cities[spawns[name]])
	else
		if not cities["spawn"] then
			cities["spawn"] = player:getpos()
		else
			player:setpos(cities["spawn"])
		end
	end
end)

--Deds to Spawn
minetest.register_on_respawnplayer(function(player, pos)
	local name = player:get_player_name()
	if spawns[name] and cities[spawns[name]] then
		player:setpos(cities[spawns[name]])
	else
		player:setpos(cities["spawn"])
    end
    return true
end)

local delta = 0

minetest.register_globalstep(function(dtime)
	if changed then
		local output = io.open(cities_file, "w")
		local text = minetest.serialize(cities)
		output:write(text)
		io.close(output)

		local output = io.open(spawns_file, "w")
		local text = minetest.serialize(spawns)
		output:write(text)
		io.close(output)
		changed = false
    end
end)
