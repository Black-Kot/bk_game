-- Original code by stujones11
-- https://github.com/stujones11/wield3d

dofile(minetest.get_modpath(minetest.get_current_modname()).."/location.lua")

local update_time = 1 -- number of seconds between wielditem updates
local location = {
	"Armature_Arm_Right",  -- default bone
	{x=0, y=6, z=2.5},   -- default position
	{x=0, y=135, z=180}, -- default rotation
}

local location_tools = {
	"Armature_Arm_Right",
	{x=0, y=6, z=2.5},
	{x=-100, y=225, z=90}
}

local location_craftitems = {
	"Armature_Arm_Right",
	{x=0, y=6, z=2.5},
	{x=90, y=-35, z=90}
}

local player_wielding = {}
local timer = 0

local function add_wield_entity(player)
	player:set_properties({
		visual = "mesh",
		mesh = "wield_character.x",
		visual_size = {x=1, y=1},
	})
	local pos = player:getpos()
	if pos then
		local object = minetest.add_entity(pos, "wield:wield_entity")
		if object then
			object:set_attach(player, location[1], location[2], location[3])
			local luaentity = object:get_luaentity()
			if luaentity then
				luaentity.player = player
				return 1
			end
		end
	end
end

minetest.register_item("wield:hand", {
	type = "none",
	wield_image = "wield_transparent.png",
})

minetest.register_entity("wield:wield_entity", {
	physical = false,
	collisionbox = {x=0, y=0, z=0},
	visual = "wielditem",
	visual_size = {x=0.2, y=0.2},
	textures = {"wield:hand"},
	player = nil,
	item = nil,
	timer = 0,
	location = location,
	on_step = function(self, dtime)
		self.timer = self.timer + dtime
		if self.timer > update_time then
			return
		end
		self.timer = 0
		local player = self.player
		if player then
			local pos = player:getpos()
			if pos then
				local stack = player:get_wielded_item()
				local item = stack:get_name()
				if item == self.item then
					return
				end
				self.item = item
				if item == "" then
					item = "wield:hand"
				end
				local loc = wield_location[item] or location
				if string.match(item, "tools:") then
					loc = location_tools
				elseif minetest.registered_craftitems[item] ~= nil then
					loc = location_craftitems
				end
				if loc[1] ~= self.location[1]
				or vector.equals(loc[2], self.location[2]) == false
				or vector.equals(loc[3], self.location[3]) == false then
					self.object:setpos(pos)
					self.object:set_detach()
					self.object:set_attach(player, loc[1], loc[2], loc[3])
					self.location = loc
				end
				self.object:set_properties({textures={item}})
				return
			end
		end
		self.object:remove()
	end,
})

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > update_time then
		for _,player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			if name then
				if not player_wielding[name] then
					player_wielding[name] = add_wield_entity(player)
				end
			end
		end
		timer = 0
	end
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		player_wielding[name] = nil
	end
end)

